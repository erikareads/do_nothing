defmodule DoNothing.Formatter do
  alias DoNothing.Automation
  alias DoNothing.Step

  @type state :: map()

  @callback header(procedure :: DoNothing.Execute.Procedure.t()) :: String.t()

  @callback step_title(step :: Step.t(), state :: state()) :: String.t()

  @callback step_instructions(step :: Step.t()) :: String.t()

  @callback step_instructions(step :: Step.t(), state :: state()) :: String.t()

  @callback automated_note(step :: Step.t()) :: String.t()

  @callback automated_note(step :: Step.t(), state :: state()) :: String.t()

  @callback automated_output(automation :: Automation.t(), result :: any(), state :: state()) ::
              String.t()

  @callback completed(procedure :: DoNothing.Execute.Procedure.t(), state :: state()) ::
              String.t()
end
