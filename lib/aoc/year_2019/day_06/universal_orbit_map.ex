defmodule Aoc.Year2019.Day06.UniversalOrbitMap do
  @moduledoc """
  ## --- Day 6: Universal Orbit Map ---

  You've landed at the Universal Orbit Map facility on Mercury. Because navigation
  in space often involves transferring between orbits, the orbit maps here are
  useful for finding efficient routes between, for example, you and Santa. You
  download a map of the local orbits (your puzzle input).

  Except for the universal Center of Mass (`COM`), every object in space is in
  orbit around exactly one other object. An orbit looks roughly like this:

  `                  \
                     \
                      |
                      |
  AAA--> o            o <--BBB
                      |
                      |
                     /
                    /
  `In this diagram, the object `BBB` is in orbit around `AAA`. The path that `BBB`
  takes around `AAA` (drawn with lines) is only partly shown. In the map data,
  this orbital relationship is written `AAA)BBB`, which means "`BBB` is in orbit
  around `AAA`".

  Before you use your map data to plot a course, you need to make sure it wasn't
  corrupted during the download. To verify maps, the Universal Orbit Map facility
  uses *orbit count checksums* - the total number of *direct orbits* (like the one
  shown above) and *indirect orbits*.

  Whenever `A` orbits `B` and `B` orbits `C`, then `A`*indirectly orbits*`C`. This
  chain can be any number of objects long: if `A` orbits `B`, `B` orbits `C`, and
  `C` orbits `D`, then `A` indirectly orbits `D`. For example, suppose you have
  the following map: `COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L `Visually, the
  above map of orbits looks like this: ` G - H J - K - L / / COM - B - C - D - E -
  F \ I `In this visual representation, when two objects are connected by a line,
  the one on the right directly orbits the one on the left. Here, we can count the
  total number of orbits as follows: - `D` directly orbits `C` and indirectly
  orbits `B` and `COM`, a total of `3` orbits. - `L` directly orbits `K` and
  indirectly orbits `J`, `E`, `D`, `C`, `B`, and `COM`, a total of `7` orbits. -
  `COM` orbits nothing. The total number of direct and indirect orbits in this
  example is `*42*`. *What is the total number of direct and indirect orbits* in
  your map
  ## --- Part Two ---

  Now, you just need to figure out how many *orbital transfers* you (`YOU`) need
  to take to get to Santa (`SAN`).

  You start at the object `YOU` are orbiting; your destination is the object `SAN`
  is orbiting. An orbital transfer lets you move from any object to an object
  orbiting or orbited by that object.

  For example, suppose you have the following map:

  `COM)B
  B)C
  C)D
  D)E
  E)F
  B)G
  G)H
  D)I
  E)J
  J)K
  K)L
  K)YOU
  I)SAN
  `Visually, the above map of orbits looks like this:

  `*YOU**/*
          G - H       *J - K* - L
         /           */*
  COM - B - C - *D - E* - F
                 *\**I - SAN*`In this example, `YOU` are in orbit around `K`, and `SAN` is in orbit around
  `I`. To move from `K` to `I`, a minimum of `4` orbital transfers are required:

  - `K` to `J`
  - `J` to `E`
  - `E` to `D`
  - `D` to `I`
  Afterward, the map of orbits looks like this:

  `        G - H       J - K - L
         /           /
  COM - B - C - D - E - F
                 \
                  I - SAN
                   *\**YOU*`

  What is the minimum number of orbital transfers required* to move from the
  object `YOU` are orbiting to the object `SAN` is orbiting? (Between the objects
  they are orbiting - *not* between `YOU` and `SAN`.)

  """

  @doc """

  """
  def part_1(input) do
    orbits = input |> parse_input

    orbits |> build_graph |> num_orbits
  end

  def parse_input(input) do
    input |> String.split("\n") |> Enum.map(&parse_orbit/1)
  end

  def build_graph(orbits, graph \\ %{})

  def build_graph([{inner, outer} | tail], graph) do
    graph = graph |> Map.put(outer, inner)

    build_graph(tail, graph)
  end

  def build_graph([], graph), do: graph

  defp parse_orbit(line) do
    line |> String.split(")") |> List.to_tuple()
  end

  def num_orbits(graph) do
    Map.keys(graph)
    |> Enum.map(&num_orbits(graph, &1))
    |> Enum.sum()
  end

  def num_orbits(_graph, "COM"), do: 0

  def num_orbits(graph, key) do
    parent = graph[key]
    1 + num_orbits(graph, parent)
  end

  @doc """

  """
  def part_2(input) do
    orbits = input |> parse_input

    graph = orbits |> build_graph

    steps_you = steps_to(graph, "YOU")

    steps_between(graph, "SAN", steps_you, 0) - 2
  end

  def steps_between(graph, key, other_steps, so_far \\ 0)

  def steps_between(graph, key, other_steps, so_far) do
    case Map.get(other_steps, key) do
      nil ->
        steps_between(graph, graph[key], other_steps, so_far + 1)

      some_steps ->
        so_far + some_steps
    end
  end

  def steps_to(graph, key, num_steps \\ 0, step_map \\ %{})

  def steps_to(_graph, "COM", _num_steps, step_map), do: step_map

  def steps_to(graph, key, num_steps, step_map) do
    parent = graph[key]

    step_map = Map.put(step_map, parent, num_steps + 1)

    steps_to(graph, parent, num_steps + 1, step_map)
  end
end
