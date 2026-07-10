/**
 * @file packages/shared/src/index.ts
 * @description 은성전장 MES 공유 패키지 진입점
 *
 * 초보자 가이드:
 * 1. **전체 import**: import { JobOrder, MENU_ITEMS, formatDate } from '@smt/shared'
 * 2. **부분 import**: import type { JobOrder } from '@smt/shared/types'
 * 3. **상수만**: import { MENU_ITEMS } from '@smt/shared/constants'
 * 4. **유틸만**: import { formatDate } from '@smt/shared/utils'
 */

// 타입 내보내기
export * from './types';

// 상수 내보내기
export * from './constants';

// 유틸리티 내보내기
export * from './utils';

// OEE 도메인(계산·검증·타입) 내보내기
export * from './oee';
