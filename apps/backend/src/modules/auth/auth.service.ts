/**
 * @file src/modules/auth/auth.service.ts
 * @description 인증 서비스 (은성전장) - ISYS_USERS 직접 비밀번호 체크 방식.
 *
 * 기존 인증 방식(토큰=식별자, JWT 미사용, DB 평문 비교)를 참조하되,
 * 은성전장 스키마(ISYS_USERS / ISYS_ORGANIZATION / ISYS_COMPANY)에 맞게 구현한다.
 *
 * 초보자 가이드:
 * 1. **login**: USER_ID/PASSWORD DB 체크 → USER_ID를 토큰으로 반환
 * 2. **me**: USER_ID(토큰)로 현재 사용자 조회
 * 3. **role**: USER_LEVEL(1~9)로 role 문자열 매핑 (9=ADMIN)
 * 4. **RBAC**: 은성 메뉴권한 연동 전까지 allowedMenus=[] (프론트에서 전체 허용)
 */
import {
  Injectable,
  UnauthorizedException,
  Logger,
  NotImplementedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { LoginDto, RegisterDto } from './auth.dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    @InjectRepository(IsysUser)
    private readonly userRepository: Repository<IsysUser>,
    @InjectRepository(IsysOrganization)
    private readonly orgRepository: Repository<IsysOrganization>,
  ) {}

  /** USER_LEVEL(1~9) → role 문자열 매핑 */
  private roleFromLevel(level: number | null): string {
    if (level != null && level >= 9) return 'ADMIN';
    if (level != null && level >= 5) return 'MANAGER';
    return 'OPERATOR';
  }

  /** 프론트 계약(AuthUser)에 맞춘 사용자 객체 생성 */
  private toAuthUser(user: IsysUser, org: IsysOrganization | null) {
    return {
      id: user.userId,
      email: user.emailAddress || user.userId,
      name: user.userName,
      empNo: user.userId,
      dept: user.departmentCode,
      role: this.roleFromLevel(user.userLevel),
      status: 'ACTIVE',
      company: org?.companyCode || '',
      plant: String(user.organizationId),
    };
  }

  /**
   * 로그인 - ISYS_USERS에서 USER_ID/PASSWORD 직접 체크.
   * 프론트는 `email` 필드에 USER_ID를 담아 보낸다.
   * @returns USER_ID를 토큰으로 사용
   */
  async login(dto: LoginDto) {
    const userId = (dto.email ?? '').trim();
    this.logger.debug(`Login attempt: userId=${userId}`);

    const user = await this.userRepository.findOne({ where: { userId } });
    if (!user) {
      this.logger.warn(`Login failed: user not found - ${userId}`);
      throw new UnauthorizedException('아이디 또는 비밀번호가 올바르지 않습니다.');
    }

    if ((user.password ?? '') !== dto.password) {
      this.logger.warn(`Login failed: password mismatch - ${userId}`);
      throw new UnauthorizedException('아이디 또는 비밀번호가 올바르지 않습니다.');
    }

    const org = await this.orgRepository.findOne({
      where: { organizationId: user.organizationId },
    });

    this.logger.log(`User logged in: ${user.userId} (${user.userName})`);

    return {
      token: user.userId, // USER_ID를 토큰으로 사용
      user: this.toAuthUser(user, org),
      allowedMenus: [], // 지금은 전체 허용 (프론트에서 빈 배열=ADMIN 전체)
      pdaAllowedMenus: [],
    };
  }

  /**
   * 현재 사용자 조회 - Bearer 토큰(USER_ID)으로 사용자 조회
   */
  async me(userId: string) {
    const user = await this.userRepository.findOne({ where: { userId } });
    if (!user) {
      throw new UnauthorizedException('유효하지 않은 토큰입니다.');
    }

    const org = await this.orgRepository.findOne({
      where: { organizationId: user.organizationId },
    });

    return {
      ...this.toAuthUser(user, org),
      allowedMenus: [],
      pdaAllowedMenus: [],
    };
  }

  /**
   * 회원가입 - 은성전장은 사용자 등록을 관리자 화면에서 처리한다.
   * (ISYS_USERS는 ORGANIZATION_ID 등 필수값이 많아 셀프 가입 대상이 아님)
   */
  async register(_dto: RegisterDto): Promise<never> {
    throw new NotImplementedException(
      '회원가입은 지원하지 않습니다. 관리자에게 계정 등록을 요청하세요.',
    );
  }
}
