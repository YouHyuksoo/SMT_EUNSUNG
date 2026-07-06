/**
 * @file ecosystem.config.js
 * @description
 * PM2 프로세스 관리 설정 파일
 * Windows 환경에서 Next.js 서버를 실행합니다.
 *
 * 초보자 가이드:
 * - 시작: pm2 start ecosystem.config.js
 * - 재시작: pm2 restart mes-display
 * - 중지: pm2 stop mes-display
 * - 로그: pm2 logs mes-display
 *
 * 주의: Oracle Instant Client가 시스템 PATH에 포함되어 있어야 합니다.
 */
const path = require("path");
const appDir = process.env.DEPLOY_DIR_WEBDISPLAY || __dirname;

// 운영 포트는 3100으로 고정.
const appPort = 3100;

module.exports = {
  apps: [
    {
      name: "mes-display",
      script: "node_modules/next/dist/bin/next",
      args: `start -H 0.0.0.0 -p ${appPort}`,
      cwd: appDir,
      env: {
        NODE_ENV: "production",
        PORT: appPort,
      },
      watch: false,
      max_memory_restart: "1G",
      error_file: path.join(appDir, "logs", "error.log"),
      out_file: path.join(appDir, "logs", "out.log"),
      log_date_format: "YYYY-MM-DD HH:mm:ss",
      // min_uptime 이전에 죽으면 unstable로 간주 — max_restarts 카운트에 잡힘
      // 빌드 산출물 손상 시 next start가 1~5초 살다 죽는 패턴이 있어 10초로 설정
      min_uptime: "10s",
      // unstable restart 5회 도달 시 PM2가 errored 상태로 정지 — 운영자가 즉시 알아챌 수 있음
      max_restarts: 5,
      // restart 사이 기본 지연 4초 (crash loop 폭주 방지)
      restart_delay: 4000,
      // 지수 백오프 1초부터 시작 (이전 100ms는 너무 빨라 누적 12000회 발생함)
      exp_backoff_restart_delay: 1000,
      // graceful shutdown 시간
      kill_timeout: 5000,
    },
  ],
};
