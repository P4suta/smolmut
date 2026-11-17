---
date: 2026-10-29
---

<!--
SPDX-FileCopyrightText: 2026 gleam_mutants contributors
SPDX-License-Identifier: MIT OR Apache-2.0
-->

# Publish verified candidate artifacts

## Status

Superseded by [manual publication](publish-manually-with-gleam.md).

## Context

Custom distribution required preserving the exact bytes checked before publication.
Rebuilding in a privileged job could change those bytes.

## Decision

Use a separate candidate workflow and bind prepared artifacts to source, version, producer, and digests.
Use a Rust controller to separate preparation, registry writes, and GitHub finalization.

## Alternatives

A single build-and-publish job would combine compilation with registry authority.

## Consequences

The project needed custom publication clients, protected environments, provenance, and recovery logic.
The successor removes that system and uses `gleam publish`.

## Confirmation

The controller had native tests and source-bound Kani checks.
The successor defines verification after removal.
