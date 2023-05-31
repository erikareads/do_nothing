defmodule DoNothing.Extension do
  defmodule Step do
    @type t :: %__MODULE__{
            id: atom(),
            title: String.t(),
            instructions: String.t(),
            run: [DoNothing.Extension.Run.t()]
          }
    defstruct [:id, :title, :instructions, :run]
  end

  defmodule Run do
    @type t :: %__MODULE__{
            execute: {module(), atom()} | fun(),
            output: atom(),
            inputs: [atom()]
          }
    defstruct [:execute, :output, inputs: []]
  end

  @step_schema [
    id: [
      type: :atom,
      required: true
    ],
    title: [
      type: :string,
      required: true
    ],
    instructions: [
      type: :string,
      required: false
    ]
  ]

  @step %Spark.Dsl.Entity{
    name: :step,
    describe: "Adds a step",
    target: Step,
    entities: [
      run: [
        %Spark.Dsl.Entity{
          name: :run,
          target: Run,
          schema: [
            inputs: [type: {:list, :atom}, required: false],
            output: [type: :atom, required: false],
            execute: [type: :fun, required: true]
          ],
          transform: {DoNothing.Extension, :confirm_arity, []}
        }
      ]
    ],
    singleton_entity_keys: [:run],
    schema: @step_schema
  }

  def confirm_arity(run) do
    function_info = run.execute |> :erlang.fun_info
    function_arity = function_info[:arity] 
    inputs_length = length(run.inputs)
    if function_arity === inputs_length do
      {:ok, run}
    else
      {:error, "execute has arity #{function_arity}, but inputs has length #{inputs_length}, these must match"}
    end
  end

  @procedure %Spark.Dsl.Section{
    # The DSL constructor will be `procedure`
    name: :procedure,
    describe: """
    Configure the DoNothing procedure.
    """,
    entities: [
      # See `Spark.Dsl.Entity` docs
      @step
    ],
    top_level?: true,
    schema: [
      title: [
        type: :string
      ],
      description: [
        type: :string
      ]
    ]
  }

  use Spark.Dsl.Extension, sections: [@procedure]
end
