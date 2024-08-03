defmodule GG.MixProject do
  use Mix.Project

  def project do
    [
      app: :g_g,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GG.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:openai_ex, "~> 0.8"},
      {:nostrum, "~> 0.10"},
      {:igniter, "~> 0.3"},
      {:ash, "~> 3.3"}
    ]
  end
end
