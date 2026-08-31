import assert from 'node:assert/strict';
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

const sources = Object.fromEntries(
  Object.entries(expectedFiles).map(([name, relativePath]) => [name, readRepositoryFile(relativePath)]),
);
const runtime = [sources.module, sources.testRunner, sources.deployRelease, sources.initializeServer].join('\n');

function topLevelSection(yaml, key) {
  const match = yaml.match(new RegExp(`^${key}:\\s*\\n([\\s\\S]*?)(?=^[A-Za-z_][\\w-]*:\\s*(?:#.*)?$|\\Z)`, 'm'));
  return match?.[1] ?? '';
}

test('declares every protected deployment entry point', () => {
  for (const [name, relativePath] of Object.entries(expectedFiles)) {
    assert.notEqual(sources[name], '', `missing protected deployment file: ${relativePath}`);
  }
});

test('workflow exposes only the approved triggers and deployment boundary', () => {
  const workflow = sources.workflow;
  assert.match(workflow, /^permissions:\s*\n(?:[ \t]+.*\n)*?[ \t]+contents:\s*read\s*$/m, 'workflow must grant only read access to repository contents');
  assert.match(workflow, /^\s*environment:\s*jisung-development\s*$/m, 'deploy job must use the jisung-development environment');

  const triggers = topLevelSection(workflow, 'on');
  assert.match(triggers, /^\s{2}push:\s*$/m, 'push trigger is required');
  assert.match(triggers, /^\s{4}branches:\s*(?:\[\s*['"]?main['"]?\s*\]|\n\s{6}-\s*['"]?main['"]?\s*)$/m, 'push must be limited to main');
  assert.match(triggers, /^\s{2}workflow_dispatch:\s*$/m, 'manual workflow_dispatch trigger is required');
  assert.doesNotMatch(triggers, /^\s{2}(?:pull_request|schedule|workflow_call):/m, 'no additional deployment trigger is allowed');

  const concurrency = topLevelSection(workflow, 'concurrency');
  assert.match(concurrency, /^\s{2}group:\s*\S+/m, 'deployment concurrency group is required');
  assert.match(concurrency, /^\s{2}cancel-in-progress:\s*(?:true|false)\s*$/m, 'deployment concurrency policy must be explicit');
});

test('workflow pins the exact commit and uses hardened key-only SSH', () => {
  const workflow = sources.workflow;
  assert.match(workflow, /GITHUB_SHA\s*:\s*['"]?\$\{\{\s*github\.sha\s*\}\}['"]?/i, 'workflow must propagate github.sha as GITHUB_SHA');
  assert.match(workflow, /StrictHostKeyChecking\s*=\s*yes/i, 'SSH host key checking must be mandatory');
  assert.doesNotMatch(workflow, /secrets\.[A-Z0-9_]*PASSWORD/i, 'password secrets are forbidden; use key authentication');
  assert.doesNotMatch(workflow, /reset\s+--hard/i, 'destructive git reset is forbidden');
});

test('workflow keeps recovery modes manual and makes push a normal deployment', () => {
  const workflow = sources.workflow;
  for (const mode of ['build_only', 'activate_existing', 'rollback_test']) {
    assert.match(workflow, new RegExp(`(?:^|[^\\w])${mode}(?:$|[^\\w])`, 'm'), `workflow_dispatch must offer ${mode}`);
  }
  assert.match(workflow, /github\.event_name\s*==\s*['"]push['"][\s\S]{0,240}(?:mode|deploy_mode)[^\n]*(?:normal|deploy)/i, 'push events must hard-code normal deployment mode');
  assert.doesNotMatch(workflow, /github\.event\.inputs[^\n]*(?:push|github\.event_name\s*==\s*['"]push)/i, 'push deployment must not consume a manual recovery mode');
});

test('Windows deployment validates immutable release inputs and never deploys a tracked worktree', () => {
  assert.match(runtime, /\^\[0-9a-fA-F\]\{40\}\$/m, 'remote deployment must validate a full 40-character commit SHA');
  assert.match(runtime, /ReleaseRoot/i, 'a dedicated release root is required');
  assert.match(runtime, /(?:Resolve-Path|GetFullPath)[\s\S]{0,500}(?:StartsWith|ReleaseRoot)/i, 'release paths must be validated as descendants of the release root');
  assert.doesNotMatch(runtime, /git\s+(?:reset|pull|checkout|switch)\b/i, 'deployment must not mutate a tracked git worktree');
  assert.match(runtime, /(?:releases|release)[\\/][\s\S]{0,300}(?:GITHUB_SHA|CommitSha|Sha)|(?:GITHUB_SHA|CommitSha|Sha)[\s\S]{0,300}(?:releases|release)/i, 'artifacts must be deployed into a SHA-specific release directory');
});

test('Windows deployment fails closed on PowerShell and native command errors', () => {
  assert.match(runtime, /\$ErrorActionPreference\s*=\s*['"]Stop['"]/i, 'PowerShell errors must terminate deployment');
  assert.match(runtime, /\$LASTEXITCODE/i, 'native process exit codes must be inspected');
  assert.match(runtime, /\$LASTEXITCODE[\s\S]{0,240}(?:throw|exit\s+1)/i, 'a non-zero native exit must stop deployment');
});

test('release activation manages both PM2 applications and verifies backend readiness', () => {
  assert.match(runtime, /eunsung-frontend/i, 'frontend PM2 application name is required');
  assert.match(runtime, /eunsung-backend/i, 'backend PM2 application name is required');
  assert.match(runtime, /status[\s\S]{0,200}(?:['"]ok['"]|[-_]eq\s*['"]ok['"])/i, 'backend health JSON must report status ok');
  assert.match(runtime, /database[\s\S]{0,200}(?:['"]connected['"]|[-_]eq\s*['"]connected['"])/i, 'backend health JSON must report database connected');
  assert.match(runtime, /(?:MaxAttempts|RetryCount|HealthRetries|for\s*\([^;]+;[^;]*(?:-lt|-le)\s*\$?\w+;)/i, 'health checks must use a bounded retry count');
  assert.match(runtime, /rollback/i, 'failed activation must invoke rollback');
});

test('PowerShell contract tests cover deployment safety invariants', () => {
  const pester = sources.pesterTests;
  assert.match(pester, /Describe\s+['"].*(?:deployment|release)/i, 'Pester deployment contract suite is required');
  assert.match(pester, /rollback/i, 'Pester suite must cover rollback');
  assert.match(pester, /(?:40|full).*(?:sha|commit)|(?:sha|commit).*40/i, 'Pester suite must cover full SHA validation');
});
