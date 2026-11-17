---
date: 2026-10-30
---

<!--
SPDX-FileCopyrightText: 2026 gleam_mutants contributors
SPDX-License-Identifier: MIT OR Apache-2.0
-->

# Verify drafts before registry publication

## Status

Superseded by [manual publication](publish-manually-with-gleam.md).

## Context

GitHub hides draft releases from tokens without write access.
Registry publication jobs used read-only GitHub tokens.

## Decision

Create and verify draft assets in a GitHub write phase.
Registry jobs use the successful preparation job in their own controller run as evidence.
Finalization reads the draft and registry archives again.

## Alternatives

Giving registry jobs GitHub write access would combine separate capabilities.
Treating an invisible draft as absent would make discovery unsound.

## Consequences

The controller needed validated run identities, job selection, and phase permissions.
The successor removes that controller and uses manual publication.

## Confirmation

Native regressions checked the workflow and handoff.
Kani checked the pure phase dispatcher.
The successor defines verification after removal.
