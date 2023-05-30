defmodule DoNothing.Execute do
  defmodule Procedure do
    @type t :: %__MODULE__{
            title: String.t(),
            description: String.t(),
            steps: DoNothing.Extension.Step.t()
          }
    defstruct [:title, :description, :steps]
  end

  @spec load_procedure(module()) :: Procedure.t()
  def load_procedure(module) do
    %Procedure{
      title: Spark.Dsl.Extension.get_opt(module, [:procedure], :title),
      description: Spark.Dsl.Extension.get_opt(module, [:procedure], :description),
      steps: Spark.Dsl.Extension.get_entities(module, [:procedure])
    }
  end

  @spec execute(Procedure.t()) :: :ok
  def execute(procedure) do
    put_header(procedure)
    prompt_to_begin()
    state = %{}

    Enum.reduce(procedure.steps, state, &execute_step/2)
    IO.puts("done!")
  end

  def render(procedure) do
    put_header(procedure)
    Enum.each(procedure.steps, &render_step/1)
  end

  def render_step(step) do
    case step_type(step) do
      :automated -> render_automated(step)
      :manual -> render_manual(step)
    end
  end

  defp render_step_instructions(step) do
    IO.puts(step.instructions)
    IO.puts("")
  end

  defp render_automated(step) do
    put_step_title(step)
    put_automated_note(step)

    if not is_nil(step.instructions) do
      render_step_instructions(step)
    end
  end

  defp render_manual(step) do
    put_step_title(step)
    render_step_instructions(step)
  end

  defp put_automated_note(_step) do
    IO.puts("""
    This step will be automated when you run this procedure.
    """)
  end

  defp put_header(procedure) do
    IO.puts("""
    # #{procedure.title}

    #{procedure.description}
    """)
  end

  defp prompt_to_begin do
    IO.gets("[Enter] to begin ")
    IO.puts("")
  end

  @spec step_type(DoNothing.Extension.Step.t()) :: :manual | :automated
  def step_type(step) do
    case step.run do
      %DoNothing.Extension.Run{} -> :automated
      nil -> :manual
      _ -> raise "Can't have more than one run in a step"
    end
  end

  def execute_step(step, state) do
    state =
      case step_type(step) do
        :automated -> handle_automated(step, state)
        :manual -> handle_manual(step, state)
      end

    state
  end

  def handle_automated(step, state) do
    put_step_title(step)
    put_automated_step_id(step)

    run = step.run

    output =
      case run.execute do
        {module, function} ->
          apply(module, function, get_inputs(run, state))

        function ->
          apply(function, get_inputs(run, state))
      end

    if not is_nil(run.output) do
      IO.puts("""
      **Outputs**: 
        - `#{run.output}`: #{inspect(output)}
      """)

      # This is completely unclear, please rename all of these variables
      Map.put(state, run.output, output)
    else
      state
    end
  end

  defp put_automated_step_id(step) do
    IO.puts("Executing step `#{step.id}` automatically.")
    IO.puts("")
  end

  def get_inputs(run, state) do
    Enum.map(run.inputs, &Map.get(state, &1))
  end

  defp put_step_title(step) do
    IO.puts(["## ", step.title])
    IO.puts("")
  end

  defp put_step_instructions(step, state) do
    IO.puts(EEx.eval_string(step.instructions, assigns: state))
    IO.puts("")
  end

  def prompt_step_completion do
    IO.gets("[Enter] when done ")
    IO.puts("")
  end

  def handle_manual(step, state) do
    put_step_title(step)
    put_step_instructions(step, state)
    prompt_step_completion()
    state
  end
end
