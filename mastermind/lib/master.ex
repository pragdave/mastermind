defmodule Mastermind do
  defdelegate new_game(options \\ []), to: Mastermind.Game
  defdelegate make_guess(game, guess), to: Mastermind.Game
  defdelegate status(game),            to: Mastermind.Game
end
