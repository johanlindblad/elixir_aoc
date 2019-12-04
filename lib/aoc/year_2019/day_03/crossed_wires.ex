defmodule Aoc.Year2019.Day03.CrossedWires do
  @moduledoc """
  ## --- Day 3: Crossed Wires ---

  The gravity assist was successful, and you're well on your way to the Venus
  refuelling station. During the rush back on Earth, the fuel management system
  wasn't completely installed, so that's next on the priority list.

  Opening the front panel reveals a jumble of wires. Specifically, *two wires* are
  connected to a central port and extend outward on a grid. You trace the path
  each wire takes as it leaves the central port, one wire per line of text (your
  puzzle input).

  The wires twist and turn, but the two wires occasionally cross paths. To fix the
  circuit, you need to *find the intersection point closest to the central port*.
  Because the wires are on a grid, use the Manhattan distance for this
  measurement. While the wires do technically cross right at the central port
  where they both start, this point does not count, nor does a wire count as
  crossing with itself.

  For example, if the first wire's path is `R8,U5,L5,D3`, then starting from the
  central port (`o`), it goes right `8`, up `5`, left `5`, and finally down `3`:

  `...........
  ...........
  ...........
  ....+----+.
  ....|....|.
  ....|....|.
  ....|....|.
  .........|.
  .o-------+.
  ...........
  `Then, if the second wire's path is `U7,R6,D4,L4`, it goes up `7`, right `6`,
  down `4`, and left `4`:

  `...........
  .+-----+...
  .|.....|...
  .|..+--X-+.
  .|..|..|.|.
  .|.-*X*--+.|.
  .|..|....|.
  .|.......|.
  .o-------+.
  ...........
  `These wires cross at two locations (marked `X`), but the lower-left one is
  closer to the central port: its distance is `3 + 3 = 6`.

  Here are a few more examples:

  - `R75,D30,R83,U83,L12,D49,R71,U7,L72U62,R66,U55,R34,D71,R55,D58,R83` = distance `159`
  - `R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51U98,R91,D20,R16,D67,R40,U7,R15,U6,R7` = distance `135`
  *What is the Manhattan distance* from the central port to the closest
  intersec
  ## --- Part Two ---

  It turns out that this circuit is very timing-sensitive; you actually need to
  *minimize the signal delay*.

  To do this, calculate the *number of steps* each wire takes to reach each
  intersection; choose the intersection where the *sum of both wires' steps* is
  lowest. If a wire visits a position on the grid multiple times, use the steps
  value from the *first* time it visits that position when calculating the total
  value of a specific intersection.

  The number of steps a wire takes is the total number of grid squares the wire
  has entered to get to that location, including the intersection being
  considered. Again consider the example from above:

  `...........
  .+-----+...
  .|.....|...
  .|..+--X-+.
  .|..|..|.|.
  .|.-X--+.|.
  .|..|....|.
  .|.......|.
  .o-------+.
  ...........
  `In the above example, the intersection closest to the central port is reached
  after `8+5+5+2 = *20*` steps by the first wire and `7+6+4+3 = *20*` steps by the
  second wire for a total of `20+20 = *40*` steps.

  However, the top-right intersection is better: the first wire takes only `8+5+2
  = *15*` and the second wire takes only `7+6+2 = *15*`, a total of `15+15 = *30*`
  steps.

  Here are the best steps for the extra examples from above:

  - `R75,D30,R83,U83,L12,D49,R71,U7,L72U62,R66,U55,R34,D71,R55,D58,R83` = `610` steps
  - `R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51U98,R91,D20,R16,D67,R40,U7,R15,U6,R7` = `410` steps
  *What is the fewest combined steps the wires must take to reach an
  intersection?*

  tion?


  """

  @doc """

  """
  def part_1(input) do
    [wire1, wire2] = input |> parse_input

    {matrix, []} = simulate(%{}, wire1, 1)
    {_matrix, overlaps} = simulate(matrix, wire2, 2)

    overlaps
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.filter(&(&1 > 0))
    |> Enum.min()
  end

  def simulate(matrix, coordinates, wire_number, steps \\ 0, overlaps \\ [])
  def simulate(matrix, [{_x, _y}], _wire_number, _steps, overlaps), do: {matrix, overlaps}

  def simulate(matrix, [p1 = {x1, y1}, p2 = {x2, y2} | rest], wire_number, steps, overlaps) do
    coords =
      case {p1, p2} do
        {{x, ^y1}, {x, ^y2}} ->
          y1..y2 |> Enum.map(fn y -> {x, y} end) |> Enum.with_index(steps)

        {{^x1, y}, {^x2, y}} ->
          x1..x2 |> Enum.map(fn x -> {x, y} end) |> Enum.with_index(steps)
      end

    {_, last_step} = coords |> List.last()

    {matrix, overlaps} =
      Enum.reduce(coords, {matrix, overlaps}, fn {{x, y}, steps}, {matrix, overlaps} ->
        history = Map.get(matrix, {x, y}, %{})

        case {Map.get(history, wire_number), map_size(history)} do
          {nil, 0} ->
            {Map.put(matrix, {x, y}, Map.put(%{}, wire_number, steps)), overlaps}

          {nil, _size} ->
            {Map.put(matrix, {x, y}, Map.put(history, wire_number, steps)), [{x, y} | overlaps]}

          {_some_steps, 1} ->
            {matrix, overlaps}

          {_some_steps, _size} ->
            {matrix, [{x, y} | overlaps]}
        end
      end)

    simulate(matrix, [{x2, y2} | rest], wire_number, last_step, overlaps)
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line |> String.split(",") |> Enum.map(&parse_delta/1) |> to_coordinates
  end

  def parse_delta("R" <> rest), do: {String.to_integer(rest), 0}
  def parse_delta("L" <> rest), do: {-String.to_integer(rest), 0}
  def parse_delta("U" <> rest), do: {0, -String.to_integer(rest)}
  def parse_delta("D" <> rest), do: {0, String.to_integer(rest)}

  def to_coordinates(deltas, coordinates \\ [{0, 0}])
  def to_coordinates([], coordinates), do: Enum.reverse(coordinates)

  def to_coordinates([{dx, dy} | tail], [{px, py} | rest]) do
    to_coordinates(tail, [{dx + px, dy + py}, {px, py} | rest])
  end

  @doc """

  """
  def part_2(input) do
    [wire1, wire2] = input |> parse_input

    {matrix, []} = simulate(%{}, wire1, 1)
    {matrix, overlaps} = simulate(matrix, wire2, 2)

    overlaps
    |> Enum.filter(fn {x, y} -> {x, y} != {0, 0} end)
    |> Enum.map(fn {x, y} -> Map.get(matrix, {x, y}) |> Map.values() |> Enum.sum() end)
    |> Enum.filter(&(&1 > 0))
    |> Enum.min()
  end
end
