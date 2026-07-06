import { applySomosMigration, previewSomosMigration } from '@/lib/migration/somos-product';

export const runtime = 'nodejs';
export const maxDuration = 300;

export async function POST(request: Request) {
  const formData = await request.formData();
  const file = formData.get('file');
  const action = String(formData.get('action') ?? 'preview');

  if (!(file instanceof File)) {
    return Response.json({ success: false, error: 'Excel 파일이 필요합니다.' }, { status: 400 });
  }

  const buffer = Buffer.from(await file.arrayBuffer());
  const encoder = new TextEncoder();

  const stream = new ReadableStream({
    async start(controller) {
      const send = (data: object) => {
        controller.enqueue(encoder.encode(`data: ${JSON.stringify(data)}\n\n`));
      };
      const onProgress = (msg: string) => send({ log: msg });
      try {
        const result = action === 'apply'
          ? await applySomosMigration(buffer, onProgress)
          : await previewSomosMigration(buffer, onProgress);
        send({ done: true, result });
      } catch (error) {
        send({ error: error instanceof Error ? error.message : '마이그레이션 처리 중 오류가 발생했습니다.' });
      } finally {
        controller.close();
      }
    },
  });

  return new Response(stream, {
    headers: {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'X-Accel-Buffering': 'no',
    },
  });
}
