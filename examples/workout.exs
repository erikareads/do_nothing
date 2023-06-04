#!/usr/bin/env elixir

Mix.install([{:do_nothing, github: "erikareads/do_nothing", tag: "v0.1.0"}])

defmodule Workout.Timer do
  def timer(duration, unit \\ :seconds)

  def timer(duration, :minutes) do
    timer(duration * 60, :seconds)
  end

  def timer(duration, :seconds) do
    for second <- duration..1//-1 do
      IO.write(IO.ANSI.clear_line() <> "#{format(second)}\r")
      :timer.sleep(1000)
    end
  end

  defp format(seconds) do
    hours = div(seconds, 3600)
    minutes = div(seconds - hours * 3600, 60)
    seconds = rem(seconds - hours * 3600, 60)
    [hours, minutes, seconds] |> Enum.map(&stringify/1) |> Enum.join(":")
  end

  defp stringify(time) do
    time |> to_string() |> String.pad_leading(2, "0")
  end
end

DoNothing.procedure(
  title: "Push and Core workout",
  description: "This workout involves doing pushing and leg lift related exercises"
)
|> DoNothing.add_step(title: "Pushups first set", instructions: "Do 15 pushups")
|> DoNothing.add_step(
  title: "Wait 20 seconds",
  automation: DoNothing.automate(execute: fn -> Workout.Timer.timer(20, :seconds) end)
)
|> DoNothing.add_step(title: "Pushups second set", instructions: "Do 15 pushups")
|> then(
  &Enum.reduce(1..4, &1, fn _, procedure ->
    DoNothing.add_step(procedure, title: "Leg Raises", instructions: "Do 20 leg raises")
    |> DoNothing.add_step(
      title: "Wait 20 seconds",
      automation: DoNothing.automate(execute: fn -> Workout.Timer.timer(20, :seconds) end)
    )
  end)
)
|> DoNothing.add_step(title: "Pushups third set", instructions: "Do 15 pushups")
|> DoNothing.execute()
