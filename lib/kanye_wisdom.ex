defmodule KanyeWisdom do
  def start_link do
    IO.puts "Loading bare lyrics..."
    lyrics = load_lyrics

    IO.puts "Loading stop words..."
    stops = load_stops

    IO.puts "Processing lyrics base..."
    processed = LyricsLoader.process_lyrics_with_stop_words(lyrics, stops)

    Agent.start_link(fn -> processed end, [name: __MODULE__])
  end

  def search_punchlines(query_word) do
    Agent.get(__MODULE__, fn lyrics ->
      Enum.filter(lyrics, fn [punchline | keywords] ->
        Enum.any?(keywords, fn keyword ->
          keyword == query_word
        end)
      end)
      |>
      Enum.map(fn [punchline | _] ->
        punchline
      end)
    end)
  end

  def find_punchline(query_word) do
    punchlines = search_punchlines(query_word)
    if Enum.empty?(punchlines), do: nil, else: Enum.random(punchlines)
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
