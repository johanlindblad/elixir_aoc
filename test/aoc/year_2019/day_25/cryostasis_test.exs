defmodule Aoc.Year2019.Day25.CryostasisTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day25.Cryostasis, import: true

  alias Aoc.Year2019.Day25.Cryostasis

  describe "part_1/1" do
    test "examples" do
    end

    @tag day: 25, year: 2019, timeout: :infinity
    test "input", %{input: input} do
      assert input |> Cryostasis.part_1() == 319_815_680
    end
  end
end
