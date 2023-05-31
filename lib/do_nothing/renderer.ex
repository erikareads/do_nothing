defmodule DoNothing.Renderer do
  @moduledoc false
  alias DoNothing.Config
  alias DoNothing.Procedure

  @spec render(Procedure.t(), Config.t()) :: :ok
  def render(procedure, config \\ %DoNothing.Config{}) do
    (config.formatter.header(procedure) <>
       (Enum.map(procedure.steps, &render_step(&1, config)) |> Enum.join()))
    |> config.io.output()
  end

  defp render_step(step, config) do
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
