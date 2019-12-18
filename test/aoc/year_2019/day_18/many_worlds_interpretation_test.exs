defmodule Aoc.Year2019.Day18.ManyWorldsInterpretationTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day18.ManyWorldsInterpretation, import: true

  alias Aoc.Year2019.Day18.ManyWorldsInterpretation

  describe "part_1/1" do
    test "examples" do
      input = "#########\n#b.A.@.a#\n#########"
      assert input |> ManyWorldsInterpretation.part_1() == 8

      input =
        "########################\n#f.D.E.e.C.b.A.@.a.B.c.#\n######################.#\n#d.....................#\n########################"

      assert input |> ManyWorldsInterpretation.part_1() == 86

      input =
        "########################\n#@..............ac.GI.b#\n###d#e#f################\n###A#B#C################
###g#h#i################\n########################"

      assert input |> ManyWorldsInterpretation.part_1() == 81

      input =
        "#################\n#i.G..c...e..H.p#\n########.########\n#j.A..b...f..D.o#\n########@########\n#k.E..a...g..B.n#\n########.########\n#l.F..d...h..C.m#\n#################"

      assert input |> ManyWorldsInterpretation.part_1() == 136
    end

    @tag day: 18, year: 2019, timeout: :infinity
    test "input", %{input: input} do
      assert input |> ManyWorldsInterpretation.part_1() == 0
    end
  end

  describe "part_2/1" do
    test "examples" do
      input = "#######
#a.#Cd#
##...##
##.@.##
##...##
#cB#Ab#
#######"
      assert input |> ManyWorldsInterpretation.part_2() == 8

      input = "###############
#d.ABC.#.....a#
###############
#######@#######
###############
#b.....#.....c#
###############"
      assert input |> ManyWorldsInterpretation.part_2() == 24
    end

    @tag day: 18, year: 2019, timeout: :infinity
    test "input", %{input: input} do
      assert input |> ManyWorldsInterpretation.part_2() == input
    end
  end
end
