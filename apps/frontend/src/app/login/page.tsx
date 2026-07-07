"use client";

/**
 * @file src/app/login/page.tsx
 * @description 은성전장 로그인 페이지 - 좌측 브랜딩 + 우측 로그인 폼.
 *
 * 은성전장 인증 모델:
 * 1. ISYS_USERS.USER_ID + PASSWORD 로 로그인 (이메일/회원가입 없음)
 * 2. 단일 조직이라 회사/사업장 선택 없음 (백엔드가 사용자 조직에서 파생)
 * 3. useAuthStore.login(userId, password) 호출
 */
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useTranslation } from 'react-i18next';
import { LogIn, Factory, Smartphone } from 'lucide-react';
import { useAuthStore } from '@/stores/authStore';
import { Button, Input } from '@/components/ui';
import { AxiosError } from 'axios';
import LoginBranding from './components/LoginBranding';
import LanguageSwitcher from '@/components/layout/LanguageSwitcher';
import ConnectionCheckOverlay from './components/ConnectionCheckOverlay';

function LoginPage() {
  const router = useRouter();
  const { t } = useTranslation();
  const { login, isLoading } = useAuthStore();
  const [error, setError] = useState('');
  const [systemReady, setSystemReady] = useState(false);

  // 로그인 폼 (USER_ID / PASSWORD)
  const [userId, setUserId] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    try {
      await login(userId, password);
      router.replace('/dashboard');
    } catch (err) {
      const axiosErr = err as AxiosError<{ message: string }>;
      setError(axiosErr.response?.data?.message || t('auth.loginFailed'));
    }
  };

  return (
    <div className="min-h-screen flex bg-background">
      {/* 시스템 연결 확인 오버레이 */}
      {!systemReady && <ConnectionCheckOverlay onReady={() => setSystemReady(true)} />}

      {/* 좌측 - 애니메이션 브랜딩 영역 */}
      <LoginBranding />

      {/* 우측 - 폼 영역 */}
      <div className="flex-1 flex items-center justify-center p-8">
        <div className="w-full max-w-md">
          {/* 모바일 로고 */}
          <div className="lg:hidden text-center mb-8">
            <div className="w-12 h-12 bg-primary rounded-xl flex items-center justify-center mx-auto mb-3">
              <Factory className="w-6 h-6 text-white" />
            </div>
            <h1 className="text-2xl font-bold text-text">은성전장 MES</h1>
          </div>

          {/* 헤더 + 언어 선택 */}
          <div className="flex items-center border-b border-border mb-8">
            <div className="flex-1 pb-3 text-sm font-medium border-b-2 border-primary text-primary">
              <LogIn className="w-4 h-4 inline mr-2" />
              {t('auth.login')}
            </div>
            <div className="ml-auto pb-2">
              <LanguageSwitcher />
            </div>
          </div>

          {/* 에러 메시지 */}
          {error && (
            <div className="mb-4 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-sm text-red-600 dark:text-red-400">
              {error}
            </div>
          )}

          {/* 로그인 폼 */}
          <form onSubmit={handleLogin} className="space-y-4">
            <h2 className="text-xl font-semibold text-text mb-2">{t('auth.loginTitle')}</h2>
            <p className="text-sm text-text-muted mb-6">{t('auth.loginDesc')}</p>

            <Input
              label={t('auth.userId')}
              type="text"
              placeholder="ADMIN"
              value={userId}
              onChange={(e) => setUserId(e.target.value)}
              autoComplete="username"
              fullWidth
              required
            />
            <Input
              label={t('auth.password')}
              type="password"
              placeholder={t('auth.password')}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete="current-password"
              fullWidth
              required
            />

            <Button type="submit" isLoading={isLoading} className="w-full mt-6">
              {t('auth.login')}
            </Button>

            {/* PDA 접속 링크 */}
            <div className="mt-5 text-center">
              <button
                type="button"
                onClick={() => router.push('/pda/login')}
                className="inline-flex items-center gap-1.5 text-sm text-text-muted hover:text-primary transition-colors"
              >
                <Smartphone className="w-4 h-4" />
                {t('auth.pdaLogin')}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}

export default LoginPage;
