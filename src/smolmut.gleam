//// The stable command-line entrypoint for `smolmut`.
////
//// The remaining modules are implementation details and are intentionally marked internal in `gleam.toml`.

// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

/// Runs the `smolmut` command-line interface.
import smolmut/cli

pub fn main() -> Nil {
  cli.main()
}
