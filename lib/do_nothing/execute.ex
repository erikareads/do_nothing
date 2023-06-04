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

    automation = step.automation

    result =
      case automation.execute do
        {module, function} ->
          apply(module, function, get_inputs(automation, state))

        function ->
          apply(function, get_inputs(automation, state))
      end

    if not is_nil(automation.output) do
      config.formatter.automated_output(automation, result, state) |> config.io.output()

      Map.put(state, automation.output, result)
    else
      state
    end
  end

  defp get_inputs(automation, state) do
    Enum.map(automation.inputs, &Map.fetch!(state, &1))
  end

  defp handle_manual(step, state, config) do
    config.formatter.step_title(step, state) |> config.io.output()
    config.formatter.step_instructions(step, state) |> config.io.output()
    config.io.prompt_step_completion()
    state
  end
end
