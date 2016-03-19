defmodule Slackye.Mixfile do
  use Mix.Project

  def project do
    [app: :slackye,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :slack],
     mod: {Slackye, []}]
  end

  defp deps do
    [{:slack, "~> 0.4.1"},
     {:websocket_client, git: "https://github.com/jeremyong/websocket_client"}]
  end
end
