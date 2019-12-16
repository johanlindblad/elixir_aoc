defmodule Aoc.Year2019.Day16.FlawedFrequencyTransmission do
  @moduledoc """
  ## --- Day 16: Flawed Frequency Transmission ---

  You're 3/4ths of the way through the gas giants. Not only do roundtrip signals
  to Earth take five hours, but the signal quality is quite bad as well. You can
  clean up the signal with the Flawed Frequency Transmission algorithm, or *FFT*.

  As input, FFT takes a list of numbers. In the signal you received (your puzzle
  input), each number is a single digit: data like `15243` represents the sequence
  `1`, `5`, `2`, `4`, `3`.

  FFT operates in repeated *phases*. In each phase, a new list is constructed with
  the same length as the input list. This new list is also used as the input for
  the next phase.

  Each element in the new list is built by multiplying every value in the input
  list by a value in a repeating *pattern* and then adding up the results. So, if
  the input list were `9, 8, 7, 6, 5` and the pattern for a given element were `1,
  2, 3`, the result would be `9*1 + 8*2 + 7*3 + 6*1 + 5*2` (with each input
  element on the left and each value in the repeating pattern on the right of each
  multiplication). Then, only the ones digit is kept: `38` becomes `8`, `-17`
  becomes `7`, and so on.

  While each element in the output array uses all of the same input array
  elements, the actual repeating pattern to use depends on *which output element*
  is being calculated. The base pattern is `0, 1, 0, -1`. Then, repeat each value
  in the pattern a number of times equal to the *position in the output list*
  being considered. Repeat once for the first element, twice for the second
  element, three times for the third element, and so on. So, if the third element
  of the output list is being calculated, repeating the values would produce: `0,
  0, 0, 1, 1, 1, 0, 0, 0, -1, -1, -1`.

  When applying the pattern, skip the very first value exactly once. (In other
  words, offset the whole pattern left by one.) So, for the second element of the
  output list, the actual pattern used would be: `0, 1, 1, 0, 0, -1, -1, 0, 0, 1,
  1, 0, 0, -1, -1, ...`.

  After using this process to calculate each element of the output list, the phase
  is complete, and the output list of this phase is used as the new input list for
  the next phase, if any.

  Given the input signal `12345678`, below are four phases of FFT. Within each
  phase, each output digit is calculated on a single line with the result at the
  far right; each multiplication operation shows the input digit on the left and
  the pattern value on the right:

  `Input signal: 12345678

  1*1  + 2*0  + 3*-1 + 4*0  + 5*1  + 6*0  + 7*-1 + 8*0  = 4
  1*0  + 2*1  + 3*1  + 4*0  + 5*0  + 6*-1 + 7*-1 + 8*0  = 8
  1*0  + 2*0  + 3*1  + 4*1  + 5*1  + 6*0  + 7*0  + 8*0  = 2
  1*0  + 2*0  + 3*0  + 4*1  + 5*1  + 6*1  + 7*1  + 8*0  = 2
  1*0  + 2*0  + 3*0  + 4*0  + 5*1  + 6*1  + 7*1  + 8*1  = 6
  1*0  + 2*0  + 3*0  + 4*0  + 5*0  + 6*1  + 7*1  + 8*1  = 1
  1*0  + 2*0  + 3*0  + 4*0  + 5*0  + 6*0  + 7*1  + 8*1  = 5
  1*0  + 2*0  + 3*0  + 4*0  + 5*0  + 6*0  + 7*0  + 8*1  = 8

  After 1 phase: 48226158

  4*1  + 8*0  + 2*-1 + 2*0  + 6*1  + 1*0  + 5*-1 + 8*0  = 3
  4*0  + 8*1  + 2*1  + 2*0  + 6*0  + 1*-1 + 5*-1 + 8*0  = 4
  4*0  + 8*0  + 2*1  + 2*1  + 6*1  + 1*0  + 5*0  + 8*0  = 0
  4*0  + 8*0  + 2*0  + 2*1  + 6*1  + 1*1  + 5*1  + 8*0  = 4
  4*0  + 8*0  + 2*0  + 2*0  + 6*1  + 1*1  + 5*1  + 8*1  = 0
  4*0  + 8*0  + 2*0  + 2*0  + 6*0  + 1*1  + 5*1  + 8*1  = 4
  4*0  + 8*0  + 2*0  + 2*0  + 6*0  + 1*0  + 5*1  + 8*1  = 3
  4*0  + 8*0  + 2*0  + 2*0  + 6*0  + 1*0  + 5*0  + 8*1  = 8

  After 2 phases: 34040438

  3*1  + 4*0  + 0*-1 + 4*0  + 0*1  + 4*0  + 3*-1 + 8*0  = 0
  3*0  + 4*1  + 0*1  + 4*0  + 0*0  + 4*-1 + 3*-1 + 8*0  = 3
  3*0  + 4*0  + 0*1  + 4*1  + 0*1  + 4*0  + 3*0  + 8*0  = 4
  3*0  + 4*0  + 0*0  + 4*1  + 0*1  + 4*1  + 3*1  + 8*0  = 1
  3*0  + 4*0  + 0*0  + 4*0  + 0*1  + 4*1  + 3*1  + 8*1  = 5
  3*0  + 4*0  + 0*0  + 4*0  + 0*0  + 4*1  + 3*1  + 8*1  = 5
  3*0  + 4*0  + 0*0  + 4*0  + 0*0  + 4*0  + 3*1  + 8*1  = 1
  3*0  + 4*0  + 0*0  + 4*0  + 0*0  + 4*0  + 3*0  + 8*1  = 8

  After 3 phases: 03415518

  0*1  + 3*0  + 4*-1 + 1*0  + 5*1  + 5*0  + 1*-1 + 8*0  = 0
  0*0  + 3*1  + 4*1  + 1*0  + 5*0  + 5*-1 + 1*-1 + 8*0  = 1
  0*0  + 3*0  + 4*1  + 1*1  + 5*1  + 5*0  + 1*0  + 8*0  = 0
  0*0  + 3*0  + 4*0  + 1*1  + 5*1  + 5*1  + 1*1  + 8*0  = 2
  0*0  + 3*0  + 4*0  + 1*0  + 5*1  + 5*1  + 1*1  + 8*1  = 9
  0*0  + 3*0  + 4*0  + 1*0  + 5*0  + 5*1  + 1*1  + 8*1  = 4
  0*0  + 3*0  + 4*0  + 1*0  + 5*0  + 5*0  + 1*1  + 8*1  = 9
  0*0  + 3*0  + 4*0  + 1*0  + 5*0  + 5*0  + 1*0  + 8*1  = 8

  After 4 phases: 01029498
  `Here are the first eight digits of the final output list after 100 phases for
  some larger inputs:

  - `80871224585914546619083218645595` becomes `24176176`.
  - `19617804207202209144916044189917` becomes `73745418`.
  - `69317163492948606335995924319873` becomes `52432133`.
  After *100* phases of FFT, *what are the first eight digits in the final output
  list?*


  """

  @doc """

  """
  def part_1(input, steps \\ 100) do
    list = parse(input)
    fft(list, steps) |> Enum.take(8) |> Enum.join("")
  end

  def fft(list, steps, start_offset \\ 0)
  def fft(list, 0, _start_offset), do: list

  def fft(list, steps, start_offset) do
    wi = Enum.with_index(list, start_offset)

    list =
      wi
      |> Enum.map(fn {_, i} ->
        list
        |> Enum.drop(i - start_offset)
        |> Enum.with_index(i)
        |> Enum.reduce(0, fn {y, j}, sum when y >= 0 ->
          length_of_repeating_pattern = (i + 1) * 4
          position_in_short_pattern = rem(j + 1, length_of_repeating_pattern) |> div(i + 1)
          multiply_by = [0, 1, 0, -1] |> Enum.at(position_in_short_pattern)

          sum + y * multiply_by
        end)
        |> abs
        |> rem(10)
      end)

    fft(list, steps - 1, start_offset)
  end

  @doc """

  """
  def part_2(input) do
    list = parse(input)
    offset = list |> Enum.take(7) |> Enum.join("") |> String.to_integer()
    list = Stream.cycle(list) |> Enum.take(String.length(input) * 10000)
    list = list |> Enum.drop(offset)

    # IO.puts(list |> Enum.join("") |> String.length())

    latter_half_fft(list, offset, 100) |> Enum.take(8) |> Enum.join("")
  end

  def parse(input) do
    input |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  def latter_half_fft(input, _first_index, 0), do: input

  def latter_half_fft(input, first_index, steps) do
    latter_half_fft_step(input, first_index)
    |> latter_half_fft(first_index, steps - 1)
  end

  def latter_half_fft_step(input, first_index, acc \\ [])

  def latter_half_fft_step(input = [number | rest], first_index, acc) do
    sum = Enum.take(input, first_index + 1) |> Enum.sum() |> abs |> rem(10)

    lookahead = rest |> Enum.drop(first_index)

    latter_half_fft_step(rest, first_index + 1, [sum | acc], number, lookahead)
  end

  def latter_half_fft_step([], _first_index, acc, _, _), do: Enum.reverse(acc)

  def latter_half_fft_step(
        [number | rest],
        first_index,
        acc = [last_sum | _rest],
        last_number,
        []
      ) do
    sum = (last_sum - last_number) |> Integer.mod(10)

    latter_half_fft_step(rest, first_index + 1, [sum | acc], number, [])
  end

  def latter_half_fft_step([number | rest], first_index, acc = [last_sum | _rest], last_number, [
        add | lookahead
      ]) do
    sum = (last_sum - last_number + add) |> Integer.mod(10)

    latter_half_fft_step(rest, first_index + 1, [sum | acc], number, lookahead)
  end
end
