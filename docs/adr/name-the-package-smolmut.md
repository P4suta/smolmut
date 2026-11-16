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

`gleam publish` reserves the `gleam_` prefix for the Gleam core team ([#87](https://github.com/P4suta/smolmut/issues/87)).
Release 0.1.0 skipped that check because the release tool uploads to the Hex API directly.

## Decision

Name the Hex, Gleam, and npm packages and the repository `smolmut`.
Gleam names refuse hyphens, so one spelling serves every registry.
Retire `gleam_mutants` 0.1.0 as renamed.
`admit_package_name` in `tools/release-core` refuses reserved and malformed names before a registry write.
Earlier records that name `gleam_mutants` modules now refer to their `smolmut` counterparts.

## Alternatives

Keeping the name would hold a reserved prefix against its owners' request.

## Consequences

Users of 0.1.0 follow the [migration guide](../migration.md).

## Confirmation

A Kani harness and a rejecting control cover the name policy, and a release test binds `gleam.toml` to the published name.
Reconsider if Gleam or Hex changes its reservation rules.
