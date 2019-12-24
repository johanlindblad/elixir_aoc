defmodule Aoc.Year2019.Day24.PlanetofDiscordTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day24.PlanetofDiscord, import: true

  alias Aoc.Year2019.Day24.PlanetofDiscord

  describe "part_1/1" do
    test "examples" do
      input = "....#\n#..#.\n#..##\n..#..\n#...." |> PlanetofDiscord.parse()

      stepped = input |> PlanetofDiscord.step() |> PlanetofDiscord.print()

      assert stepped == "#..#.\n####.\n###.#\n##.##\n.##.."

      input = ".....\n.....\n.....\n#....\n.#..." |> PlanetofDiscord.parse()

      assert PlanetofDiscord.biodiversity(input) == 2_129_920

      input = "....#\n#..#.\n#..##\n..#..\n#...."
      assert PlanetofDiscord.part_1(input) == 2_129_920
    end

    @tag day: 24, year: 2019
    test "input", %{input: input} do
      assert input |> PlanetofDiscord.part_1() == 18_370_591
    end
  end

  describe "part_2/1" do
    test "examples" do
      input = "....#\n#..#.\n#.?##\n..#..\n#...."

      assert PlanetofDiscord.part_2(input, 10) == 99
    end

    @tag day: 24, year: 2019
    test "input", %{input: input} do
      assert input |> PlanetofDiscord.part_2() == 2040
    end
  end
end
