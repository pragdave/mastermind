defmodule Mastermind.Game do

  @moduledoc """
  We represent a game of Mastermind as it is played by our client.

  The client first calls `new_game`, which returns an opaque identifier for the
  game in play.

  The client then calls `make_guess` to submit a guess and have it scored, and
  `status` to return an external view of the game status. This status contains
  the board geometry along with a full history of guesses and their scores.

  ### Internal Representation

  Colors are represented as positive integers, 1..«colors», where the maximum
  color number can be set as an option to `new_game` (it defaults to 6).

  A guess is a list of color numbers. The length of this list must be the same
  as the width of the board (which can be set when calling `new_game` and which
  defaults to 4).

  The target pattern, like each guess, is simply a list of colors. It is
  normally generated randomly by `new_game`, but can be passed in as an option.
  This feature is used by the tests.

  ### External Representation

  See type `external_state`
  """

  alias Mastermind.State

  @doc """
  `Mastermind.state/1` returns the following map

   * `colors:` _n_

     The number of colors available in this game

   * `width:` _n_

     The width of the board (that is, the number of values to guess)

   * `turns_left:` _n_

     The number of turns remaining.

   * `moves:` _[ move, move, ... ]_

     A list of moves, where each move is a map containing two items, `guess:`
     and `score:`. The guess field is the guess made for that more, and the
     score is a map with two keys, `reds:` and `whites:`, which give the counts
     of red and white pegs for that guess.

  """

  @type external_state :: %{
    colors: non_neg_integer,
    moves: [ State.Move.t ],
    turns_left: non_neg_integer,
    width: non_neg_integer,
  }


  @default_options [
    width:  4,
    colors: 6,
    turns:  10,
    target: nil
  ]

  @spec new_game(keyword()) :: State.t()
  def new_game(options \\ []) do
    options = @default_options |> Keyword.merge(options)

    %State{
      width:  options[:width],
      colors: options[:colors],
      target: options[:target] || generate_target(options)
    }
  end

  @spec make_guess(State.t, [ integer ]) :: State.t
  def make_guess(game, guess) when is_list(guess) do
    with score = score_guess(game.target, guess),
         move = %State.Move{ guess: guess, score: score },
    do:
        %{game | turns_left: game.turns_left - 1, moves: [ move | game.moves ]}
  end

  @spec status(Mastermind.State.t) :: external_state
  def status(game) do
    %{
      colors:     game.colors,
      width:      game.width,
      turns_left: game.turns_left,
      moves:      game.moves |> Enum.map(&State.Move.to_map/1) |> Enum.reverse
    }
  end




  defp score_guess(target, guess) do
    { reds, whites } =
      Enum.zip(target, guess)
      |> split_exact_matches()

    whites = Enum.unzip(whites) |> count_whites()
    %{ reds: length(reds), whites: whites }
  end

  defp split_exact_matches(target_and_guess) do
    target_and_guess
    |> Enum.split_with(fn {t, g} -> t == g end)
  end

  defp count_whites(targets_and_guesses), do: count_whites(targets_and_guesses, 0)
  defp count_whites({_target, []}, count), do: count
  defp count_whites({target, [guess | rest]}, count) do
    if guess in target do
      target = target |> List.delete(guess)
      count_whites({target, rest}, count + 1)
    else
      count_whites({target, rest}, count)
    end
  end

  defp generate_target(options) do
    possibles = 1..options[:colors]

    1..options[:width]
    |> Enum.map(fn _ -> Enum.random(possibles) end)
  end
end
