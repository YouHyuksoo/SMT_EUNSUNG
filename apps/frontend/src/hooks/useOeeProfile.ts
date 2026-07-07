'use client';

/**
 * @file src/hooks/useOeeProfile.ts
 * @description OEE 가동일지 입력 단말 프로파일(공정·리소스·근무조) localStorage 훅.
 * 태블릿/PC 단말마다 최초 1회 선택 후 고정. 인증과 별개의 단말 식별.
 */
import { useEffect, useState } from 'react';

export interface OeeProfile {
  resourceId: number;
  processCode: string;
  resourceName: string;
  shift: string; // DAY / NIGHT
}

const KEY = 'oee-terminal-profile';

export function useOeeProfile() {
  const [profile, setProfileState] = useState<OeeProfile | null>(null);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    const raw = localStorage.getItem(KEY);
    if (raw) {
      try {
        setProfileState(JSON.parse(raw) as OeeProfile);
      } catch {
        /* 손상된 값 무시 */
      }
    }
    setLoaded(true);
  }, []);

  function setProfile(p: OeeProfile | null) {
    if (p) localStorage.setItem(KEY, JSON.stringify(p));
    else localStorage.removeItem(KEY);
    setProfileState(p);
  }

  return { profile, setProfile, loaded };
}
