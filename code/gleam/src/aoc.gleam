import gleam/int
import simplifile
import gleam/io

import aoc_2025/day_1

pub fn main() {
  let assert Ok(input) = simplifile.read("../../input/2025/day_1.txt")

  let out = input
  |> day_1.parse
  |> day_1.pt_1()
  |> int.to_string
  io.println("Part one: " <> out)

  let out = input
  |> day_1.parse
  |> day_1.pt_2()
  |> int.to_string
  io.println("Part two: " <> out)
}
