#!/usr/bin/env elixir

Mix.install([{:do_nothing, github: "erikareads/do_nothing", tag: "v0.1.0"}])

DoNothing.procedure(
  title: "Tidy apartment",
  description: "Keep track of the steps required to tidy an apartment"
)
|> DoNothing.add_step(
  title: "Pick up all trash on the floor",
  instructions: "Grab a trash bag and pick up all non-paper trash on the floor of the apartment."
)
|> DoNothing.add_step(
  title: "Pick up all recycling on the floor",
  instructions:
    "Pick the largest box. Break down all boxes that are smaller than that and insert. Take the larger box to the recycling."
)
|> DoNothing.execute()
