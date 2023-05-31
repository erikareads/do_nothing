defmodule DoNothing.Execute do
  @moduledoc false
  alias DoNothing.Procedure

  @spec execute(Procedure.t(), DoNothing.Config.t()) :: :ok
  def execute(procedure, config \\ %DoNothing.Config{}) do
    config.formatter.header(procedure) |> config.io.output()
    config.io.prompt_to_begin()
    state = %{}

    Enum.reduce(procedure.steps, state, &execute_step(&1, &2, config))
    config.formatter.completed(procedure, state) |> config.io.output
  end

  defp execute_step(step, state, config) do
    state =
      case DoNothing.StepType.step_type(step) do
        :automated -> handle_automated(step, state, config)
        :manual -> handle_manual(step, state, config)
      end

    state
  end

  defp handle_automated(step, state, config) do
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

  defp get_inputs(run, state) do
    Enum.map(run.inputs, &Map.get(state, &1))
  end

  defp handle_manual(step, state, config) do
    config.formatter.step_title(step, state) |> config.io.output()
    config.formatter.step_instructions(step, state) |> config.io.output()
    config.io.prompt_step_completion()
    state
  end
end
