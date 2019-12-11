defmodule Aoc.Year2019.Day11.SpacePoliceTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day11.SpacePolice, import: true

  alias Aoc.Year2019.Day11.SpacePolice

  describe "part_1/1" do
    test "turn" do
      assert SpacePolice.turn({1, 0}, 0) == {0, -1}
      assert SpacePolice.turn({0, -1}, 0) == {-1, 0}
      assert SpacePolice.turn({0, 1}, 0) == {1, 0}
      assert SpacePolice.turn({0, -1}, 1) == {1, 0}
    end

    test "examples" do
    end

    @tag day: 11, year: 2019
    test "input", %{input: input} do
      assert input |> SpacePolice.part_1() == 2093
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    @tag day: 11, year: 2019
    test "input", %{input: input} do
      assert input |> SpacePolice.part_2() ==
               "\n ███    ██ ███  █  █ █      ██ █  █ ███    \n █  █    █ █  █ █ █  █       █ █  █ █  █   \n ███     █ █  █ ██   █       █ █  █ █  █   \n █  █    █ ███  █ █  █       █ █  █ ███    \n █  █ █  █ █ █  █ █  █    █  █ █  █ █      \n ███   ██  █  █ █  █ ████  ██   ██  █      "
    end
  end
end
