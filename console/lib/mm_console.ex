defmodule MmConsole do

  @width  4
  @colors 6

  @red   "\e[41m \e[0m "
  @white "\e[47m \e[0m "

  def play do
    game = Mastermind.new_game(width: @width, colors: @colors)
    clear_screen()
    display_help()
    show_game_and_get_move(game)
  end


  defp show_game_and_get_move(game) do
    clear_screen()
    show_my_pick(game)
    game_status = Mastermind.status(game)
    show_your_moves(game_status)
    guess = get_your_move(game_status)
    Mastermind.make_guess(game, guess)
    |> show_game_and_get_move()
  end

  defp show_my_pick(game) do
    show_row(List.duplicate("?", game.width))
  end


  defp show_row(entries, score \\ nil) do
    IO.write("|")
    for entry <- entries do
      IO.write(" #{entry} |")
    end
    show_score(score)
    IO.puts ""
    IO.write("|")
    for _ <- entries do
      IO.write("___|")
    end
    IO.puts ""
  end

  defp show_score(nil) do
  end

  defp show_score(score) do
    IO.write [ String.duplicate(@red, score.reds), String.duplicate(@white, score.whites) ]
  end


  defp show_your_moves(%{ moves: moves }) do
    for %{ guess: guess, score: score } <- moves do
      show_row(guess, score)
    end
  end

  defp get_your_move(game_status) do
    IO.gets("Your move: ")
    |> String.replace(~r/\s/, "")
    |> validate_move(game_status)
  end


  defp validate_move(move, state = %{ width: width, colors: colors }) do
    if move =~ ~r/^[1-#{colors}]{#{width}}/ do
      String.codepoints(move) |> Enum.map(&String.to_integer/1)
    else
      error(width, colors)
      get_your_move(state)
    end
  end

  defp error(width, colors) do
    IO.puts "Your move should be #{width} digits between 1 and #{colors}"
  end

  defp clear_screen() do
    IO.write("\e[H\e[2J")
  end

  defp display_help() do
    IO.gets """
    Welcome to MasterMind.

    I have a bag full of the numbers 1 through #{@colors}. There are
    lots of copies of each.

    I've picked #{@width} numbers. You have to guess them. For example,
    if you think my numbers are (in order) 4235, then you'd enter "4325" and hit return.

    I'll then display your guess, along with a series of blobs. A
    green blob means you guessed a digit in the right position. A
    blue blob means you guessed a digit that's in the number, but
    not in the position you entered it.

    Hit «return» to continue
    """
  end

end
