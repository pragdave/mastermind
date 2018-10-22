defmodule Mastermind.MixProject do
  use Mix.Project

  def project do
    [
      app:     :mastermind,
      version: "0.1.0",
      elixir:  ">= 1.6.0",
      start_permanent: Mix.env() == :prod,
    ]
  end
end
