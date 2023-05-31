defmodule DoNothing.StepType do
  @moduledoc false
  @spec step_type(DoNothing.Extension.Step.t()) :: :manual | :automated
  def step_type(step) do
    case step.run do
      %DoNothing.Extension.Run{} -> :automated
      nil -> :manual
      _ -> raise "should have failed at compile step"
    end
  end
end
