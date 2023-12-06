import gleam/int
import gleam/string

pub fn unwrap(r: Result(a, Nil)) -> a {
  let assert Ok(i) = r
  i
}

pub fn parse_int(s: String) -> Int {
  let assert Ok(i) = int.parse(string.trim(s))
  i
}
