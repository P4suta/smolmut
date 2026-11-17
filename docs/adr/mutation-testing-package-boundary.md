---
date: 2026-10-29
---

<!--
SPDX-FileCopyrightText: 2026 gleam_mutants contributors
SPDX-License-Identifier: MIT OR Apache-2.0
-->

# Mutation-testing package boundary

## Status

Accepted.

## Context

Mutation testing measures whether existing tests detect controlled source changes.
Library callers need typed results without terminal output or host termination.
A test framework, automatic test generation, and editor integration introduce separate product contracts.

## Decision

Provide the CLI, `smolmut/api`, and `smolmut/types` over one engine and canonical domain types.
Keep other modules internal.
Preserve the 15 operators, compiler validation, snapshots, workers, cache, conservative test selection, scoring, and report formats.
Return errors and captured child output through the API.
Require an explicit library option for report persistence.
Keep rendering, annotations, and process exit in the CLI.

Remove Smartest, test generation, generation schemas, and the VS Code extension.
Keep source-derived proofs and native verification as development infrastructure.

## Alternatives

Keeping the combined framework would preserve unrelated product contracts.
Providing a CLI alone would prevent typed embedding.

## Consequences

Consumers share the engine and follow the [migration guide](../migration.md) for removed features.
Publication follows the [manual publication decision](publish-manually-with-gleam.md).

## Confirmation

The [verification contracts](../verification.md) define source proofs, native tests, and trust boundaries.
Reconsider the scope when a separate product need justifies another public contract.
