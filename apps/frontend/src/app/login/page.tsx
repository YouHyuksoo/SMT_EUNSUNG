"use client";

/**
 * @file src/app/login/page.tsx
 * @description 은성전장 로그인 페이지 - 가운데 로고·문구, 왼쪽 가치 원(Product·Environment·Quality), 오른쪽 로그인 카드.
 *
 * 은성전장 인증 모델:
 * 1. ISYS_USERS.USER_ID + PASSWORD 로 로그인 (이메일/회원가입 없음)
 * 2. 단일 조직이라 회사/사업장 선택 없음 (백엔드가 사용자 조직에서 파생)
 * 3. useAuthStore.login(userId, password) 호출
 *
 * 화면 구성:
 * - 배경: 왼쪽 위·오른쪽 아래 파란 곡선(SVG), 오른쪽 위 점 세계지도(canvas, 점이 깜박임),
 *   왼쪽 아래 공장 사진(public/images/login-factory.png)
 * - 로고·제목·문구는 차례로 떠오르며 나타나고, 제목 "MES" 와 문구에는 빛이 지나가는 효과가 주기적으로 돈다.
 * - 로그인 화면은 밝은 배경 고정이다 (다크 모드 토큰을 쓰지 않는다).
 */
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useTranslation } from 'react-i18next';
import { LockKeyhole, Smartphone, UserRound } from 'lucide-react';
import Image from 'next/image';
import { useAuthStore } from '@/stores/authStore';
import { AxiosError } from 'axios';
import LanguageSwitcher from '@/components/layout/LanguageSwitcher';
import ConnectionCheckOverlay from './components/ConnectionCheckOverlay';
import LoginValueCircles from './components/LoginValueCircles';
import LoginWorldMap from './components/LoginWorldMap';

/** 로고·제목·문구 등장과 빛 지나가는 효과. 동작 줄이기 설정이면 끈다. */
const HEADLINE_STYLE = `
.lp-rise { animation: lp-rise .8s cubic-bezier(.22,1,.36,1) both; animation-delay: var(--d, 0s); }
.lp-shine { background-image: linear-gradient(100deg, var(--c) 0%, var(--c) 42%, var(--h) 50%, var(--c) 58%, var(--c) 100%);
  background-size: 260% 100%; background-position: 100% 0; -webkit-background-clip: text; background-clip: text;
  color: transparent; animation: lp-shine 5s ease-in-out infinite; animation-delay: var(--sd, 1.6s); }
.lp-rise.lp-shine { animation: lp-rise .8s cubic-bezier(.22,1,.36,1) both, lp-shine 5s ease-in-out infinite;
  animation-delay: var(--d, 0s), var(--sd, 1.6s); }
@keyframes lp-rise { from { opacity: 0; transform: translateY(14px); filter: blur(4px); } to { opacity: 1; transform: none; filter: none; } }
@keyframes lp-shine { 0% { background-position: 100% 0; } 45%, 100% { background-position: 0% 0; } }
@media (prefers-reduced-motion: reduce) { .lp-rise, .lp-shine { animation: none !important; } }
`;

/** 왼쪽 위 파란 곡선. 오른쪽 아래는 같은 도형을 180도 돌려 쓴다. */
function CornerWave({ className }: { className?: string }) {
  return (
    <svg
      className={`pointer-events-none absolute ${className ?? ''}`}
      viewBox="0 0 460 320"
      fill="none"
      aria-hidden
    >
      <defs>
        <linearGradient id="login-wave-dark" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stopColor="#3566c4" />
          <stop offset="100%" stopColor="#6f97dd" />
        </linearGradient>
      </defs>
      <path d="M0 0H460C360 30 250 80 160 150C100 196 45 250 0 300Z" fill="#e3ecf9" />
      <path d="M0 0H330C240 40 150 95 90 150C50 186 22 222 0 258Z" fill="#b7cdef" />
      <path d="M0 0H190C130 40 70 100 0 195Z" fill="url(#login-wave-dark)" />
    </svg>
  );
}

