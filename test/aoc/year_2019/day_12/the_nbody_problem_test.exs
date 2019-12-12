defmodule Aoc.Year2019.Day12.TheNBodyProblemTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day12.TheNBodyProblem, import: true

  alias Aoc.Year2019.Day12.TheNBodyProblem

  describe "part_1/1" do
    test "examples" do
      input = "<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>\n<x=4, y=-8, z=8>\n<x=3, y=5, z=-1>"
      assert input |> TheNBodyProblem.part_1(10) == 179
    end

    @tag day: 12, year: 2019
    test "input", %{input: input} do
      assert input |> TheNBodyProblem.part_1() == 6849
    end
  end

  describe "part_2/1" do
    test "examples" do
      input = "<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>\n<x=4, y=-8, z=8>\n<x=3, y=5, z=-1>"
      assert input |> TheNBodyProblem.part_2() == 2772
    end

    @tag day: 12, year: 2019, timeout: :infinity
    test "input", %{input: input} do
      assert input |> TheNBodyProblem.part_2() == 356_658_899_375_688
    end
  end
end
