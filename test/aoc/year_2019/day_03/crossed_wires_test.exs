defmodule Aoc.Year2019.Day03.CrossedWiresTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day03.CrossedWires, import: true

  alias Aoc.Year2019.Day03.CrossedWires

  describe "part_1/1" do
    test "examples" do
    end

    test "parsing" do
      assert CrossedWires.parse_delta("R78") == {78, 0}
      assert CrossedWires.parse_delta("L30") == {-30, 0}
      assert CrossedWires.parse_delta("U10") == {0, -10}
      assert CrossedWires.parse_delta("D14") == {0, 14}

      assert CrossedWires.to_coordinates([{0, 5}, {-10, 0}, {0, 5}]) == [
               {0, 0},
               {0, 5},
               {-10, 5},
               {-10, 10}
             ]
    end

    @tag day: 03, year: 2019
    test "input", %{input: input} do
      assert input |> CrossedWires.part_1() == 768
    end
  end

  describe "part_2/1" do
    test "examples" do
      input = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
      assert input |> CrossedWires.part_2() == 410
      input = "R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83"
      assert input |> CrossedWires.part_2() == 610
    end

    @tag day: 03, year: 2019
    test "input", %{input: input} do
      assert input |> CrossedWires.part_2() == 8684
    end
  end
end