function LoginPage() {
  const router = useRouter();
  const { t } = useTranslation();
  const { login } = useAuthStore();
  // 로그인 API 완료 후 화면 이동이 끝날 때까지 유지 (중복 클릭 방지)
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [systemReady, setSystemReady] = useState(false);

  // 로그인 폼 (USER_ID / PASSWORD)
  const [userId, setUserId] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSubmitting) return;
    setError('');
    setIsSubmitting(true);
    try {
      await login(userId, password);
      router.replace('/dashboard');
    } catch (err) {
      const axiosErr = err as AxiosError<{ message: string }>;
      setError(axiosErr.response?.data?.message || t('auth.loginFailed'));
      setIsSubmitting(false);
    }
  };

  const fieldClass =
    'flex h-[60px] items-center gap-4 rounded-lg border border-[#d4dbe6] bg-white px-6 transition-colors focus-within:border-[#1a5cc8] focus-within:ring-2 focus-within:ring-[#1a5cc8]/15';
  const inputClass =
    'h-full w-full bg-transparent text-lg text-[#1f2a3d] placeholder:text-[#7a8597] focus:outline-none';

  return (
    <div className="relative min-h-screen overflow-hidden bg-[#f4f7fb]">
      <style>{HEADLINE_STYLE}</style>
      {/* 시스템 연결 확인 오버레이 */}
      {!systemReady && <ConnectionCheckOverlay onReady={() => setSystemReady(true)} />}

      {/* 배경 장식 */}
      <CornerWave className="left-0 top-0 w-[30vw] min-w-[260px]" />
      <CornerWave className="bottom-0 right-0 w-[24vw] min-w-[220px] rotate-180" />
      <LoginWorldMap className="pointer-events-none absolute right-0 top-[4%] hidden w-[32vw] max-w-[620px] lg:block" />
      <Image
        src="/images/login-factory.png"
        alt=""
        width={620}
        height={254}
        priority
        className="pointer-events-none absolute bottom-0 left-0 hidden w-[42vw] max-w-[820px] lg:block"
      />

      {/* 언어 선택 */}
      <div className="absolute right-6 top-5 z-10">
        <LanguageSwitcher />
      </div>

      <main className="relative z-[1] flex min-h-screen flex-col items-center justify-center px-6 py-10">
        {/* 로고 + 제목 + 문구 */}
        <Image
          src="/images/eunsung-logo.png"
          alt="EUNSUNG"
          width={200}
          height={91}
          priority
          className="lp-rise h-auto w-[180px] lg:w-[220px]"
        />
        <h1 className="mt-3 text-4xl font-bold tracking-tight lg:text-[56px] lg:leading-none">
          <span
            className="lp-rise lp-shine inline-block"
            style={{ '--d': '.15s', '--c': '#1550b9', '--h': '#7fb2ff', '--sd': '1.4s' } as React.CSSProperties}
          >
            MES
          </span>{' '}
          <span
            className="lp-rise inline-block font-medium text-[#5d6f8c]"
            style={{ '--d': '.3s' } as React.CSSProperties}
          >
            System
          </span>
        </h1>
        <p className="mt-5 text-center text-lg leading-relaxed lg:text-[21px]">
          <span
            className="lp-rise lp-shine inline-block"
            style={{ '--d': '.5s', '--c': '#4a5568', '--h': '#1a5cc8', '--sd': '2s' } as React.CSSProperties}
          >
            {t('auth.sloganLine1', '더 나은 품질과 효율적인 생산을 위해')}
          </span>
          <br />
          <span
            className="lp-rise lp-shine inline-block"
            style={{ '--d': '.7s', '--c': '#4a5568', '--h': '#1a5cc8', '--sd': '2.3s' } as React.CSSProperties}
          >
            {t('auth.sloganLine2', '언제나 최선을 다하는 은성')}
          </span>
        </p>

        {/* 가치 원 + 로그인 카드 */}
        <div className="mt-8 flex w-full max-w-[1180px] items-center justify-center gap-[88px] lg:-translate-x-16">
          <LoginValueCircles className="hidden w-[430px] shrink-0 lg:block lg:-translate-y-[90px]" />

          <form
            onSubmit={handleLogin}
            className="w-full max-w-[662px] rounded-2xl border border-[#e3e8ef] bg-white px-8 py-10 shadow-[0_10px_40px_rgba(30,60,120,0.08)] lg:px-[50px] lg:py-[48px]"
          >
            {error && (
              <div className="mb-5 rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-600">
                {error}
              </div>
            )}

            <label className={fieldClass}>
              <UserRound className="h-7 w-7 shrink-0 text-[#4a5568]" strokeWidth={1.6} />
              <input
                type="text"
                aria-label={t('auth.userId')}
                placeholder={t('auth.userIdPlaceholder', '아이디를 입력하세요.')}
                value={userId}
                onChange={(e) => setUserId(e.target.value)}
                autoComplete="username"
                required
                className={inputClass}
              />
            </label>

            <label className={`${fieldClass} mt-6`}>
              <LockKeyhole className="h-7 w-7 shrink-0 text-[#4a5568]" strokeWidth={1.6} />
              <input
                type="password"
                aria-label={t('auth.password')}
                placeholder={t('auth.passwordInputPlaceholder', '비밀번호를 입력하세요.')}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                autoComplete="current-password"
                required
                className={inputClass}
              />
            </label>

            <button
              type="submit"
              disabled={isSubmitting}
              className="mt-8 flex h-[64px] w-full items-center justify-center rounded-lg bg-[#1a5cc8] text-xl font-medium text-white transition-colors hover:bg-[#164fae] disabled:opacity-70"
            >
              {isSubmitting ? (
                <span className="h-6 w-6 animate-spin rounded-full border-2 border-white/40 border-t-white" />
              ) : (
                t('auth.login')
              )}
            </button>

            {/* PDA 접속 링크 */}
            <div className="mt-5 text-center">
              <button
                type="button"
                onClick={() => router.push('/pda/login')}
                className="inline-flex items-center gap-1.5 text-sm text-[#7a8597] transition-colors hover:text-[#1a5cc8]"
              >
                <Smartphone className="h-4 w-4" />
                {t('auth.pdaLogin')}
              </button>
            </div>
          </form>
        </div>
      </main>
    </div>
  );
}

export default LoginPage;
