import gleam/list
import gleam/int
import gleam/string

pub type Rotation {
  Left Right
}
pub type Dial {
  Dial(position: Int)
}

pub fn pt_1(moves: List(#(Rotation, Int))) -> Int {
  Dial(50)
  |> decrypt(moves, fn(dial, move) {
    let #(rotation, power) = move
    case rotate(dial, rotation, power) {
      Dial(0) -> 1
      Dial(_) -> 0
    }
  })
}

pub fn pt_2(moves: List(#(Rotation, Int))) -> Int {
  Dial(50)
  |> decrypt(moves, fn(dial, move) {
    let #(rotation, power) = move
    case rotate(dial, rotation, power) {
      Dial(0) -> 1
      Dial(_) -> 0
    }
    +
    case rotation, dial {
      Left, Dial(0) if power > 0 -> -1
      _, Dial(_) -> 0
    }
    +
    case rotation, dial {
      // Some silly code
      Left,  Dial(pose) if pose - power < -900 -> 10
      Left,  Dial(pose) if pose - power < -800 -> 9
      Left,  Dial(pose) if pose - power < -700 -> 8
      Left,  Dial(pose) if pose - power < -600 -> 7
      Left,  Dial(pose) if pose - power < -500 -> 6
      Left,  Dial(pose) if pose - power < -400 -> 5
      Left,  Dial(pose) if pose - power < -300 -> 4
      Left,  Dial(pose) if pose - power < -200 -> 3
      Left,  Dial(pose) if pose - power < -100 -> 2
      Left,  Dial(pose) if pose - power < 0 -> 1

      Right, Dial(pose) if pose + power > 1000 -> 10
      Right, Dial(pose) if pose + power > 900 -> 9
      Right, Dial(pose) if pose + power > 800 -> 8
      Right, Dial(pose) if pose + power > 700 -> 7
      Right, Dial(pose) if pose + power > 600 -> 6
      Right, Dial(pose) if pose + power > 500 -> 5
      Right, Dial(pose) if pose + power > 400 -> 4
      Right, Dial(pose) if pose + power > 300 -> 3
      Right, Dial(pose) if pose + power > 200 -> 2
      Right, Dial(pose) if pose + power > 100 -> 1
      _, _ -> 0
    }
  })
}

pub fn parse(input: String) -> List(#(Rotation, Int)) {
  let moves = input
  |> string.trim
  |> string.split("\n")
  list.map(moves, fn(line) {
    let #(rotation, power) = case line {
      "L" <> p -> #(Left,  p)
      "R" <> p -> #(Right, p)
      _ -> panic as "Invalid move!"
    }
    let assert Ok(power) = int.parse(power)
    #(rotation, power)
  })
}

fn rotate(
  dial     : Dial,
  rotation : Rotation,
  power    : Int
)
-> Dial {
  let pose: Int = dial.position
  let out = case rotation, power {
    Right, power -> int.modulo(pose + power, 100)
    Left,  power -> int.modulo(pose - power, 100)
  }
  case out {
    Ok(out)  -> Dial(out)
    Error(_) -> panic as "Invalid move!"
  }
}

fn decrypt(
  dial: Dial,
  moves: List(#(Rotation, Int)),
  method: fn(Dial, #(Rotation, Int)) -> Int
)
-> Int {
  decode(dial, moves, method, [])
  |> listen(0)
}

fn decode(
  dial   : Dial,
  moves  : List(#(Rotation, Int)),
  method : fn(Dial, #(Rotation, Int)) -> Int,
  list   : List(Int)
)
-> List(Int) {
  case moves {
    [] -> list
    [move, ..remaining] -> {
      let #(rotation, power) = move
      decode(
        rotate(dial, rotation, power),
        remaining,
        method,
        [method(dial, move), ..list]
      )
    }
  }
}

fn listen(clicks: List(Int), acc: Int) -> Int {
  case clicks {
    [] -> acc
    [click, ..remaining] -> listen(remaining, acc + click)
  }
}
