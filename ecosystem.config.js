const path = require("path");

function requireAbsolutePath(variableName) {
  const value = process.env[variableName];

  if (!value) {
    throw new Error(`${variableName} is required`);
  }

  if (!path.isAbsolute(value)) {
    throw new Error(`${variableName} must be an absolute path: ${value}`);
  }

  return path.normalize(value);
}

const releaseDir = requireAbsolutePath("EUNSUNG_RELEASE_DIR");
const deployRoot = requireAbsolutePath("EUNSUNG_DEPLOY_ROOT");
const oracleClientLibDir = process.env.ORACLE_CLIENT_LIB_DIR;

if (!oracleClientLibDir) {
  throw new Error("ORACLE_CLIENT_LIB_DIR is required");
}

const frontendDir = path.join(releaseDir, "apps", "frontend");
const backendDir = path.join(releaseDir, "apps", "backend");
const logsDir = path.join(deployRoot, "logs");

const restartPolicy = {
  watch: false,
  min_uptime: "10s",
  max_restarts: 5,
  restart_delay: 4000,
  exp_backoff_restart_delay: 1000,
  kill_timeout: 5000,
  log_date_format: "YYYY-MM-DD HH:mm:ss",
};

module.exports = {
  apps: [
    {
      ...restartPolicy,
      name: "eunsung-frontend",
      cwd: frontendDir,
      script: path.join(frontendDir, "node_modules", "next", "dist", "bin", "next"),
      args: "start -H 0.0.0.0 -p 3100",
      env: {
        NODE_ENV: "production",
        TZ: "Asia/Seoul",
      },
      max_memory_restart: "1G",
      error_file: path.join(logsDir, "eunsung-frontend-error.log"),
      out_file: path.join(logsDir, "eunsung-frontend-out.log"),
    },
    {
      ...restartPolicy,
      name: "eunsung-backend",
      cwd: backendDir,
      script: path.join(backendDir, "dist", "main.js"),
      interpreter: "node",
      env: {
        NODE_ENV: "production",
        TZ: "Asia/Seoul",
        ORACLE_CLIENT_LIB_DIR: oracleClientLibDir,
      },
      max_memory_restart: "1G",
      error_file: path.join(logsDir, "eunsung-backend-error.log"),
      out_file: path.join(logsDir, "eunsung-backend-out.log"),
    },
  ],
};
