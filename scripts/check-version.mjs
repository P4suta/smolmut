// SPDX-FileCopyrightText: 2026 smolmut contributors
// SPDX-License-Identifier: MIT OR Apache-2.0

import childProcess from "node:child_process";
import fs from "node:fs";

const gleamToml = fs.readFileSync("gleam.toml", "utf8");
const match = gleamToml.match(/^version\s*=\s*"([^"]+)"/m);
if (!match) throw new Error("gleam.toml package version is missing");
const version = match[1];
if (!/^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?$/.test(version)) {
	throw new Error(`gleam.toml has an invalid semantic version: ${version}`);
}

const expectations = [
	["src/smolmut/version.gleam", `pub const current = "${version}"`],
	["docs/usage.md", `The current package version is ${version}.`],
	["SECURITY.md", `The current package version is ${version}.`],
];
for (const [file, expected] of expectations) {
	if (!fs.readFileSync(file, "utf8").includes(expected)) {
		throw new Error(
			`${file} version drift: expected ${JSON.stringify(expected)}`,
		);
	}
}

const cli = childProcess.spawnSync(
	"gleam",
	["run", "-m", "smolmut", "--target", "erlang", "--", "--version"],
	{ encoding: "utf8", shell: false },
);
if (cli.error) throw cli.error;
if (cli.status !== 0 || cli.stdout.trim() !== `smolmut ${version}`) {
	throw new Error(`CLI version drift: ${cli.stdout}${cli.stderr}`);
}
console.log(`Version ${version} matches gleam.toml, source, and CLI output`);
