---
date: 2026-10-30
---

<!--
SPDX-FileCopyrightText: 2026 gleam_mutants contributors
SPDX-License-Identifier: MIT OR Apache-2.0
-->

# Preserve confirmed release identities

## Status

Superseded by [manual publication](publish-manually-with-gleam.md).

## Context

A successful GitHub release creation returns a release ID.
Later discovery can omit the draft or select another resource.

## Decision

Discover once, create after confirmed absence, and preserve the validated ID through uploads and final publication.
Permit recovery with an explicit draft ID after canonical readback.

## Alternatives

Repeated collection discovery could replace the confirmed identity.

## Consequences

The custom controller needed identity validation and recovery across publication phases.
The successor removes those phases and the controller.

## Confirmation

Native HTTP fixtures checked the client protocol.
Source-bound Kani checks covered acquisition identity and operation counts under supplied results.
The successor defines verification after removal.
