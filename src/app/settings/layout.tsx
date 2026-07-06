import type { Metadata } from 'next';
import { ThemeProvider } from '@/components/providers/ThemeProvider';
import { LocaleProvider } from '@/components/providers/LocaleProvider';
import '../globals.css';

export const metadata: Metadata = {
  title: 'SOLUEM India MES - 마이그레이션',
};

export default function MigrationSettingsLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="ko" suppressHydrationWarning>
      <body className="bg-zinc-100 text-zinc-950 antialiased dark:bg-zinc-950 dark:text-zinc-50">
        <ThemeProvider>
          <LocaleProvider>{children}</LocaleProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
