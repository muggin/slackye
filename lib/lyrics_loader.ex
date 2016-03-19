defmodule LyricsLoader do
  def stream_file(filename) do
    File.stream!(filename) |>
    CSV.decode
  end
end
