defmodule DoNothing do
  defmodule Step do
    @type t :: %__MODULE__{
            title: String.t(),
            instructions: String.t(),
            automation: [DoNothing.Automation.t()]
          }
    defstruct [:title, :instructions, :automation]
  end

  defmodule Automation do
    @type t :: %__MODULE__{
            execute: fun(),
            output: atom(),
            inputs: [atom()]
          }
    defstruct [:execute, :output, inputs: []]
  end

  def execute(procedure, config \\ %DoNothing.Config{}) do
    procedure
    |> DoNothing.Execute.execute(config)
  end

  def render(procedure, config \\ %DoNothing.Config{}) do
    procedure
    |> DoNothing.Renderer.render(config)
  end

  @type procedure_fields :: {:title, String.t()} | {:description, String.t()}

  @spec procedure([procedure_fields]) :: DoNothing.Procedure.t()
  def procedure(procedure_fields) do
    title = parse_procedure_title!(procedure_fields)
    description = parse_procedure_description!(procedure_fields)
    %DoNothing.Procedure{title: title, description: description, steps: []}
  end

  defp parse_procedure_title!(procedure_fields) do
    case Keyword.get(procedure_fields, :title) do
      title when is_binary(title) -> title
      _title -> raise "Title is required and must be a string."
    end
  end

  defp parse_procedure_description!(procedure_fields) do
    case Keyword.get(procedure_fields, :description) do
      description when is_binary(description) -> description
      _description -> raise "Description is required and must be a string."
    end
  end

  @type step_fields ::
          {:title, String.t()}
          | {:instructions, String.t()}
          | {:automation, DoNothing.Automation.t()}
  @spec add_step(DoNothing.Procedure.t(), [step_fields]) :: DoNothing.Procedure.t()
  def add_step(procedure, step_fields) do
    title = parse_step_title!(step_fields)
    instructions = parse_step_instructions!(step_fields)
    automation = parse_step_automation!(step_fields)
    validate_instructions_or_automation!(instructions, automation)
    validate_output_key_shadowing!(procedure, automation)
    validate_inputs_exist!(procedure, automation)

    %DoNothing.Procedure{
      procedure
      | steps:
          procedure.steps ++
            [%Step{title: title, instructions: instructions, automation: automation}]
    }
  end

  defp validate_inputs_exist!(procedure, automation) do
    used_output_keys = collect_keys(procedure)

    if not is_nil(automation) do
      for input <- automation.inputs do
        if input not in used_output_keys do
          raise "#{input} hasn't been assigned an output by a previous step"
        end
      end
    end
  end

  defp collect_keys(procedure) do
    procedure.steps
    |> Enum.reduce([], fn step, acc ->
      cond do
        not is_nil(step.automation) && not is_nil(step.automation.output) ->
          [step.automation.output | acc]

        true ->
          acc
      end
    end)
  end

  defp validate_output_key_shadowing!(procedure, automation) do
    if not is_nil(automation) && not is_nil(automation.output) do
      used_output_keys = collect_keys(procedure)

      if automation.output in used_output_keys do
        raise "Can't shadow an output key name"
      end
    end
  end

  defp validate_instructions_or_automation!(instructions, automation) do
    if is_nil(instructions) and is_nil(automation) do
      raise "A step must have instructions or automation"
    end
  end

  defp parse_step_automation!(step_fields) do
    case Keyword.get(step_fields, :automation) do
      automation when is_struct(automation, DoNothing.Automation) -> automation
      nil -> nil
      _automation -> raise "Instructions must be a string"
    end
  end

  defp parse_step_instructions!(step_fields) do
    case Keyword.get(step_fields, :instructions) do
      instructions when is_binary(instructions) -> instructions
      nil -> nil
      _instructions -> raise "Instructions must be a string"
    end
  end

  defp parse_step_title!(step_fields) do
    case Keyword.get(step_fields, :title) do
      title when is_binary(title) -> title
      _title -> raise "Title is required and must be a string"
    end
  end

  @type automate_fields :: {:execute, (... -> any())} | {:inputs, [atom()]} | {:output, atom()}

  @spec automate([automate_fields]) :: DoNothing.Automation.t()
  def automate(automate_fields) do
    execute = parse_execute!(automate_fields)
    inputs = parse_inputs!(automate_fields)
    output = parse_output!(automate_fields)
    validate_arity_match!(execute, inputs)

    %DoNothing.Automation{execute: execute, inputs: inputs, output: output}
  end

  defp validate_arity_match!(execute, inputs) do
    {:arity, arity} = Function.info(execute, :arity)

    if arity == length(inputs) do
      :ok
    else
      raise "Arity of execute and length of inputs must match"
    end
  end

  defp parse_output!(automate_fields) do
    case Keyword.get(automate_fields, :output) do
      output when is_atom(output) -> output
      output when is_nil(output) -> output
      _output -> raise "Output must be an atom"
    end
  end

  defp parse_execute!(automate_fields) do
    case Keyword.get(automate_fields, :execute) do
      execute when is_function(execute) -> execute
      _execute -> raise "Execute must be a function"
    end
  end

  defp parse_inputs!(automate_fields) do
    inputs = Keyword.get(automate_fields, :inputs)

    cond do
      is_list(inputs) and Enum.all?(inputs, &is_atom/1) ->
        inputs

      is_nil(inputs) ->
        []

      not is_list(inputs) ->
        raise "Inputs must be a list of atoms"

      not Enum.all?(inputs, &is_atom/1) ->
        raise "Inputs must be a list of atoms"
    end
  end
end
