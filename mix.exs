defmodule SSS.MixProject do
  use Mix.Project

  def project do
    [
      app: :sss,
      version: "0.1.0",
      elixir: "~> 1.18",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "sss",
      source_url: "https://github.com/congnghia0609/sss"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # extra_applications: [:logger]
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.37.1", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "sss is an implement of Shamir's Secret Sharing Algorithm 256-bits in Elixir."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "sss",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/congnghia0609/sss"}
    ]
  end
end
