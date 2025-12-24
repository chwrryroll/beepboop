import gleam/string
import gleam/int
import gleam/list

pub type Range {
  Range(start: Int, end: Int)
}

pub fn parse(input: String) -> List(Range) {
  input
  |> string.replace("\n", "")
  |> string.split(",")
  |> list.map(fn(range) {
    case range
    |> string.split("-")
    {
      [start, end] -> {
        let assert Ok(start) = int.parse(start)
        let assert Ok(end)   = int.parse(end)
        Range(start, end)
      }
      _ -> panic as "Invalid range"
    }
  })
}

pub fn pt_1(input: List(Range)) -> Int {
  invalids(input, is_double)
}

pub fn pt_2(input: List(Range)) -> Int {
  invalids(input, is_repeating)
}

fn invalids(range: List(Range), with: fn(Int) -> Bool) -> Int {
  scan(range, with, 0)
}

fn scan(
  range : List(Range),
  with  : fn(Int) -> Bool,
  acc   : Int
) -> Int {
  case range {
    [ ] -> acc
    [first, ..rest] -> {
      let out = list.range(first.start, first.end)
      |> list.filter(with)
      |> int.sum
      scan(rest, with, out + acc)
    }
  }
}

pub fn is_double(num: Int) -> Bool {
  let graphemes = num
  |> int.to_string
  |> string.to_utf_codepoints

  let length = graphemes
  |> list.length

  let #(first, second) = graphemes
  |> list.split(length / 2)
  first == second
}

pub fn is_repeating(num: Int) -> Bool {
  let graphemes = num
  |> int.to_string
  |> string.to_utf_codepoints

  let assert Ok(first) = list.first(graphemes)
  let limit = graphemes
  |> list.count(fn(r) { r == first })

  try(graphemes, 0, limit - 1)
}

fn try(
  graphemes : List(UtfCodepoint),
  slice     : Int,
  limit     : Int
) -> Bool {
  let assert Ok(first) = list.first(graphemes)
  let assert Ok(rest)  = list.rest(graphemes)

  let root = rest
  |> list.drop(slice)
  |> list.take_while(fn(r) { r != first })
  |> list.append(list.take(rest, slice), _)
  |> list.prepend(first)

  case root {
    list if list == graphemes -> False
    _ -> {
      let out = graphemes
      |> list.sized_chunk(root |> list.length)
      |> list.all(fn(r) { root == r })
      case out, limit > 1 {
        True,  _any  -> True
        False, False -> False
        False, True  -> try(graphemes, list.length(root), limit - 1)
      }
    }
  }
}
