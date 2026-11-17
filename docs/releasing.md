<!--
SPDX-FileCopyrightText: 2026 smolmut contributors
SPDX-License-Identifier: MIT OR Apache-2.0
-->

# Manual publication

The repository uses the official Gleam publisher for Hex releases.
The [publication decision](adr/publish-manually-with-gleam.md) removes the custom release controller and automated distributions.

## Prepare a version

Update the version in `gleam.toml`, `src/smolmut/version.gleam`, `docs/usage.md`, and `SECURITY.md`.
Describe user-visible changes in `CHANGELOG.md`.
Run the maintained checks with the pinned toolchain:

```sh
mise run check
mise run test-matrix
mise run test-integration
```

Follow the checks in [Contributing](../CONTRIBUTING.md) when changing the mutation engine or source derivation.
Review the source and documentation before publication.

## Publish

From the reviewed checkout, run:

```sh
mise x -- gleam publish
```

Review the package details and respond to the publisher's prompts.
The official command performs Gleam's publication checks and publishes the package and documentation.
Use the authentication options documented by `mise x -- gleam publish --help`.

The repository has no npm or escript distribution process.
Published versions and GitHub releases remain available as historical artifacts.
