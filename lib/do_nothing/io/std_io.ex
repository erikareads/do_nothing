defmodule DoNothing.IO.StdIO do
  @behaviour DoNothing.IO

  @impl DoNothing.IO
  defdelegate output(string), to: IO, as: :write

  @impl DoNothing.IO
  def prompt_to_begin do
    IO.gets("[Enter] to begin ")
    IO.puts("")
  end

  @impl DoNothing.IO
  def prompt_step_completion do
    IO.gets("[Enter] when done ")
    IO.puts("")
  end
end
