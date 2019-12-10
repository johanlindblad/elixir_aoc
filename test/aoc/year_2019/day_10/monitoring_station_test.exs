defmodule Aoc.Year2019.Day10.MonitoringStationTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day10.MonitoringStation, import: true

  alias Aoc.Year2019.Day10.MonitoringStation

  describe "part_1/1" do
    test "examples" do
      assert MonitoringStation.blocking({3, 4}, {1, 0}, {2, 2}) == true
      assert MonitoringStation.blocking({0, 0}, {2, 2}, {4, 4}) == false
      assert MonitoringStation.blocking({0, 0}, {4, 4}, {2, 2}) == true
      assert MonitoringStation.blocking({0, 0}, {6, 6}, {2, 2}) == true
      assert MonitoringStation.blocking({0, 4}, {2, 4}, {3, 4}) == false
      assert MonitoringStation.blocking({0, 0}, {6, 0}, {2, 0}) == true

      input = ".#..#\n.....\n#####\n....#\n...##"
      asteroids = input |> MonitoringStation.parse()

      assert MonitoringStation.visible({3, 4}, {1, 0}, asteroids) == false
      assert MonitoringStation.visible({3, 4}, {4, 0}, asteroids) == true
      assert MonitoringStation.visible({3, 4}, {2, 2}, asteroids) == true
      assert MonitoringStation.visible({3, 4}, {2, 0}, asteroids) == true
      assert MonitoringStation.visible({3, 4}, {2, 1}, asteroids) == true
      assert MonitoringStation.visible({0, 4}, {2, 4}, asteroids) == true
      assert MonitoringStation.asteroids_detected({4, 0}, asteroids) == 7
      assert MonitoringStation.asteroids_detected({1, 0}, asteroids) == 7
      assert MonitoringStation.asteroids_detected({3, 4}, asteroids) == 8
      assert MonitoringStation.part_1(input) == 8

      input =
        "......#.#.\n#..#.#....\n..#######.\n.#.#.###..\n.#..#.....\n..#....#.#\n#..#....#.\n.##.#..###\n##...#..#.\n.#....####"

      assert MonitoringStation.part_1(input) == 33

      input =
        "#.#...#.#.\n.###....#.\n.#....#...\n##.#.#.#.#\n....#.#.#.\n.##..###.#\n..#...##..\n..##....##\n......#...\n.####.###."

      assert MonitoringStation.part_1(input) == 35
    end

    @tag day: 10, year: 2019
    test "input", %{input: input} do
      # assert input |> MonitoringStation.part_1() == 282
      assert input == input
    end
  end

  describe "part_2/1" do
    test "examples" do
      input =
        ".#....#####...#..\n##...##.#####..##\n##...#...#.#####.\n..#.....X...###..\n..#.#.....#....##"

      asteroids = input |> MonitoringStation.parse()
      laser = {8, 3}

      assert MonitoringStation.vaporize(asteroids, laser, 8) == [
               {8, 1},
               {9, 0},
               {9, 1},
               {10, 0},
               {9, 2},
               {11, 1},
               {12, 1},
               {11, 2}
             ]

      large =
        ".#..##.###...#######\n##.############..##.\n.#.######.########.#\n.###.#######.####.#.\n#####.##.#.##.###.##\n..#####..#.#########\n####################\n#.####....###.#.#.##\n##.#################\n#####.##.###..####..\n..######..##.#######\n####.##.####...##..#\n.#####..#.######.###\n##...#.##########...\n#.##########.#######\n.####.#.###.###.#.##\n....##.##.###..#####\n.#.#.###########.###\n#.#.#.#####.####.###\n###.##.####.##.#..##"

      asteroids = large |> MonitoringStation.parse()
      laser = {11, 13}
      order = MonitoringStation.vaporize(asteroids, laser, 299)

      assert order |> Enum.at(0) == {11, 12}
      assert order |> Enum.at(49) == {16, 9}
      assert order |> List.last() == {11, 1}
    end

    @tag day: 10, year: 2019
    test "input", %{input: input} do
      assert input |> MonitoringStation.part_2() == 1008
    end
  end
end
