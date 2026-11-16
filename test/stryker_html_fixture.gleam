// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

import gleam/io
import smolmut/stryker_html
import stryker_schema_fixture

pub fn main() {
  let assert Ok(html) =
    stryker_schema_fixture.fixture_json()
    |> stryker_html.render
  io.print(html)
}
