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

```
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

## Feature Showcase

![demo.exs animation](/.assets/demo.gif)

```elixir
#!/usr/bin/env elixir

Mix.install([{:do_nothing, github: "erikareads/do_nothing", tag: "v0.1.0"}])

DoNothing.procedure(
  title: "Demo procedure",
  description: "A procedure that demonstrates the features of the DoNothing framework"
)
|> DoNothing.add_step(
  title: "Prompt for a manual step",
  instructions:
    "Instructions allow us to prompt an operator to do a manual step, and the script will hold their place until they press [Enter]"
)
|> DoNothing.add_step(
  title: "Automate some code",
  automation:
    DoNothing.automate(
      execute: fn -> IO.puts("Side Effect -> this has a side effect when the script runs.\n") end
    )
)
|> DoNothing.add_step(
  title: "Automation can have outputs",
  automation:
    DoNothing.automate(
      execute: fn -> "output string that I care about" end,
      output: :output_value_name
    )
)
|> DoNothing.add_step(
  title: "Instructions can interpolate",
  instructions: "Instructions can interpolate from output: <%= @output_value_name %>"
)
|> DoNothing.add_step(
  title: "Automation input from previous steps",
  automation:
    DoNothing.automate(execute: fn string -> IO.puts(string) end, inputs: [:output_value_name])
)
|> DoNothing.add_step(
  title: "Automation output can be any Elixir term",
  automation:
    DoNothing.automate(
      execute: fn input -> %{non_string: input} end,
      inputs: [:output_value_name],
      output: :non_string_output
    )
)
|> DoNothing.add_step(
  title: "Automation can have multiple inputs",
  automation:
    DoNothing.automate(
      execute: &Map.get(&2, &1, "default value"),
      inputs: [:output_value_name, :non_string_output],
      output: :should_be_default
    )
)
|> DoNothing.add_step(
  title: "Interpolation must be with a string",
  instructions:
    "Can't interpolate a map :non_string_output, but you can stringify it first: inspect(<%= inspect(@non_string_output) %>)"
)
|> DoNothing.execute()
```

Outputs:

```
# Demo procedure

A procedure that demonstrates the features of the DoNothing framework

[Enter] to begin

## Prompt for a manual step

Instructions allow us to prompt an operator to do a manual step, and the script will hold their place until they press [Enter]

[Enter] when done

## Automate some code

Executing step automatically.

Side Effect -> this has a side effect when the script runs.

## Automation can have outputs

Executing step automatically.

**Outputs**:
  - `output_value_name`: "output string that I care about"

## Instructions can interpolate

Instructions can interpolate from output: output string that I care about

[Enter] when done

## Automation input from previous steps

Executing step automatically.

output string that I care about
## Automation output can be any Elixir term

Executing step automatically.

**Outputs**:
  - `non_string_output`: %{non_string: "output string that I care about"}

## Automation can have multiple inputs

Executing step automatically.

**Outputs**:
  - `should_be_default`: "default value"

## Interpolation must be with a string

Can't interpolate a map :non_string_output, but you can stringify it first: inspect(%{non_string: "output string that I care about"})

[Enter] when done

done!
```
