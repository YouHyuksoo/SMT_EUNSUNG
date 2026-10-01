/**
 * @file src/app/components/LandingFooter.tsx
 * @description 랜딩페이지 하단 푸터 - 회사명, 실제 이동 가능한 링크, 저작권
 */

import { Factory } from "lucide-react";
import Link from "next/link";

export default function LandingFooter() {
  return (
    <footer className="py-10 border-t border-border bg-surface/50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6">
        <div className="flex flex-col sm:flex-row items-center justify-between gap-6">
          {/* Brand */}
          <div className="flex items-center gap-2">
            <div className="w-7 h-7 bg-primary/20 rounded-md flex items-center justify-center">
              <Factory className="w-4 h-4 text-primary" />
            </div>
            <span className="font-semibold text-sm text-text">㈜은성전장 · 은성전장 MES</span>
          </div>

          {/* Nav Links */}
          <nav className="flex items-center gap-6">
            <Link href="/login" className="text-xs text-text-muted hover:text-text transition-colors">
              로그인
            </Link>
            <a
              href="http://eunsungele.com/"
              target="_blank"
              rel="noopener noreferrer"
              className="text-xs text-text-muted hover:text-text transition-colors"
            >
              회사 홈페이지
            </a>
          </nav>

          {/* Copyright */}
          <p className="text-xs text-text-muted">
            &copy; {new Date().getFullYear()} EUNSUNG. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}
