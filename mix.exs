defmodule DoNothing.MixProject do
  use Mix.Project

  def project do
    [
      app: :do_nothing,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:spark, ">= 0.0.0"},
      {:gradient, github: "esl/gradient", only: [:dev], runtime: false}
    ]
  end
end
