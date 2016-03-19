# require IEx

defmodule KanyeWisdom do
  def start_link do
    IO.puts "Loading bare lyrics..."
    lyrics = load_lyrics

    IO.puts "Loading stop words..."
    stops = load_stops
# IEx.pry
    IO.puts "Processing lyrics base..."
    processed = LyricsLoader.process_lyrics_with_stop_words(lyrics, stops)

    Agent.start_link(fn -> processed end, [name: :lyrics])
  end

  defp load_lyrics do
    stream = LyricsLoader.stream_file("data/lyrics.csv")
    LyricsLoader.listify_first_csv_col(stream)
  end

  defp load_stops do
    stream = LyricsLoader.stream_file("data/stop_words.csv")
    LyricsLoader.listify_first_csv_col(stream)
  end
end
