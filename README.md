# DoNothing

A gradual automation scripting framework and DSL.

## Usage

```elixir
#!/usr/bin/env elixir

Mix.install([{:do_nothing, git: "git@github.com:erikareads/do_nothing.git"}])

defmodule MyScript do
  use DoNothing

  title "Example procedure"
  description "A description of the procedure..."

  step do
    id :first_step
    title "A first step"
    instrutions "The instructions to follow for the first step."
  end

  step do
    id :second_step
    title "A second step"
    instructions "The instructions..."
  end
end

DoNothing.execute(MyScript)
```
