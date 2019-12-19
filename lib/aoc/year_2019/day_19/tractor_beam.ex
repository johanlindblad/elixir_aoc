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
    new_start_x =
      start_x..(start_x + 20)
      |> Enum.find(fn x ->
        {_computer, [result]} =
          IntcodeComputer.feed(computer, [x, y]) |> IntcodeComputer.consume()

        result == 1
      end)

    case {new_start_x, y} do
      {nil, y} ->
        run2(computer, y + 1, start_x)

      {x, y} when y < 100 ->
        run2(computer, y + 1, x)

      {_some_x, _y} ->
        upper_left = {new_start_x + @width - 1, y - @width + 1}
        {ux, uy} = upper_left

        {_computer, [result]} =
          IntcodeComputer.feed(computer, [ux, uy]) |> IntcodeComputer.consume()

        case result do
          1 -> {new_start_x, uy}
          0 -> run2(computer, y + 1, new_start_x)
        end
    end
  end
end
