defmodule LyricsLoaderTest do
  use ExUnit.Case

  test "loading csv" do
    stream = LyricsLoader.stream_file("data/lyrics.csv")
    line = stream |> Enum.take(1)
    assert(line != nil, "Should load CSV stream")
  end
end
