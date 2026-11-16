// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

import gleam/int
import gleam/result
import smolmut/cli
import smolmut/platform

pub fn main() {
  let code =
    platform.env("SMOLMUT_INTERRUPT_CODE")
    |> int.parse
    |> result.unwrap(130)
    |> int.to_string
  let command = case platform.env("SMOLMUT_TEST_MODE") {
    "batch" -> "process.exit(process.env.SMOLMUT_ACTIVE ? " <> code <> " : 0)"
    _ -> "process.exit(" <> code <> ")"
  }
  cli.run([
    "--root", "fixtures/basic_project", "run", "--report", "none",
    "--test-command", "node", "-e", command,
  ])
  platform.exit(99)
}
