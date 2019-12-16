defmodule Aoc.Year2019.Day16.FlawedFrequencyTransmissionTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day16.FlawedFrequencyTransmission, import: true

  alias Aoc.Year2019.Day16.FlawedFrequencyTransmission

  describe "part_1/1" do
    test "examples" do
      list = FlawedFrequencyTransmission.parse("2345678")
      assert FlawedFrequencyTransmission.fft(list, 4, 1) == [1, 0, 2, 9, 4, 9, 8]
      assert FlawedFrequencyTransmission.part_1("12345678", 2) == "34040438"
      assert FlawedFrequencyTransmission.part_1("12345678", 4) == "01029498"

      assert FlawedFrequencyTransmission.part_1("69317163492948606335995924319873") == "52432133"

      # assert FlawedFrequencyTransmission.part_1("69317163492948606335995924319873", 10_000) == "22079486"

      # assert FlawedFrequencyTransmission.part_1("19617804207202209144916044189917") == "73745418"
      # assert FlawedFrequencyTransmission.part_1("80871224585914546619083218645595") == "24176176"
    end

    @tag day: 16, year: 2019
    test "input", %{input: input} do
      assert input |> FlawedFrequencyTransmission.part_1() == "73127523"
    end
  end

  describe "part_2/1" do
    @tag timeout: :infinity
    test "examples" do
      assert FlawedFrequencyTransmission.latter_half_fft([4, 5, 6, 7, 8], 3, 1) == [2, 6, 1, 5, 8]
      assert FlawedFrequencyTransmission.latter_half_fft([4, 5, 6, 7, 8], 3, 2) == [4, 0, 4, 3, 8]
      assert FlawedFrequencyTransmission.part_2("03036732577212944063491565474664") == "84462026"
    end

    @tag day: 16, year: 2019
    test "input", %{input: input} do
      assert input |> FlawedFrequencyTransmission.part_2() == "80284420"
    end
  end
end
