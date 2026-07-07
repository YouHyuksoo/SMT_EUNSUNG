import type { Metadata } from "next";
import "../globals.css";

export const metadata: Metadata = {
  title: "은성전장 MES",
  description: "은성전장 SMT MES 업무 시스템",
};

export default function BusinessLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="ko">
      <body className="min-h-screen bg-[#f6f7f9] text-zinc-950 antialiased">
        {children}
      </body>
    </html>
  );
}
