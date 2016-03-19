defmodule Slackye.Slack do
  use Slack
  alias Slackye.Structs.State, as: State
  alias Slackye.Responder, as: Responder
  alias Slackye.Parser, as: Parser
  require Logger

  @slack_token Application.get_env(:slackye, :slack_token)

  def start_link do 
    fresh_state = %State{}
    start_link(@slack_token, fresh_state)
  end

  def handle_connect(slack, state) do
   IO.puts "Connected as #{slack.me.name}"
   {:ok, state}
  end

  # regular message
  def handle_message(message, slack, state) do
    Logger.debug inspect message

    parsed_msg = Parser.parse(message, slack)
    {response, new_state} = Responder.get_response(parsed_msg, state)
    if response, do: send_message(response, message.channel, slack)
    {:ok, new_state}
  end

  def handle_info(message, _slack, state) do
    Logger.debug inspect message

    {:ok, state}
  end
end
