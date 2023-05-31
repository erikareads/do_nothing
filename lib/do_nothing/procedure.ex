defmodule DoNothing.Procedure do
  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t(),
          steps: DoNothing.Extension.Step.t()
        }
  defstruct [:title, :description, :steps]

  @doc false
  @spec load_procedure(module()) :: Procedure.t()
  def load_procedure(module) do
    %__MODULE__{
      title: Spark.Dsl.Extension.get_opt(module, [:procedure], :title),
      description: Spark.Dsl.Extension.get_opt(module, [:procedure], :description),
      steps: Spark.Dsl.Extension.get_entities(module, [:procedure])
    }
  end
end
