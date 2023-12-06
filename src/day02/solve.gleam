import adglent.{First, Second}
import gleam/io
import gleam/string
import gleam/int
import gleam/list

// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
// Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
// Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
// Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
// Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
type Draw {
  Draw(blue: Int, red: Int, green: Int)
}

type Game {
  Game(id: Int, draws: List(Draw))
}

fn unwrap(r: Result(a, Nil)) -> a {
  let assert Ok(i) = r
  i
}

fn parse_int(s: String) -> Int {
  let assert Ok(i) = int.parse(s)
  i
}

fn parse_color(d: Draw, s: String) -> Draw {
  case string.split(s, on: " ") {
    [nbr_s, ..color_ls] -> {
      let nbr = parse_int(nbr_s)
      let s = string.trim(unwrap(list.first(color_ls)))
      let dr = case s {
        "blue" -> Draw(..d, blue: d.blue + nbr)
        "red" -> Draw(..d, red: d.red + nbr)
        "green" -> Draw(..d, green: d.green + nbr)
      }
      dr
    }
  }
}

fn parse_draw(s: String) -> Draw {
  let parts =
    string.split(s, on: ", ")
    |> list.map(string.trim)
  list.fold(
    over: parts,
    from: Draw(blue: 0, red: 0, green: 0),
    with: parse_color,
  )
}

fn parse_count(g: Game, s: String) -> Game {
  let draws =
    s
    |> string.split(";")
    |> list.map(parse_draw)
  Game(..g, draws: draws)
}

fn parse_game(s: String) -> Game {
  case s {
    "Game " <> rest -> {
      case string.split(rest, on: ":") {
        [id, ..rest] ->
          parse_count(
            Game(id: unwrap(int.parse(id)), draws: []),
            list.first(rest)
            |> unwrap
            |> string.trim,
          )
      }
    }
  }
}

pub fn part1(input: String) {
  input
  |> string.split("\n")
  |> list.map(parse_game)
  |> list.filter(fn(game) {
    game.draws
    |> list.all(fn(draw) {
      draw.red <= 12 && draw.green <= 13 && draw.blue <= 14
    })
  })
  |> list.fold(from: 0, with: fn(acc, curr) { acc + curr.id })
  |> int.to_string
}

pub fn part2(input: String) {
  input
  |> string.split("\n")
  |> list.map(parse_game)
  |> list.map(fn(g) {
    g.draws
    |> list.fold(
      from: Draw(blue: 0, green: 0, red: 0),
      with: fn(acc: Draw, curr: Draw) -> Draw {
        Draw(
          blue: int.max(acc.blue, curr.blue),
          red: int.max(acc.red, curr.red),
          green: int.max(acc.green, curr.green),
        )
      },
    )
  })
  |> list.map(fn(d: Draw) -> Int { d.red * d.blue * d.green })
  |> list.reduce(int.add)
  |> unwrap
  |> int.to_string
}

pub fn main() {
  let assert Ok(part) = adglent.get_part()
  let assert Ok(input) = adglent.get_input("02")
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
