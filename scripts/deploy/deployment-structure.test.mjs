import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const repositoryRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');

const expectedFiles = {
  workflow: '.github/workflows/deploy.yml',
  module: 'scripts/deploy/windows/EunsungDeployment.psm1',
  testRunner: 'scripts/deploy/windows/Test-EunsungDeployment.ps1',
  deployRelease: 'scripts/deploy/windows/Deploy-EunsungRelease.ps1',
  initializeServer: 'scripts/deploy/windows/Initialize-EunsungDeployServer.ps1',
  pesterTests: 'scripts/deploy/windows/tests/Deployment.Tests.ps1',
};

function readRepositoryFile(relativePath) {
  try {
    return readFileSync(path.join(repositoryRoot, relativePath), 'utf8').replaceAll('\r\n', '\n');
  } catch (error) {
    if (error?.code === 'ENOENT') return '';
    throw error;
  }
}

function loadEcosystemConfig(environment) {
  const env = { ...process.env };
  delete env.EUNSUNG_RELEASE_DIR;
  delete env.EUNSUNG_DEPLOY_ROOT;
  delete env.ORACLE_CLIENT_LIB_DIR;
  Object.assign(env, environment);

  return spawnSync(
    process.execPath,
    [
      '-e',
      "const path = require('node:path'); path.isAbsolute = path.win32.isAbsolute; path.normalize = path.win32.normalize; path.join = path.win32.join; process.stdout.write(JSON.stringify(require(process.argv[1])));",
      path.join(repositoryRoot, 'ecosystem.config.js'),
    ],
    { encoding: 'utf8', env },
  );
}

function portablePath(value) {
  return value.replaceAll('\\', '/');
}

const sources = Object.fromEntries(
  Object.entries(expectedFiles).map(([name, relativePath]) => [name, readRepositoryFile(relativePath)]),
);
const runtime = [sources.module, sources.testRunner, sources.deployRelease, sources.initializeServer].join('\n');

