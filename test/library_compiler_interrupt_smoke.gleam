// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

import gleam/int
import gleam/io
import gleam/option.{Some}
import gleam/result
import gleam/string
import smolmut/api
import smolmut/platform
import smolmut/types

pub fn main() {
  let code =
    platform.env("SMOLMUT_INTERRUPT_CODE")
    |> int.parse
    |> result.unwrap(130)
  let options =
    types.Options(
      ..api.default_options(),
      test_command: Some(["node", "-e", "process.exit(0)"]),
    )
  let assert Error(types.Interrupted(actual, diagnostic)) =
    api.validate_mutants("fixtures/basic_project", options)
  assert actual == code
  assert string.contains(diagnostic, "compiler-interrupt-output")
  let assert Error(types.Interrupted(actual, _)) =
    api.run("fixtures/basic_project", options)
  assert actual == code
  let assert Ok(_) = api.list_mutants("fixtures/basic_project", options)
  io.println("API compiler host continued after " <> int.to_string(code))
}
