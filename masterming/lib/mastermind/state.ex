defmodule Mastermind.State do
  defstruct(
    width: 4,
    colors: 6,
    target: [],
    turns_left: 9,
    moves:  []
  )

  defmodule Move do
    defstruct(
      guess: [],
      score: {}
    )

    def to_map(move) do
      %{
        guess: move.guess,
        score: move.score,
      }
    end
  end
end
