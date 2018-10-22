defmodule MasterTest do
  use ExUnit.Case
  alias Mastermind, as: M

  test "a new game has no score" do
    game = M.new_game()
    assert game.moves == []
  end

  describe "with basic target" do

    setup do
      [ game: M.new_game(target: [1, 2, 3, 4]) ]
    end

    test "a bad guess returns no red and white pegs", given do
      given.game
      |> M.make_guess([6, 6, 6, 6])
      |> assert_score(0, 0)
    end

    test "correct guess wrong position returns one white", given do
      given.game
      |> M.make_guess([6, 6, 6, 1])
      |> assert_score(0, 1)
    end

    test "correct guess right position returns one red", given do
      given.game
      |> M.make_guess([6, 6, 6, 4])
      |> assert_score(1, 0)
    end

    test "correct guess right position and correct wrong position returns one of each", given do
      given.game
      |> M.make_guess([6, 1, 6, 4])
      |> assert_score(1, 1)
    end

    test "all wrong position returns 4 whites" do
      M.new_game(target: [1, 2, 3, 4])
      |> M.make_guess([4, 3, 2, 1])
      |> assert_score(0, 4)
    end

    test "all correct position returns 4 reds", given do
      given.game
      |> M.make_guess([1, 2, 3, 4])
      |> assert_score(4, 0)
    end
  end

  describe "target containing duplicates," do
    setup do
      [ game:  M.new_game(target: [1, 2, 1, 4]) ]
    end

    test "with  all correct position returns 4 reds", given do
      given.game
      |> M.make_guess([1, 2, 1, 4])
      |> assert_score(4, 0)
    end

    test "with target containing duplicates, one correct position returns 1 red", given do
      given.game
      |> M.make_guess([1, 6, 6, 6])
      |> assert_score(1, 0)
    end

    def assert_score(status, expected_reds, expected_whites) do
      %{ reds: reds, whites: whites } = hd(status.moves).score
      assert reds == expected_reds
      assert whites == expected_whites
    end
  end
end
