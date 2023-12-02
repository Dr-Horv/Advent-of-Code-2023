import adglent.{First, Second}
import gleam/io
import gleam/string
import gleam/list
import gleam/regex
import gleam/int

fn find_digit(s: String) {
  
  let assert Ok(re) = regex.from_string("\\d")

  let find_first_digit = fn(l: List(String)) -> String {
    let assert Ok(i) = list.find(l, fn (s) { regex.check(with: re, content: s)  })
    i
  }

  let cs = s
  |> string.to_graphemes

  let first = find_first_digit(cs)
  let last = cs
    |> list.reverse
    |> find_first_digit

  let assert Ok(i) =  {first <> last} 
    |> int.parse

  i
}

fn split_and_find_digit(s: String) -> String { 
  s
  |> string.split(on: "\n")
  |> list.map(with: find_digit)
  |> list.fold(0, fn(acc, curr) {acc+curr})
  |> int.to_string
}

pub fn part1(input: String) {
  split_and_find_digit(input)
}

pub fn part2(input: String) {
  input
  |> string.replace(each: "one", with: "one1one")
  |> string.replace(each: "two", with: "two2two")
  |> string.replace(each: "three", with: "three3three")
  |> string.replace(each: "four", with: "four4four")
  |> string.replace(each: "five", with: "five5five")
  |> string.replace(each: "six", with: "six6six")
  |> string.replace(each: "seven", with: "seven7seven")
  |> string.replace(each: "eight", with: "eight8eight")
  |> string.replace(each: "nine", with: "nine9nine")
  |> string.replace(each: "zero", with: "zero0zero")
  |> split_and_find_digit
}

pub fn main() {
  let assert Ok(part) = adglent.get_part()
  let assert Ok(input) = adglent.get_input("01")
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
