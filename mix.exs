defmodule Magic.Mixfile do
  use Mix.Project

  def project do
    [app: :magic,
     version: "0.3.7",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     description: description(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [mod: {Magic.App, []},
     extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:credo, "~> 0.7", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.5", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:meck, "~> 0.8.4", only: :test},
    ]
  end

  defp description do
    ~S"""
    A set of common libraries.
    """
  end

  defp package do
    [
      name: :magic,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Ray Wang(pivstone@gmail.com)"],
      licenses: ["MIT licenses"],
      links: %{"GitHub" => "https://github.com/pivstone/Magic"}
    ]
  end
end
