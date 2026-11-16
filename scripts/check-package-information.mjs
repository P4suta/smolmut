// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

import childProcess from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const root = process.cwd();
const temporary = fs.mkdtempSync(
	path.join(os.tmpdir(), "smolmut-package-information-"),
);
const output = path.join(temporary, "package-information.json");

try {
	const result = childProcess.spawnSync(
		"gleam",
		["export", "package-information", "--out", output],
		{ cwd: root, encoding: "utf8", shell: false },
	);
	if (result.error) throw result.error;
	if (result.status !== 0) throw new Error(`${result.stdout}${result.stderr}`);

	const metadata = JSON.parse(fs.readFileSync(output, "utf8"))["gleam.toml"];
	if (!metadata)
		throw new Error("package-information has no gleam.toml metadata");
	const assertEqual = (actual, expected, label) => {
		if (JSON.stringify(actual) !== JSON.stringify(expected)) {
			throw new Error(`${label} drift: ${JSON.stringify(actual)}`);
		}
	};
	assertEqual(metadata.gleam, ">= 1.17.0 and < 2.0.0", "minimum Gleam version");
	assertEqual(
		metadata.internal_modules,
		[
			"smolmut/cache",
			"smolmut/capability",
			"smolmut/cli",
			"smolmut/config",
			"smolmut/core/*",
			"smolmut/engine",
			"smolmut/error",
			"smolmut/local_dependencies",
			"smolmut/mte_asset",
			"smolmut/pipeline",
			"smolmut/platform",
			"smolmut/project_report",
			"smolmut/report",
			"smolmut/runtime",
			"smolmut/snapshot",
			"smolmut/stryker_html",
			"smolmut/stryker_report",
			"smolmut/test_impact",
			"smolmut/version",
			"smolmut/workspace_lock",
		],
		"internal modules",
	);
	assertEqual(
		(metadata.documentation?.pages || []).map((page) => page.path),
		[
			"library.html",
			"configuration.html",
			"operators.html",
			"architecture.html",
			"migration.html",
		],
		"documentation pages",
	);
	console.log(
		"package-information matches the compiler, internal-module, and documentation contracts",
	);
} finally {
	fs.rmSync(temporary, { recursive: true, force: true });
}
