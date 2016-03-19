defmodule LyricsLoader do

  def stream_file(filename) do
    File.stream!(filename) |>
    CSV.decode
  end

  def tokenise_and_exclude(text, stop_words) do
    Gibran.Tokeniser.tokenise(text, exclude: stop_words)
  end

end
