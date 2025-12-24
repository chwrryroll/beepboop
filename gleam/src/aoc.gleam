import simplifile

import gleam/int
import gleam/io

import aoc_2025/day_1
import aoc_2025/day_2

pub fn main() {
  io.println("~~~~ Day 1 ~~~~")
  let assert Ok(ctx) = simplifile.read("../input/2025/day_1.txt")
  let input = day_1.parse(ctx)

  let out = input
  |> day_1.pt_1
  |> int.to_string
  io.println("Part one: " <> out)

  let out = input
  |> day_1.pt_2
  |> int.to_string
  io.println("Part two: " <> out)

  io.println("~~~~ Day 2 ~~~~")
  let assert Ok(ctx) = simplifile.read("../input/2025/day_2.txt")
  let input = day_2.parse(ctx)

  let out = input
  |> day_2.pt_1
  |> int.to_string
  io.println("Part one: " <> out)

  let out = input
  |> day_2.pt_2
  |> int.to_string
  io.println("Part two: " <> out)
}
