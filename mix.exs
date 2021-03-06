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
    #[applications: [:logger]]
  end

  defp deps do
    [{:slack, "~> 0.4.1"},
     {:websocket_client, git: "https://github.com/jeremyong/websocket_client"},
     {:csv, "~> 1.3.0"},
     {:gibran, "~> 0.0.2"}
    ]
  end
end
