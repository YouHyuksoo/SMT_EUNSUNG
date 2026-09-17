/**
 * @file src/app/api/server-time/route.ts
 * @description DB 서버 시간 조회 API — SYSDATE 기반
 * 초보자 가이드: 클라이언트의 브라우저 시간이 아닌 DB 서버 시간을 반환한다.
 */
import { NextResponse } from "next/server";
import { executeQuery } from "@/lib/db";

export const dynamic = "force-dynamic";

interface TimeRow { TODAY: string; NOW: string; }

function fallbackKst(): { today: string; now: string } {
  const date = new Date();
  const parts = new Intl.DateTimeFormat('sv-SE', {
    timeZone: 'Asia/Seoul',
    year: 'numeric', month: '2-digit', day: '2-digit',
    hour: '2-digit', minute: '2-digit', second: '2-digit', hourCycle: 'h23',
  }).formatToParts(date);
  const values = Object.fromEntries(parts.filter((part) => part.type !== 'literal').map((part) => [part.type, part.value]));
  const today = `${values.year}-${values.month}-${values.day}`;
  return { today, now: `${today} ${values.hour}:${values.minute}:${values.second}` };
}

export async function GET() {
  try {
    const rows = await executeQuery<TimeRow>(
      `SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS TODAY,
              TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS NOW
       FROM DUAL`,
      {},
    );
    const fallback = fallbackKst();
    return NextResponse.json({ today: rows[0]?.TODAY ?? fallback.today, now: rows[0]?.NOW ?? fallback.now });
  } catch {
    return NextResponse.json(fallbackKst());
  }
}
