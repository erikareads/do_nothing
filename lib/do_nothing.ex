defmodule DoNothing do
  use Spark.Dsl,
    default_extensions: [extensions: DoNothing.Extension]

  def execute(resource) do
    DoNothing.Procedure.load_procedure(resource)
    |> DoNothing.Execute.execute()
  end

  def render(module) do
    DoNothing.Procedure.load_procedure(module)
    |> DoNothing.Renderer.render()
  end
end
