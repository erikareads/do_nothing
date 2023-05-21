defmodule DoNothing do
  use Spark.Dsl,
    default_extensions: [extensions: DoNothing.Extension]

  def execute(resource) do
    DoNothing.Execute.load_procedure(resource)
    |> DoNothing.Execute.execute()
  end

  def render(module) do
    DoNothing.Execute.load_procedure(module)
    |> DoNothing.Execute.render()
  end
end
