#!/usr/bin/env elixir

Mix.install([{:do_nothing, github: "erikareads/do_nothing", tag: "v0.1.0"}, {:owl, "~> 0.7.0"}])

defmodule FancyBar do
  def fancy_bar do
    Owl.ProgressBar.start(id: :users, label: "Loading...", total: 100)

    Enum.each(1..100, fn _ ->
      Process.sleep(10)
      Owl.ProgressBar.inc(id: :users)
    end)

    Owl.LiveScreen.await_render()
  end
end

DoNothing.procedure(title: "Owl Spinner", description: "An example with ASCII art")
|> DoNothing.add_step(title: "Do a thing", instructions: "Do something")
|> DoNothing.add_step(
  title: "Wait",
  automation:
    DoNothing.automate(
      execute: fn ->
        Owl.Spinner.run(
          fn -> Process.sleep(5_000) end,
          labels: [ok: "Done", error: "Failed", processing: "Please wait..."]
        )
      end
    )
)
|> DoNothing.add_step(
  title: "loading bar",
  automation: DoNothing.automate(execute: &FancyBar.fancy_bar/0)
)
|> DoNothing.add_step(title: "another step", instructions: "...")
|> DoNothing.execute()
