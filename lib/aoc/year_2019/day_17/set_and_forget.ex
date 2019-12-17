defmodule Aoc.Year2019.Day17.SetandForget do
  @moduledoc """
  ## --- Day 17: Set and Forget ---

  An early warning system detects an incoming solar flare and automatically
  activates the ship's electromagnetic shield. Unfortunately, this has cut off the
  Wi-Fi for many small robots that, unaware of the impending danger, are now
  trapped on exterior scaffolding on the unsafe side of the shield. To rescue
  them, you'll have to act quickly!

  The only tools at your disposal are some wired cameras and a small vacuum robot
  currently asleep at its charging station. The video quality is poor, but the
  vacuum robot has a needlessly bright LED that makes it easy to spot no matter
  where it is.

  An Intcode program, the *Aft Scaffolding Control and Information Interface*
  (ASCII, your puzzle input), provides access to the cameras and the vacuum robot.
  Currently, because the vacuum robot is asleep, you can only access the cameras.

  Running the ASCII program on your Intcode computer will provide the current view
  of the scaffolds. This is output, purely coincidentally, as ASCII code: `35`
  means `#`, `46` means `.`, `10` starts a new line of output below the current
  one, and so on. (Within a line, characters are drawn left-to-right.)

  In the camera output, `#` represents a scaffold and `.` represents open space.
  The vacuum robot is visible as `^`, `v`, `<`, or `>` depending on whether it is
  facing up, down, left, or right respectively. When drawn like this, the vacuum
  robot is *always on a scaffold*; if the vacuum robot ever walks off of a
  scaffold and begins *tumbling through space uncontrollably*, it will instead be
  visible as `X`.

  In general, the scaffold forms a path, but it sometimes loops back onto itself.
  For example, suppose you can see the following view from the cameras:

  `..#..........
  ..#..........
  #######...###
  #.#...#...#.#
  #############
  ..#...#...#..
  ..#####...^..
  `Here, the vacuum robot, `^` is facing up and sitting at one end of the scaffold
  near the bottom-right of the image. The scaffold continues up, loops across
  itself several times, and ends at the top-left of the image.

  The first step is to calibrate the cameras by getting the *alignment parameters*
  of some well-defined points. Locate all *scaffold intersections*; for each, its
  alignment parameter is the distance between its left edge and the left edge of
  the view multiplied by the distance between its top edge and the top edge of the
  view. Here, the intersections from the above image are marked `O`:

  `..#..........
  ..#..........
  ##O####...###
  #.#...#...#.#
  ##O###O###O##
  ..#...#...#..
  ..#####...^..
  `For these intersections:

  - The top-left intersection is `2` units from the left of the image and `2` units from the top of the image, so its alignment parameter is `2 * 2 = *4*`.
  - The bottom-left intersection is `2` units from the left and `4` units from the top, so its alignment parameter is `2 * 4 = *8*`.
  - The bottom-middle intersection is `6` from the left and `4` from the top, so its alignment parameter is `*24*`.
  - The bottom-right intersection's alignment parameter is `*40*`.
  To calibrate the cameras, you need the *sum of the alignment parameters*. In the
  above example, this is `*76*`.

  Run your ASCII program. *What is the sum of the alignment parameters* for the
  scaffold intersections?


  """

  alias Aoc.Year2019.IntcodeComputer

  def part_1(input) do
    # IO.puts(rle(moves) |> Enum.join(", "))
    {intersections, _} = intersections_and_moves(input)

    intersections
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  def intersections_and_moves(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    {computer, output} = IntcodeComputer.consume(computer)

    rows = output |> to_string() |> String.split("\n")

    {map, robot, robot_direction} = parse(rows)

    {_intersections, _moves} = step(map, robot, robot_direction)
  end

  def parse(output, map \\ %{}, robot \\ nil, robot_direction \\ nil, y \\ 0)
  def parse([], map, robot, robot_direction, _Y), do: {map, robot, robot_direction}

  def parse([row | rest], map, robot, robot_direction, y) do
    {map, robot, robot_direction} =
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, x} -> char != "." end)
      |> Enum.reduce({map, robot, robot_direction}, fn {char, x}, {map, robot, robot_direction} ->
        {robot, robot_direction} =
          case robot?(char) do
            true -> {{x, y}, robot_direction(char)}
            false -> {robot, robot_direction}
          end

        map = Map.put(map, {x, y}, true)
        {map, robot, robot_direction}
      end)

    parse(rest, map, robot, robot_direction, y + 1)
  end

  def step(map, robot, robot_direction, intersections \\ MapSet.new(), moves \\ [])

  def step(map, {x, y}, {dx, dy}, intersections, moves) do
    straight = Map.get(map, {x + dx, y + dy}, false)

    {ldx, ldy} = turn({dx, dy}, 0)
    left = Map.get(map, {x + ldx, y + ldy}, false)

    {rdx, rdy} = turn({dx, dy}, 1)
    right = Map.get(map, {x + rdx, y + rdy}, false)
    # print(map, {x, y}, {dx, dy}) |> IO.puts()
    # IO.inspect({dx, dy})
    # IO.inspect({straight, left, right})
    # IO.puts("\n\n")

    case {straight, left, right} do
      {true, false, false} ->
        step(map, {x + dx, y + dy}, {dx, dy}, intersections, [1 | moves])

      {true, true, true} ->
        step(map, {x + dx, y + dy}, {dx, dy}, MapSet.put(intersections, {x, y}), [1 | moves])

      {false, true, false} ->
        step(map, {x + ldx, y + ldy}, {ldx, ldy}, intersections, [1, "L" | moves])

      {false, false, true} ->
        step(map, {x + rdx, y + rdy}, {rdx, rdy}, intersections, [1, "R" | moves])

      {false, false, false} ->
        {intersections, Enum.reverse(moves)}
    end
  end

  @robot ["^", "v", ">", "<"]
  @directions [{0, -1}, {0, 1}, {1, 0}, {-1, 0}, {0, -1}]
  def robot?(char), do: Enum.find(@robot, &(&1 == char)) != nil

  def direction_char(direction) do
    index = Enum.find_index(@directions, &(&1 == direction))
    Enum.at(@robot, index)
  end

  def robot_direction(char) do
    index = Enum.find_index(@robot, &(&1 == char))
    Enum.at(@directions, index)
  end

  # Left = 0, right = 1
  def turn({0, dy}, 0), do: {dy, 0}
  def turn({dx, 0}, 0), do: {0, -dx}
  def turn({0, dy}, 1), do: {-dy, 0}
  def turn({dx, 0}, 1), do: {0, dx}

  @doc """

  """
  def part_2(input) do
    computer =
      input
      |> String.replace_leading("1,", "2,")
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    {_, moves} = intersections_and_moves(input)

    path = rle(moves) |> Enum.join(", ")

    {moves, [a, b, c], _} = compress(path, ["A", "B", "C"])

    {computer, output} = IntcodeComputer.consume(computer)
    moves = (moves <> "\n") |> String.graphemes()
    a = (a <> "\n") |> String.graphemes()
    b = (b <> "\n") |> String.graphemes()
    c = (c <> "\n") |> String.graphemes()
    yn = "n\n" |> String.graphemes()

    computer = IntcodeComputer.feed(computer, moves ++ a ++ b ++ c ++ yn)

    {computer, output} = IntcodeComputer.consume(computer)
    output |> List.last()
  end

  def print(map, {robot_x, robot_y}, direction) do
    {_, {max_x, _}} = Map.keys(map) |> Enum.min_max_by(fn {x, _} -> x end)
    {_, {_, max_y}} = Map.keys(map) |> Enum.min_max_by(fn {_, y} -> y end)

    0..max_y
    |> Enum.map(fn y ->
      Enum.map(0..max_x, fn x ->
        case {x, y} do
          {^robot_x, ^robot_y} -> direction_char(direction)
          {x, y} -> Map.get(map, {x, y}, false) |> char
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  def rle(list, acc \\ [])
  def rle([], acc), do: Enum.reverse(acc)

  def rle([1 | rest], [n | acc_rest]) when is_integer(n) do
    rle(rest, [n + 1 | acc_rest])
  end

  def rle([head | rest], acc) do
    rle(rest, [head | acc])
  end

  def char(true), do: "#"
  def char(false), do: " "

  @vars ["A", "B", "C"]

  def compress(string, vars_left \\ ["A", "B", "C"], vars_used \\ [], values \\ [])

  def compress(string, [], vars_used, values) do
    string
    |> String.split(",")
    |> Enum.filter(fn part ->
      Enum.find(vars_used, fn var -> part == var end) == nil
    end)
    |> Enum.empty?()
  end

  def compress(string, [next_var | vars_left], vars_used, values) do
    parts =
      String.split(string, ",")
      |> Enum.drop_while(fn elem ->
        Enum.find(vars_used, fn val -> val == elem end)
      end)

    string = parts |> Enum.join(",")

    1..10
    |> Enum.find_value(fn len ->
      {var_parts, rest} = Enum.split(parts, len)
      var = Enum.join(var_parts, ",")

      string = string |> String.replace(var, next_var)
      parts = String.split(string, ",")

      case compress(string, vars_left, [next_var | vars_used], [var | values]) do
        {_str, vals, vars} ->
          vals = [var | vals]
          vars = [next_var | vars]
          zipped = Enum.zip(vars, vals)

          out =
            Enum.reduce(zipped, string, fn {var, val}, string ->
              string |> String.replace(val, var)
            end)

          {out, vals, vars}

        true ->
          {"", [var], [next_var]}

        _ ->
          false
      end
    end)
  end
end
