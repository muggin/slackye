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

  def search_punchlines(query_word) when is_binary(query_word) do
    Agent.get(__MODULE__, fn lyrics ->
      Enum.filter(lyrics, fn [_ | keywords] ->
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

  def search_punchlines(query_words) when is_list(query_words) do
    query_set = MapSet.new(query_words)
    Agent.get(__MODULE__, fn lyrics ->
      Enum.reduce(lyrics, {[], 0}, fn (e, acc) ->
        [punchline | keywords] = e
        {best_punchlines, best_intersection_count} = acc

        current_set = MapSet.new(keywords)
        intersection = MapSet.intersection(current_set, query_set)
        current_intersection_count = MapSet.size(intersection)

        cond do
          current_intersection_count < best_intersection_count -> acc

          current_intersection_count == best_intersection_count ->
            new_list = best_punchlines ++ [punchline]
            {new_list, current_intersection_count}

          current_intersection_count > best_intersection_count ->
            new_list = [punchline]
            {new_list, current_intersection_count}

        end

        # if current_intersection_count < best_intersection_count do
        #   acc
        # else
        #   if current_intersection_count == best_intersection_count do
        #     new_list = best_punchlines ++ [punchline]
        #     {new_list, current_intersection_count}
        #   else # current_intersection_count > best_intersection_count
        #     new_list = [punchline]
        #     {new_list, current_intersection_count}
        #   end
        # end
      end)
    end)
  end

  def find_punchline(query_word) do
    punchlines = search_punchlines(query_word)
    if Enum.empty?(punchlines), do: nil, else: Enum.random(punchlines)
  end

  # private
  defp load_lyrics do
    stream = LyricsLoader.stream_file("data/lyrics.csv")
    LyricsLoader.listify_first_csv_col(stream)
  end

  defp load_stops do
    stream = LyricsLoader.stream_file("data/stop_words.csv")
    LyricsLoader.listify_first_csv_col(stream)
  end
end
