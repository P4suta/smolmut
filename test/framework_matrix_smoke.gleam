// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

import gleam/option.{Some}
import report_test_support
import smolmut/engine.{Options}

pub fn main() {
  let options =
    Options(
      ..engine.default_options(),
      matrix: True,
      strict: Some(False),
      jobs: Some(2),
      timeout_ms: Some(30_000),
    )
  let assert Ok(output) = engine.run("fixtures/unitest_project", options)
  assert output.report.score.total > 0
  assert output.report.score.errors == 0
  report_test_support.cleanup("fixtures/unitest_project")
}
