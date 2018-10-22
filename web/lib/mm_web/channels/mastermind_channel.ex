defmodule MmWeb.MastermindChannel do
  use Phoenix.Channel

  def join("mm:game", _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_game", %{}, socket) do
    game = Mastermind.new_game()
    IO.inspect game
    socket = assign(socket, "game", game)
    push(socket, "new_game_setup", %{ game: Mastermind.status(game)})
    {:noreply, socket}
  end

  def handle_in("make_move", guess, socket) do
    game = socket.assigns["game"]
    IO.inspect game
    IO.inspect %{ guess: guess }
    game = Mastermind.make_guess(game, guess)
    socket = assign(socket, "game", game)
    push(socket, "update_board", %{ game: Mastermind.status(game)})
    {:noreply, socket}
  end
end
