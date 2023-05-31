defmodule DoNothing.Config do
  @type t :: %__MODULE__{
          formatter: module(),
          io: module()
        }
  defstruct formatter: DoNothing.Formatter.Markdown, io: DoNothing.IO.StdIO
end
