defmodule Aoc.Year2019.Day06.UniversalOrbitMapTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day06.UniversalOrbitMap, import: true

  alias Aoc.Year2019.Day06.UniversalOrbitMap

  describe "part_1/1" do
    test "examples" do
      example = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L"
      assert example |> UniversalOrbitMap.part_1() == 42
    end

    @tag day: 06, year: 2019
    test "input", %{input: input} do
      assert input |> UniversalOrbitMap.part_1() == 106_065
    end
  end

  describe "part_2/1" do
    test "examples" do
      example = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN"
      graph = example |> UniversalOrbitMap.parse_input() |> UniversalOrbitMap.build_graph()

      assert UniversalOrbitMap.steps_to(graph, "C") == %{"B" => 1, "COM" => 2}
      assert UniversalOrbitMap.part_2(example) == 4
    end

    @tag day: 06, year: 2019
    test "input", %{input: input} do
      assert input |> UniversalOrbitMap.part_2() == 253
    end
  end
end
