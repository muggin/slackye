defmodule Slackye.Slack do
  require Logger
  use Slack

  @slack_token Application.get_env(:slackye, :slack_token)
  defp get_timestamp do
    date_time = :calendar.universal_time()
    :calendar.datetime_to_gregorian_seconds(date_time)
  end

  def start_link do 
    fresh_state = %{:last_interrupt => get_timestamp}
    start_link(@slack_token, fresh_state)
  end

  def handle_connect(slack, state) do
   IO.puts "Connected as #{slack.me.name}"
   {:ok, state}
  end

  # regular message
  def handle_message(message=%{type: "message"}, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  # user typing notification
  def handle_message(message=%{type: "user_typing"}, slack, state=%{:last_interrupt => last_interrupt}) do
    Logger.debug inspect message
    if get_timestamp - last_interrupt > 4 do
      message_text = KanyeSay.interrupt("<@#{message.user}>:")
      send_message(message_text, message.channel, slack)
      state = %{state | :last_interrupt => get_timestamp()}
    end

    {:ok, state}
  end

  # dnd status of team mate changed
  def handle_message(message=%{type: "dnd_updated_user"}, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  # direct message channel open
  def handle_message(message=%{type: "im_open"}, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  # file shared with other users
  def handle_message(message=%{type: "file_shared"}, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  # pin added to channel
  def handle_message(message=%{type: "pin_added"}, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  # star added to some item
  def handle_message(message=%{type: "star_added"}, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  # star removed from some item
  def handle_message(message=%{type: "star_removed"}, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  # reaction added to message
  def handle_message(message=%{type: "reaction_added"}, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  def handle_message(message, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end

  def handle_info(message, _slack, state) do
    Logger.debug inspect message
    {:ok, state}
  end
end
