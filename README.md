# DoNothing

A gradual automation scripting framework and DSL.

## Usage

```elixir
#!/usr/bin/env elixir

Mix.install([{:do_nothing, github: "erikareads/do_nothing", tag: "v0.1.0"}])

DoNothing.procedure(
  title: "Example procedure", 
  description: "A description of the procedure..."
)
|> DoNothing.add_step(
  title: "A first step", 
  instructions: "The instructions to follow for the first step."
)
|> DoNothing.add_step(
  title: "A second step", 
  instructions: "The instructions..."
)
|> DoNothing.execute()
```

Running this script will output the following:

```sh
# Example procedure

A description of the procedure...

[Enter] to begin

## A first step

The instructions to follow for the first step.

[Enter] when done

## A second step

The instructions...

[Enter] when done

done!
```
