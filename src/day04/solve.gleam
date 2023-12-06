import adglent.{First, Second}
import gleam/io
import gleam/string
import gleam/list
import gleam/int
import util/parse_util.{parse_int, unwrap}

type Card {
  Card(id: Int, winners: List(Int), numbers: List(Int))
}

fn parse_winners_and_numbers(c: Card, s: String) -> Card {
  let parts = string.split(s, "|")

  let parse_numbers = fn(s: String) -> List(Int) {
    s
    |> string.trim
    |> string.split(" ")
    |> list.map(string.trim)
    |> list.filter(fn(s) { !string.is_empty(s) })
    |> list.map(parse_int)
  }

  let winners =
    list.first(parts)
    |> unwrap
    |> parse_numbers

  let numbers =
    list.at(parts, 1)
    |> unwrap
    |> parse_numbers

  Card(..c, winners: winners, numbers: numbers)
}

fn calculate_score(c: Card) -> Int {
  let wins =
    c.numbers
    |> list.filter(fn(n) { list.contains(c.winners, n) })

  case wins {
    [] -> 0
    xs -> list.fold(over: list.drop(xs, 1), from: 1, with: fn(i, _) { i * 2 })
  }
}

fn parse_card(s: String) -> Card {
  case s {
    "Card " <> rest -> {
      case string.split(rest, on: ":") {
        [id, ..rest] -> {
          parse_winners_and_numbers(
            Card(id: parse_int(id), winners: [], numbers: []),
            list.first(rest)
            |> unwrap
            |> string.trim,
          )
        }
      }
    }
  }
}

pub fn part1(input: String) {
  input
  |> string.split("\n")
  |> list.map(parse_card)
  |> list.map(calculate_score)
  |> list.reduce(int.add)
  |> unwrap
  |> int.to_string
}

pub fn part2(input: String) {
  todo as "Implement solution to part 2"
}

pub fn main() {
  let assert Ok(part) = adglent.get_part()
  let assert Ok(input) = adglent.get_input("04")
  case part {
    First ->
      part1(input)
      |> adglent.inspect
      |> io.println
    Second ->
      part2(input)
      |> adglent.inspect
      |> io.println
  }
}
