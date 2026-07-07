import { Request } from 'express';

export interface RequestUser {
  id?: string;
  email?: string;
  role?: string;
  /** 테넌트 키 — 모든 테넌트 스코프 쿼리는 이 값을 사용한다. */
  organizationId?: number;
  /** 표시용 회사코드(ISYS_COMPANY). 키로 사용하지 않는다. */
  company?: string;
  /** @deprecated 하위호환용. 테넌트 키는 organizationId를 사용한다. */
  plant?: string;
}

export type RequestWithUser = Request & { user?: RequestUser };

export function getRequestUser(request: RequestWithUser): RequestUser | undefined {
  return request.user;
}

export function setRequestUser(request: RequestWithUser, user: RequestUser): void {
  request.user = user;
}
