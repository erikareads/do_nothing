defmodule DoNothing.Config do
  @type t :: %__MODULE__{
          formatter: module(),
          io: module()
        }
  defstruct formatter: DoNothing.Formatter.Markdown, io: DoNothing.IO.StdIO
end

defmodule DoNothing.StepType do
  @spec step_type(DoNothing.Extension.Step.t()) :: :manual | :automated
  def step_type(step) do
    case step.run do
      %DoNothing.Extension.Run{} -> :automated
      nil -> :manual
      _ -> raise "should have failed at compile step"
    end
  end
end

defmodule DoNothing.Procedure do
  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t(),
          steps: DoNothing.Extension.Step.t()
        }
  defstruct [:title, :description, :steps]
  @spec load_procedure(module()) :: Procedure.t()
  def load_procedure(module) do
    %__MODULE__{
      title: Spark.Dsl.Extension.get_opt(module, [:procedure], :title),
      description: Spark.Dsl.Extension.get_opt(module, [:procedure], :description),
      steps: Spark.Dsl.Extension.get_entities(module, [:procedure])
    }
  end
end

defmodule DoNothing.Renderer do
  alias DoNothing.Procedure

  def render(procedure, config \\ %DoNothing.Config{}) do
    (config.formatter.header(procedure) <>
       (Enum.map(procedure.steps, &render_step(&1, config)) |> Enum.join()))
    |> config.io.output()
  end

  def render_step(step, config) do
    case DoNothing.StepType.step_type(step) do
      :automated -> render_automated(step, config)
      :manual -> render_manual(step, config)
    end
  end

  defp render_automated(step, config) do
    config.formatter.step_title(step, %{}) <>
      config.formatter.automated_note(step) <>
      if not is_nil(step.instructions) do
        config.formatter.step_instructions(step)
      else
        ""
      end
  end

  defp render_manual(step, config) do
    config.formatter.step_title(step, %{}) <>
      config.formatter.step_instructions(step)
  end
end

defmodule DoNothing.Execute do
  alias DoNothing.Procedure

  @spec execute(Procedure.t(), DoNothing.Config.t()) :: :ok
  def execute(procedure, config \\ %DoNothing.Config{}) do
    config.formatter.header(procedure) |> config.io.output()
    config.io.prompt_to_begin()
    state = %{}

    Enum.reduce(procedure.steps, state, &execute_step(&1, &2, config))
    config.formatter.completed(procedure, state) |> config.io.output
  end

  def execute_step(step, state, config) do
    state =
      case DoNothing.StepType.step_type(step) do
        :automated -> handle_automated(step, state, config)
        :manual -> handle_manual(step, state, config)
      end

    state
  end

  def handle_automated(step, state, config) do
    config.formatter.step_title(step, state) |> config.io.output()
    config.formatter.automated_note(step, state) |> config.io.output()

    run = step.run

    result =
      case run.execute do
        {module, function} ->
          apply(module, function, get_inputs(run, state))

        function ->
          apply(function, get_inputs(run, state))
      end

    if not is_nil(run.output) do
      config.formatter.automated_output(run, result, state) |> config.io.output()

      Map.put(state, run.output, result)
    else
      state
    end
  end

  def get_inputs(run, state) do
    Enum.map(run.inputs, &Map.get(state, &1))
  end

  def handle_manual(step, state, config) do
    config.formatter.step_title(step, state) |> config.io.output()
    config.formatter.step_instructions(step, state) |> config.io.output()
    config.io.prompt_step_completion()
    state
  end
end
