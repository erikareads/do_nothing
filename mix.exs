defmodule DoNothing.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/erikareads/do_nothing"

  @description "A gradual automation scripting framework and DSL."

  def project do
    [
      app: :do_nothing,
      name: "DoNothing",
      description: @description,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      source_url: @source_url
    ]
  end

  defp docs do
    [
      main: "DoNothing",
      source_ref: "v#{@version}",
      source_url: @source_url,
      groups_for_modules: [
        Config: [DoNothing.Config],
        "Config Behaviours": [DoNothing.Formatter, DoNothing.IO],
        "Default Behaviours Implementations": [DoNothing.Formatter.Markdown, DoNothing.IO.StdIO]
      ]
    ]
  end

  defp package do
    [
      name: :do_nothing,
      licenses: ["MIT"],
      links: %{"Github" => @source_url},
      source_url: @source_url,
      maintainers: [
        "Erika Rowland"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gradient, github: "esl/gradient", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end
end
