---
date: 2026-11-17
---

<!--
SPDX-FileCopyrightText: 2026 smolmut contributors
SPDX-License-Identifier: MIT OR Apache-2.0
-->

# Publish manually

## Status

Accepted.

## Context

The custom release controller uploads directly to Hex and bypasses checks in `gleam publish`, as reported in [issue 87](https://github.com/P4suta/smolmut/issues/87).
The requested scope is mutation testing, with the automated release system removed.

## Decision

Remove automated version proposals, release workflows, custom registry clients, distribution builders, and their dedicated verification.
Keep the `smolmut` package, CLI, library, and mutation-engine verification.
Use the official `gleam publish` command for any future manual Hex publication.
Use source checkouts for development and local dependencies.

## Alternatives

Maintaining the controller would preserve automated distributions but keep a separate publishing implementation.
Wrapping `gleam publish` would keep unwanted automation.

## Consequences

Release preparation and publication require manual action.
The repository no longer builds npm packages or escript distributions.
Published versions, tags, and immutable GitHub releases remain historical records.
The [release guide](../releasing.md) describes the manual process.

## Confirmation

Project checks, the runtime matrix, and integration tests must pass after removal.
No executable custom publication path may remain.
Reconsider automation when a distribution need justifies maintaining it around the official Gleam publisher.
