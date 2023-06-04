defmodule DoNothing.Procedure do
  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t(),
          steps: [DoNothing.Step.t()]
        }

  defstruct [:title, :description, :steps]
end
