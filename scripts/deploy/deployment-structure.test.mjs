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
  prepareIncoming: 'scripts/deploy/windows/Prepare-EunsungIncoming.ps1',
  initializeServer: 'scripts/deploy/windows/Initialize-EunsungDeployServer.ps1',
  pesterTests: 'scripts/deploy/windows/tests/Deployment.Tests.ps1',
  bootstrapTests: 'scripts/deploy/windows/tests/Bootstrap.Tests.ps1',
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
const runtime = [sources.module, sources.testRunner, sources.deployRelease, sources.prepareIncoming, sources.initializeServer].join('\n');

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

test('workflow uses a fixed GitHub runner, pinned actions, and only environment-scoped SSH secrets', () => {
  const workflow = sources.workflow;
  assert.match(workflow, /^\s{4}runs-on:\s*ubuntu-24\.04\s*$/m, 'runner image must be fixed');
  const actionUses = [...workflow.matchAll(/^\s*-?\s*uses:\s*([^\s#]+).*$/gm)].map((match) => match[1]);
  assert.ok(actionUses.length > 0, 'at least checkout must be declared');
  for (const action of actionUses) {
    assert.match(action, /^[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+@[0-9a-f]{40}$/, `external action must be pinned to a full commit SHA: ${action}`);
  }
  const secretNames = [...workflow.matchAll(/secrets\.([A-Z0-9_]+)/g)].map((match) => match[1]);
  assert.deepEqual([...new Set(secretNames)].sort(), [
    'DEPLOY_HOST', 'DEPLOY_PORT', 'DEPLOY_SSH_HOST_KEY', 'DEPLOY_SSH_KEY', 'DEPLOY_USER',
  ], 'workflow must reference only the approved environment secrets');
  const jobEnvironment = indentedSection(workflow, 'env', 4);
  assert.doesNotMatch(jobEnvironment, /DEPLOY_SSH_(?:KEY|HOST_KEY)/, 'private key and host key must not be job-wide environment variables');
  assert.doesNotMatch(workflow, /actions\/upload-artifact|artifact\s+upload/i, 'deployment diagnostics must not upload artifacts');
});

test('workflow validates exact SHAs and preserves manual activation semantics', () => {
  const workflow = withoutCommentLines(sources.workflow);
  assert.match(workflow, /\^\[0-9a-f\]\{40\}\$/i, 'workflow must validate a lowercase 40-character SHA');
  assert.match(workflow, /git\s+merge-base\s+--is-ancestor[\s\S]{0,160}(?:origin\/main|refs\/remotes\/origin\/main)/i, 'rollback target must be an ancestor of origin/main');
  assert.match(workflow, /git\s+archive\s+--format=zip[\s\S]{0,160}GITHUB_SHA/i, 'new releases must use a ZIP made from the triggering SHA');
  assert.match(workflow, /build_only\)[^\n]*-ArchivePath[^\n]*-BuildOnly/i, 'build_only must upload and build without activation');
  assert.match(workflow, /activate_existing\)[^\n]*-ActivateExisting/i, 'activate_existing must not request a rebuild');
  assert.match(workflow, /rollback_test\)[^\n]*-ActivateExisting\s+-InjectHealthFailure\s+-AllowFailureInjection/i, 'rollback_test must use guarded failure injection');
  assert.match(workflow, /deploy_status\s*==\s*30/i, 'rollback_test must accept only the successful-rollback exit code');
});

test('every remote call uses strict native SSH and a reviewed PowerShell file', () => {
  const workflow = withoutCommentLines(sources.workflow);
  for (const required of ['BatchMode=yes', 'StrictHostKeyChecking=yes', 'ConnectTimeout=15', 'ServerAliveInterval=15', 'ServerAliveCountMax=2']) {
    assert.match(workflow, new RegExp(required.replace('=', '\\s*=\\s*'), 'i'), `missing SSH hardening option: ${required}`);
  }
  assert.match(workflow, /REMOTE_INCOMING_ROOT_SCP[^\n]*\.deploy\/incoming/i, 'upload root must be the protected incoming directory');
  assert.match(workflow, /incoming_id="\$\{GITHUB_SHA\}-\$\{GITHUB_RUN_ID\}-\$\{GITHUB_RUN_ATTEMPT\}"/i, 'incoming directory must be unique to workflow source SHA and run identity');
  assert.match(workflow, /Prepare-EunsungIncoming\.ps1[^\n]*prepare-\$\{INCOMING_ID\}\.ps1[\s\S]{0,700}-IncomingId\s+\$\{INCOMING_ID\}/i, 'a reviewed preparation script must fail closed before payload upload');
  assert.match(workflow, /scp[^\n]*eunsung-incoming\/\$INCOMING_ID\/\.[^\n]*REMOTE_INCOMING_ROOT_SCP[^\n]*INCOMING_ID/i, 'payload upload must target only the newly prepared unique directory');
  assert.match(workflow, /powershell\.exe\s+-NoProfile\s+-NonInteractive\s+-ExecutionPolicy\s+Bypass\s+-File\s+[^\n]*Deploy-EunsungRelease\.ps1/i, 'remote deployment must invoke the reviewed script with -File');
  assert.doesNotMatch(workflow, /powershell(?:\.exe)?[^\n]*(?:-Command|-EncodedCommand)\b/i, 'remote inline PowerShell is forbidden');
  assert.match(workflow, /-CleanupIncoming/i, 'remote script must clean only its validated incoming directory in finally');
  assert.match(sources.deployRelease, /GetOwner\(\[Security\.Principal\.SecurityIdentifier\]\)[\s\S]{0,1800}GetAccessRules/i, 'incoming execution must validate owner and write ACLs before importing deployment code');
  assert.match(sources.deployRelease, /finally\s*\{[\s\S]{0,900}Remove-Item\s+-LiteralPath\s+\$cleanupPath/i, 'incoming cleanup must be literal-path and finally-guarded');
  assert.match(sources.prepareIncoming, /Test-Path\s+-LiteralPath\s+\$target[\s\S]{0,120}already exists[\s\S]{0,180}New-Item[^\n]*\$target/i, 'stale incoming targets must fail before directory creation or upload');
  assert.match(workflow, /if:\s*\$\{\{\s*always\(\)\s*&&\s*steps\.incoming\.outputs\.prepared\s*==\s*['"]true['"]\s*\}\}[\s\S]{0,1800}-Action\s+Cleanup/i, 'prepared incoming directories must be cleaned even after upload or deployment failure');
  assert.match(sources.prepareIncoming, /GetOwner\(\[Security\.Principal\.SecurityIdentifier\]\)[\s\S]{0,1600}Remove-Item\s+-LiteralPath\s+\$target/i, 'cleanup must validate ownership and remove only the exact target');
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
  assert.match(result.stdout, /RESULT\s+passed=39\s+failed=0/i, 'all isolated deployment contracts must pass');
});

test('bootstrap is least privilege, idempotent, pinned, and reversible', () => {
  const bootstrap = withoutCommentLines(sources.initializeServer);
  assert.match(bootstrap, /Get-LocalUser[\s\S]{0,240}New-LocalUser/i, 'account creation must be existence guarded');
  assert.doesNotMatch(bootstrap, /Add-LocalGroupMember|net\s+localgroup\s+administrators/i, 'deployment account must never be added to Administrators');
  assert.match(bootstrap, /Get-LocalGroupMember[\s\S]{0,240}(?:throw|must not)/i, 'administrator membership must fail closed');
  assert.match(bootstrap, /SetAccessRuleProtection\(\$true,\s*\$false\)/i, 'deployment ACL must not inherit broader parent permissions');
  assert.match(bootstrap, /['"]Modify['"][\s\S]{0,300}DeploySid|DeploySid[\s\S]{0,300}['"]Modify['"]/i, 'deploy account must receive scoped Modify access');
  assert.match(bootstrap, /authorized_keys/i, 'the supplied public key must be registered');
  assert.match(bootstrap, /Assert-EunsungReadExecuteAccess[\s\S]{0,500}(?:NodePath|OracleClientLibDir)|(?:NodePath|OracleClientLibDir)[\s\S]{0,500}Assert-EunsungReadExecuteAccess/i, 'Node and Oracle access must be checked for the deployment account');
  assert.match(bootstrap, /pnpm@\$?\(?\$?\w+|pnpm@10\.28\.1/i, 'pnpm must be installed at the pinned version');
  assert.match(bootstrap, /pm2@\$?\(?\$?\w+|pm2@6\.0\.6/i, 'PM2 must be installed at the pinned version');
  assert.match(bootstrap, /node_modules\\pm2\\package\.json[\s\S]{0,500}\.version/i, 'PM2 version must be read without starting an administrator PM2 daemon');
  assert.doesNotMatch(bootstrap, /&\s*\$pm2Path\s+--version/i, 'bootstrap must not start PM2 under the administrator profile for version discovery');
  assert.match(bootstrap, /EunsungMES-PM2-Resurrect/g, 'the exact scheduled task name is required');
  assert.match(bootstrap, /New-ScheduledTaskTrigger\s+-AtStartup/i, 'the task must run at startup');
  assert.match(bootstrap, /New-ScheduledTaskPrincipal[\s\S]{0,200}-LogonType\s+S4U[\s\S]{0,100}-RunLevel\s+Limited/i, 'the task principal must be S4U and limited');
  assert.match(bootstrap, /Get-ScheduledTask[\s\S]{0,300}Register-ScheduledTask/i, 'task registration must be existence guarded');
  assert.match(bootstrap, /Start-ScheduledTask[\s\S]{0,1800}Stop-ScheduledTask/i, 'task verification must start and stop without rebooting');
  assert.match(bootstrap, /pm2[^\n]*resurrect[\s\S]{0,160}\$LASTEXITCODE/i, 'the wrapper must check the PM2 exit code');
  assert.match(bootstrap, /Invoke-EunsungBootstrapRollback[\s\S]{0,700}Unregister-ScheduledTask[\s\S]{0,700}Remove-Item/i, 'rollback must unregister the exact task and remove the wrapper');
  assert.doesNotMatch(bootstrap, /Restart-Computer|Stop-Computer|shutdown(?:\.exe)?\b/i, 'bootstrap must never reboot or shut down the server');
  assert.doesNotMatch(bootstrap, /ConvertTo-SecureString\s+['"][^'"]+['"]\s+-AsPlainText|Password\s*=\s*['"][^'"]+['"]/i, 'hard-coded credentials are forbidden');

  const result = spawnSync(
    'powershell.exe',
    ['-NoProfile', '-NonInteractive', '-File', path.join(repositoryRoot, expectedFiles.bootstrapTests)],
    { encoding: 'utf8', cwd: repositoryRoot, timeout: 60_000 },
  );
  assert.equal(result.status, 0, `${result.stdout}\n${result.stderr}`);
  assert.match(result.stdout, /RESULT\s+passed=8\s+failed=0/i, 'all isolated bootstrap contracts must pass');
});
