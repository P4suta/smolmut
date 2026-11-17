---
date: 2026-11-16
---

<!--
SPDX-FileCopyrightText: 2026 smolmut contributors
SPDX-License-Identifier: MIT OR Apache-2.0
-->

# Name the package smolmut

## Status

Accepted.

## Context

`gleam publish` reserves the `gleam_` prefix for the Gleam core team, as reported in [issue 87](https://github.com/P4suta/smolmut/issues/87).
Release 0.1.0 skipped that check because the release tool uploads to the Hex API directly.

## Decision

Name the Hex, Gleam, and npm packages and the repository `smolmut`.
Gleam names refuse hyphens, so one spelling serves every registry.
Retire `gleam_mutants` 0.1.0 as renamed.
Publication follows the [manual publication decision](publish-manually-with-gleam.md) and the checks in `gleam publish`.
Earlier records that name `gleam_mutants` modules now refer to their `smolmut` counterparts.

## Alternatives

Keeping the name would disregard the Gleam team's request to release the reserved prefix.

## Consequences

Users of 0.1.0 follow the [migration guide](../migration.md).

## Confirmation

`gleam.toml` declares `smolmut`, and the CLI version check verifies the same name.
Reconsider if Gleam or Hex changes its reservation rules.
