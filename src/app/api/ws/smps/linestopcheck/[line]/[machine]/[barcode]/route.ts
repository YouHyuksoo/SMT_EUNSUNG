import { NextResponse } from 'next/server';

export const dynamic = 'force-dynamic';

interface RouteParams {
  params: Promise<{
    line: string;
    machine: string;
    barcode: string;
  }>;
}

export async function GET(_request: Request, { params }: RouteParams) {
  await params;

  return new NextResponse('OK', {
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  });
}
