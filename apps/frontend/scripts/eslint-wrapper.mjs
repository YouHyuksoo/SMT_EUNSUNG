#!/usr/bin/env node
import { spawnSync } from "node:child_process";

const args = process.argv.slice(2);
const eslintArgs = [];

for (let i = 0; i < args.length; i += 1) {
  const arg = args[i];

  if (arg === "--file") {
    const file = args[i + 1];
    if (!file || file.startsWith("-")) {
      console.error("Missing path after --file");
      process.exit(2);
    }
    eslintArgs.push(file);
    i += 1;
    continue;
  }

  if (arg.startsWith("--file=")) {
    const file = arg.slice("--file=".length);
    if (!file) {
      console.error("Missing path after --file=");
      process.exit(2);
    }
    eslintArgs.push(file);
    continue;
  }

  eslintArgs.push(arg);
}

const result = spawnSync("eslint", eslintArgs, {
  stdio: "inherit",
  shell: process.platform === "win32",
});

if (result.error) {
  console.error(result.error.message);
  process.exit(1);
}

process.exit(result.status ?? 1);