function topLevelSection(yaml, key) {
  const lines = yaml.split('\n');
  const start = lines.findIndex((line) => new RegExp(`^['"]?${key}['"]?:\\s*(?:#.*)?$`).test(line));
  if (start < 0) return '';
  const endOffset = lines.slice(start + 1).findIndex((line) => /^['"]?[A-Za-z_][\w-]*['"]?:\s*(?:#.*)?$/.test(line));
  return lines.slice(start + 1, endOffset < 0 ? undefined : start + 1 + endOffset).join('\n');
}

function withoutCommentLines(source) {
  return source
    .split('\n')
    .filter((line) => !/^\s*#/.test(line))
    .map((line) => line.replace(/\s+#.*$/, ''))
    .join('\n');
}

function indentedSection(source, keyPattern, indentation) {
  const lines = source.split('\n');
  const heading = new RegExp(`^\\s{${indentation}}(?:${keyPattern}):\\s*$`);
  const start = lines.findIndex((line) => heading.test(line));
  if (start < 0) return '';
  const endOffset = lines.slice(start + 1).findIndex((line) => {
    if (!line.trim()) return false;
    return (line.match(/^\s*/)?.[0].length ?? 0) <= indentation;
  });
  return lines.slice(start + 1, endOffset < 0 ? undefined : start + 1 + endOffset).join('\n');
}

test('declares every protected deployment entry point', () => {
  for (const [name, relativePath] of Object.entries(expectedFiles)) {
    assert.notEqual(sources[name], '', `missing protected deployment file: ${relativePath}`);
  }
});

test('PM2 config defines the two release apps and fails closed without deployment paths', () => {
  const releaseDir = 'D:\\Eunsung\\releases\\0123456789abcdef';
  const deployRoot = 'D:\\Eunsung';
  const oracleClientLibDir = 'D:\\Oracle\\instantclient_19_25';
  const loaded = loadEcosystemConfig({
    EUNSUNG_RELEASE_DIR: releaseDir,
    EUNSUNG_DEPLOY_ROOT: deployRoot,
    ORACLE_CLIENT_LIB_DIR: oracleClientLibDir,
  });

  assert.equal(loaded.status, 0, loaded.stderr);
  const config = JSON.parse(loaded.stdout);
  assert.equal(config.apps.length, 2);

  const [frontend, backend] = config.apps;
  assert.equal(frontend.name, 'eunsung-frontend');
  assert.equal(portablePath(frontend.cwd), 'D:/Eunsung/releases/0123456789abcdef/apps/frontend');
  assert.equal(portablePath(frontend.script), 'D:/Eunsung/releases/0123456789abcdef/apps/frontend/node_modules/next/dist/bin/next');
  assert.equal(frontend.args, 'start -H 0.0.0.0 -p 3100');
  assert.equal(frontend.env.NODE_ENV, 'production');
  assert.equal(frontend.env.TZ, 'Asia/Seoul');
  assert.equal(portablePath(frontend.error_file), 'D:/Eunsung/logs/eunsung-frontend-error.log');
  assert.equal(portablePath(frontend.out_file), 'D:/Eunsung/logs/eunsung-frontend-out.log');

  assert.equal(backend.name, 'eunsung-backend');
  assert.equal(portablePath(backend.cwd), 'D:/Eunsung/releases/0123456789abcdef/apps/backend');
  assert.equal(portablePath(backend.script), 'D:/Eunsung/releases/0123456789abcdef/apps/backend/dist/main.js');
  assert.equal(backend.interpreter, 'node');
  assert.deepEqual(backend.env, {
    NODE_ENV: 'production',
    TZ: 'Asia/Seoul',
    ORACLE_CLIENT_LIB_DIR: oracleClientLibDir,
  });
  assert.equal(portablePath(backend.error_file), 'D:/Eunsung/logs/eunsung-backend-error.log');
  assert.equal(portablePath(backend.out_file), 'D:/Eunsung/logs/eunsung-backend-out.log');

  for (const app of config.apps) {
    assert.equal(app.watch, false);
    assert.equal(app.min_uptime, '10s');
    assert.equal(app.max_restarts, 5);
    assert.equal(app.restart_delay, 4000);
    assert.equal(app.exp_backoff_restart_delay, 1000);
    assert.equal(app.kill_timeout, 5000);
    assert.equal(app.log_date_format, 'YYYY-MM-DD HH:mm:ss');
    assert.equal(app.max_memory_restart, '1G');
  }

  const invalidEnvironments = [
    [{ EUNSUNG_DEPLOY_ROOT: deployRoot, ORACLE_CLIENT_LIB_DIR: oracleClientLibDir }, /EUNSUNG_RELEASE_DIR is required/],
    [{ EUNSUNG_RELEASE_DIR: 'releases\\relative', EUNSUNG_DEPLOY_ROOT: deployRoot, ORACLE_CLIENT_LIB_DIR: oracleClientLibDir }, /EUNSUNG_RELEASE_DIR must be an absolute path/],
    [{ EUNSUNG_RELEASE_DIR: releaseDir, ORACLE_CLIENT_LIB_DIR: oracleClientLibDir }, /EUNSUNG_DEPLOY_ROOT is required/],
    [{ EUNSUNG_RELEASE_DIR: releaseDir, EUNSUNG_DEPLOY_ROOT: 'deploy-root', ORACLE_CLIENT_LIB_DIR: oracleClientLibDir }, /EUNSUNG_DEPLOY_ROOT must be an absolute path/],
    [{ EUNSUNG_RELEASE_DIR: releaseDir, EUNSUNG_DEPLOY_ROOT: deployRoot }, /ORACLE_CLIENT_LIB_DIR is required/],
    [{ EUNSUNG_RELEASE_DIR: releaseDir, EUNSUNG_DEPLOY_ROOT: deployRoot, ORACLE_CLIENT_LIB_DIR: '   ' }, /ORACLE_CLIENT_LIB_DIR is required/],
    [{ EUNSUNG_RELEASE_DIR: releaseDir, EUNSUNG_DEPLOY_ROOT: deployRoot, ORACLE_CLIENT_LIB_DIR: 'oracle\\relative' }, /ORACLE_CLIENT_LIB_DIR must be an absolute path/],
  ];

  for (const [environment, expectedError] of invalidEnvironments) {
    const failed = loadEcosystemConfig(environment);
    assert.notEqual(failed.status, 0, `ecosystem config unexpectedly loaded with ${JSON.stringify(environment)}`);
    assert.match(failed.stderr, expectedError);
  }
});

test('workflow exposes only the approved triggers and deployment boundary', () => {
  const workflow = sources.workflow;
  const permissions = topLevelSection(workflow, 'permissions')
    .split('\n')
    .map((line) => line.replace(/\s+#.*$/, '').trim())
    .filter(Boolean);
  assert.deepEqual(permissions, ['contents: read'], 'top-level permissions must contain only contents: read');
  assert.match(workflow, /^\s*environment:\s*jisung-development\s*$/m, 'deploy job must use the jisung-development environment');

  const triggers = topLevelSection(workflow, 'on');
  const triggerKeys = [...triggers.matchAll(/^\s{2}['"]?([A-Za-z_][\w-]*)['"]?:/gm)].map((match) => match[1]);
  assert.deepEqual(triggerKeys.sort(), ['push', 'workflow_dispatch'].sort(), 'workflow triggers must be exactly push and workflow_dispatch');
  assert.match(triggers, /^\s{4}branches:\s*(?:\[\s*['"]?main['"]?\s*\]|\n\s{6}-\s*['"]?main['"]?\s*)$/m, 'push must be limited to main');

  const concurrency = topLevelSection(workflow, 'concurrency');
  assert.match(concurrency, /^\s{2}group:\s*\S+/m, 'deployment concurrency group is required');
  assert.match(concurrency, /^\s{2}cancel-in-progress:\s*(?:true|false)\s*$/m, 'deployment concurrency policy must be explicit');
});

test('workflow pins the exact commit and uses hardened key-only SSH', () => {
  const workflow = sources.workflow;
  const executableWorkflow = withoutCommentLines(workflow);
  assert.match(workflow, /GITHUB_SHA\s*:\s*['"]?\$\{\{\s*github\.sha\s*\}\}['"]?/i, 'workflow must propagate github.sha as GITHUB_SHA');
  assert.match(executableWorkflow, /(?:git\s+archive|archive\b)[\s\S]{0,300}GITHUB_SHA/i, 'the archive must be built from GITHUB_SHA');
  assert.match(executableWorkflow, /(?:ssh|scp)[\s\S]{0,500}(?:Deploy-EunsungRelease|-CommitSha)[\s\S]{0,200}GITHUB_SHA|(?:Deploy-EunsungRelease|-CommitSha)[\s\S]{0,200}GITHUB_SHA[\s\S]{0,500}(?:ssh|scp)/i, 'the remote deploy invocation must receive the same GITHUB_SHA');
  assert.match(executableWorkflow, /StrictHostKeyChecking\s*=\s*yes/i, 'SSH host key checking must be mandatory');
  assert.doesNotMatch(executableWorkflow, /\bsshpass\b|PasswordAuthentication\s*=\s*(?:yes|true)|(?:secrets|env)\.[A-Z0-9_]*(?:PASSWORD|PASSWD|_PASS)(?:\b|_)|\$env:[A-Z0-9_]*(?:PASSWORD|PASSWD|_PASS)\b|^\s*[A-Z0-9_]*(?:PASSWORD|PASSWD|_PASS)\s*:/im, 'password authentication and password-like workflow variables are forbidden');
  assert.doesNotMatch(executableWorkflow, /reset\s+--hard/i, 'destructive git reset is forbidden');
});

test('workflow keeps recovery modes manual and makes push a normal deployment', () => {
  const workflow = sources.workflow;
  const triggers = topLevelSection(workflow, 'on');
  const modeBlock = indentedSection(triggers, 'mode|deploy_mode', 6);
  const choices = [...modeBlock.matchAll(/^\s{10}-\s*['"]?([a-z_]+)['"]?\s*$/gm)].map((match) => match[1]);
  assert.deepEqual(choices.sort(), ['activate_existing', 'build_only', 'deploy', 'rollback_test'].sort(), 'workflow_dispatch mode choices must be exactly the four approved modes');

  const executableWorkflow = withoutCommentLines(workflow);
  assert.match(executableWorkflow, /(?:github\.event_name\s*==\s*['"]push['"]\s*&&\s*['"]deploy['"]\s*\|\|\s*(?:inputs|github\.event\.inputs)\.(?:mode|deploy_mode)|github\.event_name\s*==\s*['"]workflow_dispatch['"]\s*&&\s*(?:inputs|github\.event\.inputs)\.(?:mode|deploy_mode)\s*\|\|\s*['"]deploy['"])/i, 'push must force deploy before manual mode is considered');
  assert.doesNotMatch(executableWorkflow, /github\.event_name\s*==\s*['"]push['"]\s*&&\s*(?:inputs|github\.event\.inputs)\.(?:mode|deploy_mode)/i, 'push must never interpolate a manual deployment mode');
});

test('Windows deployment validates immutable release inputs and never deploys a tracked worktree', () => {
  const fullShaPattern = String.raw`\^\[(?=[^\]\n]*0-9)(?=[^\]\n]*a-f)[0-9a-fA-F-]+\]\{40\}\$`;
  assert.match(runtime, new RegExp(`(?:CommitSha|DeploySha|GITHUB_SHA)[^\\n]*(?:-notmatch|-notlike|match)[^\\n]*${fullShaPattern}|${fullShaPattern}[^\\n]*(?:CommitSha|DeploySha|GITHUB_SHA)`, 'im'), 'the deploy SHA variable must be validated as a full 40-character commit SHA');
  assert.match(runtime, /ReleaseRoot/i, 'a dedicated release root is required');
  assert.match(runtime, /(?:Resolve-Path|GetFullPath)[\s\S]{0,500}(?:StartsWith|ReleaseRoot)/i, 'release paths must be validated as descendants of the release root');
  assert.doesNotMatch(runtime, /git\s+(?:reset|pull|checkout|switch)\b/i, 'deployment must not mutate a tracked git worktree');
  assert.match(runtime, /(?:releases|release)[\\/][\s\S]{0,300}(?:GITHUB_SHA|CommitSha|Sha)|(?:GITHUB_SHA|CommitSha|Sha)[\s\S]{0,300}(?:releases|release)/i, 'artifacts must be deployed into a SHA-specific release directory');
});

test('Windows deployment fails closed on PowerShell and native command errors', () => {
  assert.match(runtime, /\$ErrorActionPreference\s*=\s*['"]Stop['"]/i, 'PowerShell errors must terminate deployment');
  assert.match(runtime, /\$LASTEXITCODE/i, 'native process exit codes must be inspected');
  assert.match(runtime, /\$(?:LASTEXITCODE|exitCode)[\s\S]{0,240}(?:throw|exit\s+1)/i, 'a non-zero native exit must stop deployment');
});

test('release activation manages both PM2 applications and verifies backend readiness', () => {
  const executableRuntime = withoutCommentLines(runtime);
  assert.match(executableRuntime, /(?:pm2[\s\S]{0,500}(?:start|reload|restart)[\s\S]{0,500}eunsung-frontend|eunsung-frontend[\s\S]{0,500}pm2[\s\S]{0,500}(?:start|reload|restart))/i, 'activation must start or reload eunsung-frontend with PM2');
  assert.match(executableRuntime, /(?:pm2[\s\S]{0,500}(?:start|reload|restart)[\s\S]{0,500}eunsung-backend|eunsung-backend[\s\S]{0,500}pm2[\s\S]{0,500}(?:start|reload|restart))/i, 'activation must start or reload eunsung-backend with PM2');
  assert.match(runtime, /status[\s\S]{0,200}(?:['"]ok['"]|[-_]eq\s*['"]ok['"])/i, 'backend health JSON must report status ok');
  assert.match(runtime, /database[\s\S]{0,200}(?:['"]connected['"]|[-_]eq\s*['"]connected['"])/i, 'backend health JSON must report database connected');
  assert.match(runtime, /(?:MaxAttempts|RetryCount|HealthRetries|for\s*\([^;]+;[^;]*(?:-lt|-le)\s*\$?\w+;)/i, 'health checks must use a bounded retry count');
  assert.match(executableRuntime, /function\s+Restore-EunsungPriorState\b/i, 'the runtime must define prior-state restoration');
  assert.match(executableRuntime, /(?:rollbackHealth|restoredHealth)[\s\S]{0,500}(?:SaveState|\$save)/i, 'restored state must pass health before it is saved');
});

test('dependency-free PowerShell contract tests cover and execute deployment safety invariants', () => {
  const contractTests = sources.pesterTests;
  assert.match(contractTests, /Describe\s+['"].*(?:deployment|release)/i, 'deployment contract suite description is required');
  assert.match(contractTests, /rollback/i, 'contract suite must cover rollback');
  assert.match(contractTests, /(?:40|full).*(?:sha|commit)|(?:sha|commit).*40/i, 'contract suite must cover full SHA validation');
  assert.doesNotMatch(contractTests, /Import-Module\s+(?:Pester|['"]Pester['"])/i, 'deployment tests must not depend on Pester');

  const result = spawnSync(
    'powershell.exe',
    ['-NoProfile', '-NonInteractive', '-File', path.join(repositoryRoot, expectedFiles.pesterTests)],
    { encoding: 'utf8', cwd: repositoryRoot, timeout: 60_000 },
  );
  assert.equal(result.status, 0, `${result.stdout}\n${result.stderr}`);
  assert.match(result.stdout, /RESULT\s+passed=26\s+failed=0/i, 'all isolated deployment contracts must pass');
});
