defmodule Aoc.Year2019.Day22.SlamShuffleTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day22.SlamShuffle, import: true

  alias Aoc.Year2019.Day22.SlamShuffle

  describe "part_1/1" do
    test "operations" do
      deck = SlamShuffle.deck(10)

      assert SlamShuffle.deal(deck) == [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
      assert SlamShuffle.cut(deck, 3) == [3, 4, 5, 6, 7, 8, 9, 0, 1, 2]
      assert SlamShuffle.cut(deck, -4) == [6, 7, 8, 9, 0, 1, 2, 3, 4, 5]

      assert SlamShuffle.deal_inc(deck, 3) == [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]
    end

    test "examples" do
      input = "deal with increment 7\ndeal into new stack\ndeal into new stack"
      assert SlamShuffle.run(input, 10) == [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]
      assert SlamShuffle.part_1(input, 10, 9) == 3

      input = "cut 6\ndeal with increment 7\ndeal into new stack"
      assert SlamShuffle.run(input, 10) == [3, 0, 7, 4, 1, 8, 5, 2, 9, 6]
      input = "cut 6\ndeal with increment 7\ndeal into new stack"
      assert SlamShuffle.part_1(input, 10, 7) == 2
      assert SlamShuffle.part_1(input, 10, 9) == 8

      input = "deal with increment 7\ndeal with increment 9\ncut -2"
      assert SlamShuffle.run(input, 10) == [6, 3, 0, 7, 4, 1, 8, 5, 2, 9]

      input =
        "deal into new stack\ncut -2\ndeal with increment 7\ncut 8\ncut -4\ndeal with increment 7\ncut 3\ndeal with increment 9\ndeal with increment 3\ncut -1"

      assert SlamShuffle.run(input, 10) == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
      assert SlamShuffle.part_1(input, 10, 9) == 0
      assert SlamShuffle.part_1(input, 10, 7) == 6
    end

    @tag day: 22, year: 2019
    test "input", %{input: input} do
      assert input |> SlamShuffle.part_1() == 4775
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    test "math" do
      assert SlamShuffle.technique_math("cut 3", {0, 1, 10}) == {3, 1, 10}

      assert SlamShuffle.technique_math("cut -4", {0, 1, 10}) == {6, 1, 10}

      assert SlamShuffle.technique_math("deal into new stack", {0, 1, 10}) == {9, -1, 10}

      assert SlamShuffle.technique_math("deal with increment 3", {0, 1, 10}) == {0, 7, 10}
    end

    @tag day: 22, year: 2019
    test "input", %{input: input} do
      assert input |> SlamShuffle.part_2() == 37_889_219_674_304
    end
  end
end
