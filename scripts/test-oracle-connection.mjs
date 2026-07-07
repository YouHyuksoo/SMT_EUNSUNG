import 'dotenv/config';
import path from 'node:path';
import oracledb from 'oracledb';

const required = ['ORACLE_USER', 'ORACLE_PASSWORD'];

for (const key of required) {
  if (!process.env[key]) {
    console.error(`Missing required environment variable: ${key}`);
    process.exitCode = 1;
  }
}

if (process.exitCode) {
  process.exit();
}

if (process.env.TNS_ADMIN && !path.isAbsolute(process.env.TNS_ADMIN)) {
  process.env.TNS_ADMIN = path.resolve(process.env.TNS_ADMIN);
}

if (process.env.ORACLE_CLIENT_LIB_DIR) {
  oracledb.initOracleClient({ libDir: process.env.ORACLE_CLIENT_LIB_DIR });
}

const connectString =
  process.env.ORACLE_CONNECT_STRING ||
  `${process.env.ORACLE_HOST || '127.0.0.1'}:${process.env.ORACLE_PORT || '1521'}/${process.env.ORACLE_SERVICE_NAME || ''}`;

if (!connectString || connectString.endsWith('/')) {
  console.error('Missing Oracle connect string. Set ORACLE_CONNECT_STRING or ORACLE_SERVICE_NAME.');
  process.exit(1);
}

let connection;

try {
  if (process.env.TNS_ADMIN) {
    console.log(`TNS_ADMIN: ${process.env.TNS_ADMIN}`);
  }
  console.log(`Oracle client mode: ${oracledb.thin ? 'Thin' : 'Thick'}`);

  connection = await oracledb.getConnection({
    user: process.env.ORACLE_USER,
    password: process.env.ORACLE_PASSWORD,
    connectString
  });

  console.log(`Connected through: ${connectString}`);

  const identity = await connection.execute(
    `SELECT
       USER AS username,
       SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS current_schema,
       SYS_CONTEXT('USERENV', 'DB_NAME') AS db_name,
       SYS_CONTEXT('USERENV', 'SERVICE_NAME') AS service_name
     FROM dual`,
    [],
    { outFormat: oracledb.OUT_FORMAT_OBJECT }
  );

  console.log('Oracle connection OK');
  console.table(identity.rows);

  const checkUser = process.env.ORACLE_CHECK_USER;

  if (checkUser) {
    try {
      const sessions = await connection.execute(
        `SELECT username, status, COUNT(*) AS session_count
         FROM v$session
         WHERE username = UPPER(:username)
         GROUP BY username, status
         ORDER BY username, status`,
        { username: checkUser },
        { outFormat: oracledb.OUT_FORMAT_OBJECT }
      );

      if (sessions.rows.length === 0) {
        console.log(`No active v$session rows found for ${checkUser.toUpperCase()}.`);
      } else {
        console.log(`Active sessions for ${checkUser.toUpperCase()}:`);
        console.table(sessions.rows);
      }
    } catch (error) {
      console.warn(`Session check skipped: ${error.message}`);
      console.warn('The Oracle user may need SELECT_CATALOG_ROLE or SELECT access to v_$session.');
    }
  }
} catch (error) {
  console.error('Oracle connection failed');
  console.error(error.message);
  process.exitCode = 1;
} finally {
  if (connection) {
    await connection.close();
  }
}
