import gleam/bool
import gleam/list
import gleam/int
import gleam/string

type Bank    = List(Int)
type Joltage = Int

pub fn parse(input: String) -> List(Bank) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn (bank) {
    bank
    |> string.split("")
    |> list.map(fn (battery) {
      let assert Ok(value) = battery
      |> int.parse
      value
    })
  })
}

pub fn pt_1(banks: List(Bank)) -> Int {
  banks
  |> list.map(turn_on)
  |> int.sum
}

fn turn_on(bank: Bank) -> Joltage {
  let assert Ok(center) = bank
  |> list.max(int.compare)

  use <- bool.guard(
    list.count(bank, fn (x) { x == center }) > 1,
    return: int.add(center * 10, center)
  )

  let #(head, tail) = bank
  |> list.split_while(fn (x) { x != center })

 case
    head  |> list.max(int.compare),
    tail  |> list.drop(1) |> list.max(int.compare)
  {
    Error(_), Error(_)  -> panic as "Invalid input"
    Ok(left), Error(_)  -> int.add(left   * 10, center)
    Error(_), Ok(right) -> int.add(center * 10, right)
    Ok(left), Ok(right) -> int.max(
      int.add(center * 10, right),
      int.add(left   * 10, center)
    )
  }
}
