defmodule Aoc.Year2019.Day17.SetandForgetTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day17.SetandForget, import: true

  alias Aoc.Year2019.Day17.SetandForget

  describe "part_1/1" do
    test "examples" do
      input = [
        "..#..........",
        "..#..........",
        "#######...###",
        "#.#...#...#.#",
        "#############",
        "..#...#...#..",
        "..#####...^.."
      ]

      {map, robot, robot_direction} = SetandForget.parse(input)

      {intersections, moves} = SetandForget.step(map, robot, robot_direction)

      result =
        intersections
        |> Enum.map(fn {x, y} -> x * y end)
        |> Enum.sum()

      assert result == 76
    end

    @tag day: 17, year: 2019
    test "input", %{input: input} do
      assert input |> SetandForget.part_1() == 6448
    end
  end

  describe "part_2/1" do
    test "compression" do
      moves =
        "L,4,L,6,L,8,L,12,L,8,R,12,L,12,L,8,R,12,L,12,L,4,L,6,L,8,L,12,L,8,R,12,L,12,R,12,L,6,L,6,L,8,L,4,L,6,L,8,L,12,R,12,L,6,L,6,L,8,L,8,R,12,L,12,R,12,L,6,L,6,L,8"

      # assert SetandForget.compress(moves) == {"A,B,B,A,B,C,A,C,B,C", "L,4,L,6,L,8,L,12", "L,8,R,12,L,12", "R,12,L,6,L,6,L,8"}
    end

    @tag day: 17, year: 2019
    test "input", %{input: input} do
      assert input |> SetandForget.part_2() == 914_900
    end
  end
end
