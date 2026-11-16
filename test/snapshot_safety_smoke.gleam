// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

import gleam/list
import gleam/string
import smolmut/platform
import smolmut/snapshot

pub fn main() {
  let assert [mode, workspace] = platform.arguments()
  case mode {
    "valid" -> {
      let assert Ok(copy) = snapshot.create(workspace)
      let paths = list.map(snapshot.entries(copy), fn(entry) { entry.path })
      assert list.contains(paths, "gleam.toml")
      assert list.contains(paths, "src/main.gleam")
      assert list.contains(paths, "test/corpus/case.json")
      assert !list.any(paths, fn(path) { string.starts_with(path, "build/") })
      assert !list.any(paths, fn(path) {
        string.starts_with(path, "node_modules/")
      })
      assert !list.any(paths, fn(path) { string.starts_with(path, ".smolmut/") })
      assert !list.any(paths, fn(path) {
        string.contains(path, "/node_modules/")
      })
      let assert Ok(Nil) = snapshot.dispose(copy)
      Nil
    }
    "reject" -> {
      let assert Error(message) = snapshot.create(workspace)
      assert string.contains(message, "symlink or junction")
    }
    "generated-links" -> {
      let assert Ok(copy) = snapshot.create(workspace)
      let built =
        platform.run_process(
          "gleam",
          ["build", "--target", "erlang"],
          snapshot.root(copy),
          [],
          30_000,
        )
      assert built.status == 0
      let assert Ok(Nil) = snapshot.dispose(copy)
      Nil
    }
    _ -> panic as "unknown snapshot safety mode"
  }
}
