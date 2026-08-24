import { readFile } from 'node:fs/promises';
import { homedir } from 'node:os';
import { join } from 'node:path';
import { spawn } from 'node:child_process';

const DEFAULT_PROFILE = 'JSIDC2_ESDB';
const PROFILE_ALIASES = {
  JSIDC2_ESDB: 'EUNSUNG_DEV_ESDBPDB',
};

function requireString(profile, key, profileName) {
  const value = profile?.[key];
  if (typeof value !== 'string' || value.trim() === '') {
    throw new Error(`Oracle profile '${profileName}' is missing '${key}'.`);
  }
  return value;
}

async function loadProfile(requestedName) {
  const configPath = process.env.ORACLE_DB_CONFIG_PATH
    ?? join(homedir(), '.oracle_db_config.json');
  const config = JSON.parse(await readFile(configPath, 'utf8'));
  const profiles = config?.profiles ?? {};
  const resolvedName = profiles[requestedName]
    ? requestedName
    : PROFILE_ALIASES[requestedName];
  const profile = resolvedName ? profiles[resolvedName] : undefined;

  if (!profile) {
    throw new Error(
      `Oracle profile '${requestedName}' is not registered in ${configPath}.`,
    );
  }

  return { profile, resolvedName };
}

async function main() {
  const requestedName = process.env.ORACLE_DB_PROFILE ?? DEFAULT_PROFILE;
  const { profile, resolvedName } = await loadProfile(requestedName);
  const host = requireString(profile, 'host', resolvedName);
  const serviceName = requireString(profile, 'service_name', resolvedName);
  const user = requireString(profile, 'user', resolvedName);
  const password = requireString(profile, 'password', resolvedName);
  const port = String(profile.port ?? 1521);

  console.log(
    `[dev-db] ${requestedName} -> ${host}:${port}/${serviceName}`
      + (resolvedName === requestedName ? '' : ` (local profile: ${resolvedName})`),
  );

  if (process.argv.includes('--check')) return;

  const childEnv = {
    ...process.env,
    NODE_ENV: 'development',
    ORACLE_DB_PROFILE: requestedName,
    ORACLE_HOST: host,
    ORACLE_PORT: port,
    ORACLE_SERVICE_NAME: serviceName,
    ORACLE_USER: user,
    ORACLE_PASSWORD: password,
  };
  delete childEnv.ORACLE_SID;
  delete childEnv.ORACLE_CONNECT_STRING;

  const pnpmCommand = process.platform === 'win32' ? 'pnpm.cmd' : 'pnpm';
  const child = spawn(pnpmCommand, ['exec', 'nest', 'start', '--watch'], {
    cwd: process.cwd(),
    env: childEnv,
    stdio: 'inherit',
    shell: process.platform === 'win32',
  });

  for (const signal of ['SIGINT', 'SIGTERM']) {
    process.on(signal, () => child.kill(signal));
  }

  child.on('error', (error) => {
    console.error(`[dev-db] Failed to start backend: ${error.message}`);
    process.exitCode = 1;
  });
  child.on('exit', (code, signal) => {
    process.exitCode = signal ? 1 : (code ?? 1);
  });
}

main().catch((error) => {
  console.error(`[dev-db] ${error instanceof Error ? error.message : String(error)}`);
  process.exitCode = 1;
});
