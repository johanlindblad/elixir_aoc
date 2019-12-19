defmodule Aoc.Year2019.Day19.TractorBeam do
  @moduledoc """
  ## --- Day 19: Tractor Beam ---

  Unsure of the state of Santa's ship, you borrowed the tractor beam technology
  from Triton. Time to test it out.

  When you're safely away from anything else, you activate the tractor beam, but
  nothing happens. It's hard to tell whether it's working if there's nothing to
  use it on. Fortunately, your ship's drone system can be configured to deploy a
  drone to specific coordinates and then check whether it's being pulled. There's
  even an Intcode program (your puzzle input) that gives you access to the drone
  system.

  The program uses two input instructions to request the *X and Y position* to
  which the drone should be deployed. Negative numbers are invalid and will
  confuse the drone; all numbers should be *zero or positive*.

  Then, the program will output whether the drone is *stationary* (`0`) or *being
  pulled by something* (`1`). For example, the coordinate X=`0`, Y=`0` is directly
  in front of the tractor beam emitter, so the drone control program will always
  report `1` at that location.

  To better understand the tractor beam, it is important to *get a good picture*
  of the beam itself. For example, suppose you scan the 10x10 grid of points
  closest to the emitter:

  `       X
    0->      9
   0#.........
   |.#........
   v..##......
    ...###....
    ....###...
  Y .....####.
    ......####
    ......####
    .......###
   9........##
  `In this example, the *number of points affected by the tractor beam* in the
  10x10 area closest to the emitter is `*27*`.

  However, you'll need to scan a larger area to *understand the shape* of the
  beam. *How many points are affected by the tractor beam in the 50x50 area
  closest to the emitter?* (For each of X and Y, this will be `0` through `49`.)


  """

  alias Aoc.Year2019.IntcodeComputer

  @doc """

  """
  def part_1(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    map = run(computer)

    # Enum.each(0..49, fn y ->
    # Enum.map(0..49, fn x -> map[{x, y}] end)
    # |> Enum.join("")
    # |> IO.puts()
    # end)

    map |> Map.values() |> Enum.sum()
  end

  def run(computer) do
    for y <- 0..49,
        x <- 0..49,
        computer = IntcodeComputer.feed(computer, [x, y]),
        {_computer, [result]} = IntcodeComputer.consume(computer),
        into: %{},
        do: {{x, y}, result}
  end

  @doc """

  """
  def part_2(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    {x, y} = run2(computer, 0)

    x * 10000 + y
  end

  @width 100
  def run2(computer, y, start_x \\ 0) do
    {width, _, new_start_x} =
      Stream.iterate(start_x, fn start_x -> start_x + 1 end)
      |> Enum.reduce_while({0, false, 0}, fn x, {width, found, new_start_x} ->
        {_computer, [result]} =
          IntcodeComputer.feed(computer, [x, y]) |> IntcodeComputer.consume()

        case {result, found, x} do
          {1, false, _} -> {:cont, {1, true, x}}
          {1, true, _} -> {:cont, {1 + width, true, new_start_x}}
          {_, _, x} when x - start_x > 30 -> {:halt, {width, found, new_start_x}}
          {0, false, _} -> {:cont, {0, false, new_start_x}}
          {0, true, _} -> {:halt, {width, true, new_start_x}}
        end
      end)

    cond do
      width < @width ->
        run2(computer, y + 1, Enum.max([start_x, new_start_x]))

      width >= @width ->
        right_most_x = new_start_x + width - 1
        {rx, ly} = {right_most_x, y + @width - 1}
        lx = right_most_x - @width + 1

        {_computer2, [left]} =
          IntcodeComputer.feed(computer, [lx, ly]) |> IntcodeComputer.consume()

        {_computer2, [right]} =
          IntcodeComputer.feed(computer, [rx, ly]) |> IntcodeComputer.consume()

        case {left, right} do
          {1, 1} -> {lx, y}
          _other -> run2(computer, y + 1, Enum.max([start_x, new_start_x]))
        end
    end
  end
end
