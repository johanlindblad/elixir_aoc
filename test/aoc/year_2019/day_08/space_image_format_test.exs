defmodule Aoc.Year2019.Day08.SpaceImageFormatTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day08.SpaceImageFormat, import: true

  alias Aoc.Year2019.Day08.SpaceImageFormat

  describe "part_1/1" do
    test "examples" do
    end

    @tag day: 08, year: 2019
    test "input", %{input: input} do
      assert input |> SpaceImageFormat.part_1() == 2684
    end
  end

  describe "part_2/1" do
    test "examples" do
      assert "0222112222120000" |> SpaceImageFormat.part_2(2, 2) == " #\n# "
    end

    @tag day: 08, year: 2019
    test "input", %{input: input} do
      assert input |> SpaceImageFormat.part_2() ==
               "#   # ##  ###  #   ##### \n#   ##  # #  # #   #   # \n # # #    #  #  # #   #  \n  #  # ## ###    #   #   \n  #  #  # # #    #  #    \n  #   ### #  #   #  #### "
    end
  end
end
