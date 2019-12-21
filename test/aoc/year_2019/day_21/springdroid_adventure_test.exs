defmodule Aoc.Year2019.Day21.SpringdroidAdventureTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day21.SpringdroidAdventure, import: true

  alias Aoc.Year2019.Day21.SpringdroidAdventure

  describe "part_1/1" do
    test "examples" do
    end

    @tag day: 21, year: 2019
    test "input", %{input: input} do
      assert input |> SpringdroidAdventure.part_1() == 19_357_534
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    @tag day: 21, year: 2019
    test "input", %{input: input} do
      assert input |> SpringdroidAdventure.part_2() == 1_142_814_363
    end
  end
end
