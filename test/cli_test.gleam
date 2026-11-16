// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

@target(erlang)
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
@target(erlang)
import report_test_support
@target(erlang)
import simplifile
import smolmut/cli
@target(erlang)
import smolmut/core/path
@target(erlang)
import smolmut/platform
@target(erlang)
import smolmut/project_report
@target(erlang)
import smolmut/report
@target(erlang)
import smolmut/snapshot
@target(erlang)
import smolmut/types
@target(erlang)
import smolmut/workspace_lock

@target(erlang)
pub fn a_report_history_write_failure_names_its_code_and_path_test() {
  let previous = platform.env(report_test_support.cache_variable)
  let blocked =
    path.join(
      platform.temporary_directory(),
      "smolmut-red-cache-" <> platform.random_nonce(),
    )
  let assert Ok(Nil) = simplifile.write(blocked, "not a directory\n")
  report_test_support.set_cache_directory(blocked)
  let moved = string.starts_with(platform.cache_directory(), blocked)
  let written = report.save(stub_run_report(), "/nowhere/a-workspace")
  report_test_support.restore_cache_directory(previous)
  let _ = simplifile.delete(blocked)

  case moved {
    False ->
      io.println(
        "skipped: this platform does not read its cache directory from "
        <> report_test_support.cache_variable,
      )
    True -> {
      let assert Error(message) = written
      assert string.starts_with(message, "GMU6002: ")
      assert string.contains(message, blocked)
    }
  }
}

@target(erlang)
pub fn a_project_report_write_failure_names_its_code_and_path_test() {
  let workspace =
    path.join(
      platform.temporary_directory(),
      "smolmut-red-report-" <> platform.random_nonce(),
    )
  let assert Ok(Nil) = simplifile.create_directory_all(workspace)
  let _ = simplifile.set_permissions_octal(workspace, 0o500)
  let unwritable = case
    simplifile.create_directory(path.join(workspace, "probe"))
  {
    Ok(Nil) -> False
    Error(_) -> True
  }
  let written = project_report.write(workspace, "reports/mutation", "{}", "")
  let _ = simplifile.set_permissions_octal(workspace, 0o700)
  let _ = platform.delete_tree(workspace)

  case unwritable {
    False ->
      io.println(
        "skipped: this user can write into a directory it holds no write "
        <> "permission on",
      )
    True -> {
      let assert Error(message) = written
      assert string.starts_with(message, "GMU6003: ")
      assert string.contains(message, path.join(workspace, "reports/mutation"))
    }
  }
}

@target(erlang)
pub fn a_refused_special_file_names_its_code_and_a_way_forward_test() {
  let workspace =
    path.join(
      platform.temporary_directory(),
      "smolmut-red-special-" <> platform.random_nonce(),
    )
  let assert Ok(Nil) = simplifile.create_directory_all(workspace)
  let assert Ok(Nil) =
    simplifile.write(path.join(workspace, "gleam.toml"), "name = \"red\"\n")
  let pipe = path.join(workspace, "a_named_pipe")
  let _ = platform.run_process("mkfifo", [pipe], workspace, [], 10_000)
  let special = case simplifile.link_info(pipe) {
    Ok(info) -> simplifile.file_info_type(info) == simplifile.Other
    Error(_) -> False
  }
  let captured = snapshot.create(workspace)
  let _ = platform.delete_tree(workspace)

  case special {
    False -> io.println("skipped: this platform made no named pipe to refuse")
    True -> {
      let assert Error(message) = captured
      assert string.starts_with(message, "GMU7004: ")
      assert string.contains(message, "a_named_pipe")
      assert string.contains(message, "remove it")
    }
  }
}

@target(erlang)
fn stub_run_report() -> types.RunReport {
  types.RunReport(
    run_id: "20260101T000000Z-000000",
    started_ms: 0,
    duration_ms: 1,
    workspace_digest: string.repeat("f", 64),
    matrix: False,
    selection: types.SelectionSummary(
      mode: "all",
      files_selected: 0,
      candidates: 0,
      executed: 0,
      compile_errors: 0,
      skipped: True,
      reason: Some("nothing to run"),
    ),
    policy: types.PolicySummary(
      strict: False,
      minimum_score: 100.0,
      require_mutants: False,
      failure: None,
    ),
    results: [],
    rejected: [],
    score: types.Score(0, 0, 0, 0, 0, 0.0),
  )
}

@target(erlang)
pub fn a_workspace_cache_directory_that_cannot_be_created_names_its_code_and_path_test() {
  let previous = platform.env(report_test_support.cache_variable)
  let blocked =
    path.join(
      platform.temporary_directory(),
      "smolmut-red-lock-" <> platform.random_nonce(),
    )
  let assert Ok(Nil) = simplifile.write(blocked, "not a directory\n")
  report_test_support.set_cache_directory(blocked)
  let moved = string.starts_with(platform.cache_directory(), blocked)
  let acquired = workspace_lock.acquire("/nowhere/a-workspace")
  report_test_support.restore_cache_directory(previous)
  let _ = simplifile.delete(blocked)

  case moved {
    False ->
      io.println(
        "skipped: this platform does not read its cache directory from "
        <> report_test_support.cache_variable,
      )
    True -> {
      let assert Error(message) = acquired
      assert string.starts_with(message, "GMU7005: ")
      assert string.contains(message, blocked)
    }
  }
}

pub fn a_warning_that_carries_its_code_names_it_once_test() {
  let message = "GMU3001: the snapshot did not compile"
  let line = cli.diagnostic_line("warning", "GMU3001", message, None)

  assert line == "smolmut: GMU3001: the snapshot did not compile"
  assert list.length(string.split(line, "GMU3001")) == 2
}

pub fn a_warning_that_carries_no_code_is_given_one_test() {
  assert cli.diagnostic_line(
      "warning",
      "GMU4001",
      "this run selected no mutant inside a function named `abs`",
      None,
    )
    == "smolmut: GMU4001: this run selected no mutant inside a function "
    <> "named `abs`"
}

pub fn an_error_line_names_the_code_its_message_carries_test() {
  assert cli.diagnostic_line(
      "error",
      "GMU4005",
      "GMU4005: no mutant with id 0F1E2D lives in this run",
      Some("usage: smolmut list --mutant <id>"),
    )
    == "smolmut: GMU4005: no mutant with id 0F1E2D lives in this run"
    <> "\n\nusage: smolmut list --mutant <id>"
}
