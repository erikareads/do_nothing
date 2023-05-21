#!/usr/bin/env elixir

Mix.install([{:do_nothing, git: "git@github.com:erikareads/do_nothing.git"}])

defmodule Tidy do
  use DoNothing

  title "Tidy apartment"
  description "Keep track of the steps required to tidy an apartment"

  step do
    id :pickup_trash
    title "Pick up all trash on floor"
    instructions "Grab a trash bag and pick up all non-paper trash on the floor of the apartment"
  end

  step do
    id :pickup_recycling
    title "Pick up all recycling on the floor"

    instructions "Pick the largest box. Break down all boxes that are smaller than that and insert. Take the larger box to the recycling."
  end
end

DoNothing.execute(Tidy)
