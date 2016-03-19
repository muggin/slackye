defmodule LyricsLoader do

  def stream_file(filename) do
    File.stream!(filename) |>
    CSV.decode
  end

  def tokenise_and_exclude(text, stop_words) do
    Gibran.Tokeniser.tokenise(text, exclude: stop_words)
  end

  def listify_first_csv_col(stream) do
    list = stream |>
    Enum.flat_map(&(Enum.take(&1, 1)))
    list
  end

  def process_lyrics_with_stop_words(lyrics, stop_words) do
    Enum.map(lyrics, fn lyric ->
      tokenised_list = tokenise_and_exclude(lyric, stop_words)
      [lyric | tokenised_list]
    end)
  end
  
end
