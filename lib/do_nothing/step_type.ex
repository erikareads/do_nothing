defmodule DoNothing.StepType do
  @moduledoc false
  @spec step_type(DoNothing.Automation.t()) :: :manual | :automated
  def step_type(step) do
    case step.automation do
      %DoNothing.Automation{} -> :automated
      nil -> :manual
      _ -> raise "should have failed at compile step"
    end
  end
end
