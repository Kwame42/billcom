defmodule Billcom.MixProject do
  use Mix.Project

  def project do
    [
      app: :billcom,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/Kwame42/billcom",
      name: "Billcom",
      package: package(),
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["BSD-4-Clause"],
      links: %{"GitHub" => "https://github.com/Kwame42/billcom"}
    ]
  end

  defp description() do
    "Library to access bill.com api"
  end
end
