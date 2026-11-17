<!--
SPDX-FileCopyrightText: 2026 smolmut contributors
SPDX-License-Identifier: MIT OR Apache-2.0
-->

# Migration

## From gleam_mutants 0.1.0

The package and its modules are now named `smolmut`.
The `gleam_` prefix belongs to packages that the Gleam core team maintains, so `gleam_mutants` 0.1.0 is retired on Hex.
Operators, mutant identities, reports, and runtimes behave as they did in 0.1.0.

Remove the retired dependency:

```sh
gleam remove gleam_mutants
```

Add a source checkout of `smolmut` using the [installation instructions](usage.md#install).

Rename every `[tools.gleam_mutants]` table in `gleam.toml` to `[tools.smolmut]`, including nested tables such as `[tools.smolmut.policy]`.
smolmut reads only `tools.smolmut`, so a table left under the old name no longer configures a run.

Run the CLI as `gleam run -m smolmut -- run`.
Import the library from `smolmut/api` and `smolmut/types` instead of `gleam_mutants/api` and `gleam_mutants/types`.

Rename environment variables from the `GLEAM_MUTANTS_` prefix to `SMOLMUT_`.
A test-impact provider reads `SMOLMUT_ACTIVE`, `SMOLMUT_RUNTIME`, `SMOLMUT_TEST_IMPACT_FILE`, and `SMOLMUT_TEST_SELECTION_FILE`.

The native report schemas now use `https://smolmut.invalid/schema/` identifiers, and reports name the tool `smolmut`.
Update consumers that compare the schema `$id` or the `tool` field.

smolmut keeps its working state in `.smolmut/` and its shared cache under `smolmut/v1/workspaces` in the platform cache directory.
Delete the `.gleam_mutants/` directory and the old `gleam_mutants` cache directory after migrating.

## From the Smartest development builds

The supported product is the `smolmut/api` library and the `smolmut` CLI.
The command families are `run`, `list`, `doctor`, `init`, `report`, and `cache`.
The existing 15 operators, mutant identities, native JSON, Stryker JSON, offline HTML, and four execution runtimes remain part of that contract.

The Smartest test framework, property generators, differential test generation, and VS Code extension have been removed.
There are no compatibility modules for `smartest` or `gleam_mutants/pbt`.
The `suggest`, standalone `explain`, and `apply` commands and `run --suggest` are no longer accepted.
A `suggest` table under the tool configuration is rejected as an unknown configuration key.
Remove that table and generation-only flags from scripts and configuration.
The removed generation schemas and editor packaging are no longer distributed.

Keep the application's tests under its chosen runner, such as gleeunit.
Use `list --validate --explain` to inspect compiler-valid and rejected mutants.
Use `run --explain`, native JSON, or the offline HTML report to inspect mutation outcomes and improve tests.
The tool no longer writes application test modules.
Use the [library API](library.md) for integrations.

The optional test-impact protocol remains provider-independent.
An absent, invalid, or incomplete provider falls back to the full configured test suite.
No Smartest dependency or test-runner migration is required to run mutation testing.
Historical `.smartest` data is not migrated or deleted automatically.
Archive or remove it according to the application's own data policy.
