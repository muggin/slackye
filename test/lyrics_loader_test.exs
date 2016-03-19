defmodule LyricsLoaderTest do
  use ExUnit.Case

  test "loading csv" do
    stream = LyricsLoader.stream_file("data/lyrics.csv")
    line = stream |> Enum.take(1)
    assert(line != nil, "Should load CSV stream")
  end

  test "tokenising" do
    lyric = "Took nothing from no man; man i'm my own man"
    stop_words = ["no", "my"]
    tokenised = LyricsLoader.tokenise_and_exclude(lyric, stop_words)
    expected = ["took", "nothing", "from", "man", "man", "i'm", "own", "man"]
    assert(tokenised == expected, "#{tokenised} != #{expected}")
  end

  test "process_lyrics_with_stop_words" do
    lyrics = [
      "Kanye; can I talk to you for a minute?",
      "Somethin beautiful"
    ]

    stop_words = ["i", "you"]

    result = LyricsLoader.process_lyrics_with_stop_words(lyrics, stop_words)
    expected = [
                ["Kanye; can I talk to you for a minute?","kanye","can","talk","to","for","a","minute"],
                ["Somethin beautiful", "somethin", "beautiful"]
              ]
    assert(result == expected, "Processing failed")
  end
end
