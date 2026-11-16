// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

import gleam/list
import gleam/string
import simplifile
import smolmut/cli
import smolmut/config
import smolmut/core/glob
import smolmut/core/mutant
import tomlet

pub fn removed_commands_are_usage_errors_test() {
  list.each(
    [["suggest"], ["explain", "abcdef"], ["apply"], ["run", "--suggest"]],
    fn(arguments) {
      let assert Error(_) = cli.parse(arguments)
      Nil
    },
  )
}

pub fn removed_configuration_is_a_positioned_error_test() {
  let assert Error(config.ConfigError(line, column, message)) =
    config.decode(
      "[tools.smolmut]\nversion = 1\n[tools.smolmut.suggest]\nseed = 1\n",
      4,
    )
  assert line > 0
  assert column > 0
  assert message == "unknown key tools.smolmut.suggest"
}

pub fn main() {
  only_the_supported_entry_modules_are_public_test()
}

pub fn only_the_supported_entry_modules_are_public_test() {
  let assert Ok(source) = simplifile.read("gleam.toml")
  let assert Ok(document) = tomlet.parse(source)
  let assert Ok(tomlet.ArrayValue(values)) =
    tomlet.get(document, ["internal_modules"])
  let assert Ok(patterns) = list.try_map(values, tomlet.as_string)
  let assert Ok(files) = simplifile.get_files("src")
  let public =
    files
    |> list.filter(fn(file) { string.ends_with(file, ".gleam") })
    |> list.map(fn(file) {
      file
      |> mutant.normalize_path
      |> string.drop_start(4)
      |> string.drop_end(6)
    })
    |> list.filter(fn(name) { !list.any(patterns, glob.matches(_, name)) })
    |> list.sort(string.compare)
  assert public == ["smolmut", "smolmut/api", "smolmut/types"]
}
