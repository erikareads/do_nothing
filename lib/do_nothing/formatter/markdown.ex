defmodule DoNothing.Formatter.Markdown do
  @moduledoc """
  Default implementations for the `DoNothing.Formatter` callbacks.
  """
  alias DoNothing.Formatter
  @behaviour Formatter

  @impl Formatter
  def header(procedure) do
    """
    # #{procedure.title}

    #{procedure.description}

    """
  end

  @impl Formatter
  def step_title(step, _state) do
    """
    ## #{step.title}

    """
  end

  @impl Formatter
  def automated_note(_step) do
    """
    This step will be automated when you run this procedure.

    """
  end

  @impl Formatter
  def automated_note(_step, _state) do
    """
    Executing step automatically.

    """
  end

  @impl Formatter
  def step_instructions(step) do
    """
    #{step.instructions}

    """
  end

  @impl Formatter
  def step_instructions(step, state) do
    """
    #{EEx.eval_string(step.instructions, assigns: state)}

    """
  end

  @impl Formatter
  def automated_output(automation, result, _state) do
    """
    **Outputs**: 
      - `#{automation.output}`: #{inspect(result)}

    """
  end

  @impl Formatter
  def completed(_procedure, _state) do
    """
    done!
    """
  end
end
