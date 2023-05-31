defmodule DoNothing.IO do
  @callback output(String.t()) :: :ok

  @callback prompt_to_begin :: :ok

  @callback prompt_step_completion :: :ok
end
