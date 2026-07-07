import 'dotenv/config';
import path from 'node:path';
import oracledb from 'oracledb';

const required = [
  'ORACLE_ADMIN_USER',
  'ORACLE_ADMIN_PASSWORD',
  'CREATE_ORACLE_USER',
  'CREATE_ORACLE_PASSWORD'
];

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

function oracleIdentifier(value, name) {
  const normalized = value.trim().toUpperCase();

  if (!/^[A-Z][A-Z0-9_$#]{0,127}$/.test(normalized)) {
    throw new Error(`${name} must be a simple Oracle identifier. Received: ${value}`);
  }

  return normalized;
}

function oraclePassword(value) {
  return `"${value.replaceAll('"', '""')}"`;
}

const username = oracleIdentifier(process.env.CREATE_ORACLE_USER, 'CREATE_ORACLE_USER');
const defaultTablespace = oracleIdentifier(
  process.env.CREATE_ORACLE_DEFAULT_TABLESPACE || 'USERS',
  'CREATE_ORACLE_DEFAULT_TABLESPACE'
);
const tempTablespace = oracleIdentifier(
  process.env.CREATE_ORACLE_TEMP_TABLESPACE || 'TEMP',
  'CREATE_ORACLE_TEMP_TABLESPACE'
);
const quota = (process.env.CREATE_ORACLE_QUOTA || 'UNLIMITED').trim().toUpperCase();
const grants = (process.env.CREATE_ORACLE_GRANTS || 'CREATE SESSION')
  .split(',')
  .map((grant) => grant.trim().toUpperCase())
  .filter(Boolean);

let connection;

try {
  connection = await oracledb.getConnection({
    user: process.env.ORACLE_ADMIN_USER,
    password: process.env.ORACLE_ADMIN_PASSWORD,
    connectString
  });

  const existing = await connection.execute(
    `SELECT username FROM all_users WHERE username = :username`,
    { username },
    { outFormat: oracledb.OUT_FORMAT_OBJECT }
  );

  if (existing.rows.length > 0) {
    console.log(`Oracle user ${username} already exists. Creation skipped.`);
  } else {
    await connection.execute(
      `CREATE USER ${username}
       IDENTIFIED BY ${oraclePassword(process.env.CREATE_ORACLE_PASSWORD)}
       DEFAULT TABLESPACE ${defaultTablespace}
       TEMPORARY TABLESPACE ${tempTablespace}`
    );

    console.log(`Created Oracle user ${username}.`);
  }

  if (quota === 'UNLIMITED') {
    await connection.execute(`ALTER USER ${username} QUOTA UNLIMITED ON ${defaultTablespace}`);
  } else if (/^\d+[KMGTP]?$/i.test(quota)) {
    await connection.execute(`ALTER USER ${username} QUOTA ${quota} ON ${defaultTablespace}`);
  } else {
    throw new Error(`CREATE_ORACLE_QUOTA must be UNLIMITED or a size like 500M. Received: ${quota}`);
  }

  for (const grant of grants) {
    if (!/^[A-Z][A-Z0-9_ ]{0,127}$/.test(grant)) {
      throw new Error(`Invalid grant name: ${grant}`);
    }

    await connection.execute(`GRANT ${grant} TO ${username}`);
  }

  console.log(`Granted privileges to ${username}: ${grants.join(', ')}`);

  const result = await connection.execute(
    `SELECT username, account_status, default_tablespace, temporary_tablespace
     FROM dba_users
     WHERE username = :username`,
    { username },
    { outFormat: oracledb.OUT_FORMAT_OBJECT }
  );

  console.table(result.rows);
} catch (error) {
  console.error('Oracle user creation failed');
  console.error(error.message);

  if (error.message.includes('ORA-65096')) {
    console.error('Connect to the target PDB service, not the CDB root, when creating ES_MES.');
  }

  process.exitCode = 1;
} finally {
  if (connection) {
    await connection.close();
  }
}
