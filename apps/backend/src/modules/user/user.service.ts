/**
 * @file src/modules/user/user.service.ts
 * @description 사용자 CRUD 서비스
 */
import {
  Injectable,
  NotFoundException,
  ConflictException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IsysUser } from '../../entities/isys-user.entity';
import { CreateUserDto, UpdateUserDto } from './user.dto';

export interface UserView {
  email: string;
  name: string | null;
  empNo: string | null;
  dept: string | null;
  role: string;
  status: string;
  photoUrl: string | null;
  pdaRoleCode: string | null;
  lastLoginAt: Date | null;
  createdAt: Date | null;
  updatedAt?: Date | null;
}

@Injectable()
export class UserService {
  private readonly logger = new Logger(UserService.name);

  constructor(
    @InjectRepository(IsysUser)
    private readonly userRepository: Repository<IsysUser>,
  ) {}

  private tenantWhere(organizationId?: number) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  private roleFromLevel(level: number | null): string {
    if (level != null && level >= 9) return 'ADMIN';
    if (level != null && level >= 5) return 'MANAGER';
    return 'OPERATOR';
  }

  private levelFromRole(role?: string): number | undefined {
    if (role === 'ADMIN') return 9;
    if (role === 'MANAGER') return 5;
    if (role === 'OPERATOR' || role === 'VIEWER') return 1;
    return undefined;
  }

  private toView(user: IsysUser): UserView {
    return {
      email: user.userId,
      name: user.userName,
      empNo: user.userId,
      dept: user.departmentCode,
      role: this.roleFromLevel(user.userLevel),
      status: 'ACTIVE',
      photoUrl: null,
      pdaRoleCode: null,
      lastLoginAt: user.lastLoginAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };
  }

  private sanitizeUpdateDto(dto: UpdateUserDto): Partial<IsysUser> {
    return {
      ...(dto.name !== undefined ? { userName: dto.name } : {}),
      ...(dto.password !== undefined ? { password: dto.password } : {}),
      ...(dto.dept !== undefined ? { departmentCode: dto.dept } : {}),
      ...(dto.role !== undefined && this.levelFromRole(dto.role) !== undefined
        ? { userLevel: this.levelFromRole(dto.role) }
        : {}),
      updatedAt: new Date(),
    };
  }

  /** 사용자 목록 조회 (검색/필터) */
  async findAll(query?: { search?: string; role?: string; status?: string }, organizationId?: number) {
    if (query?.status && query.status !== 'ACTIVE') {
      return [];
    }
    const queryBuilder = this.userRepository.createQueryBuilder('user');

    if (organizationId != null) {
      queryBuilder.andWhere('user.organizationId = :organizationId', { organizationId });
    }

    if (query?.search) {
      const search = `%${query.search}%`;
      queryBuilder.andWhere(
        '(user.userId LIKE :search OR user.userName LIKE :search OR user.emailAddress LIKE :search)',
        { search },
      );
    }

    if (query?.role === 'ADMIN') {
      queryBuilder.andWhere('user.userLevel >= :level', { level: 9 });
    } else if (query?.role === 'MANAGER') {
      queryBuilder.andWhere('user.userLevel >= :minLevel AND user.userLevel < :maxLevel', { minLevel: 5, maxLevel: 9 });
    } else if (query?.role === 'OPERATOR' || query?.role === 'VIEWER') {
      queryBuilder.andWhere('(user.userLevel < :level OR user.userLevel IS NULL)', { level: 5 });
    }

    const rows = await queryBuilder.orderBy('user.createdAt', 'DESC').addOrderBy('user.userId', 'ASC').getMany();
    return rows.map((row) => this.toView(row));
  }

  /** 사용자 상세 조회 */
  async findOne(id: string, organizationId?: number) {
    const user = await this.userRepository.findOne({
      where: { userId: id, ...this.tenantWhere(organizationId) },
    });

    if (!user) {
      throw new NotFoundException('사용자를 찾을 수 없습니다.');
    }

    return this.toView(user);
  }

  /** 사용자 생성 */
  async create(dto: CreateUserDto, organizationId?: number) {
    const existing = await this.userRepository.findOne({
      where: { userId: dto.email, ...this.tenantWhere(organizationId) },
    });

    if (existing) {
      throw new ConflictException('이미 등록된 사용자 ID입니다.');
    }

    const user = this.userRepository.create({
      userId: dto.email,
      password: dto.password,
      userName: dto.name,
      departmentCode: dto.dept,
      emailAddress: dto.email.includes('@') ? dto.email : null,
      userLevel: this.levelFromRole(dto.role) ?? 1,
      organizationId: organizationId ?? 1,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    const savedUser = await this.userRepository.save(user);

    this.logger.log(`User created: ${savedUser.userId}`);

    return { id: savedUser.userId, ...this.toView(savedUser) };
  }

  /** 사용자 수정 */
  async update(id: string, dto: UpdateUserDto, organizationId?: number) {
    await this.findOne(id, organizationId); // 존재 확인

    const safeDto = this.sanitizeUpdateDto(dto);
    await this.userRepository.update({ userId: id, ...this.tenantWhere(organizationId) }, safeDto);

    const user = await this.userRepository.findOne({ where: { userId: id, ...this.tenantWhere(organizationId) } });

    this.logger.log(`User updated: ${user!.userId}`);
    return this.toView(user!);
  }

  /** 사용자 삭제 (소프트 삭제) */
  async remove(id: string, organizationId?: number) {
    await this.findOne(id, organizationId);

    await this.userRepository.delete({ userId: id, ...this.tenantWhere(organizationId) });

    this.logger.log(`User deleted: ${id}`);
    return { message: '사용자가 삭제되었습니다.' };
  }

  /** 사진 URL 업데이트 */
  async updatePhoto(id: string, photoUrl: string | null, organizationId?: number) {
    const user = await this.findOne(id, organizationId);

    this.logger.log(`User photo update skipped for ISYS_USERS: ${user.email}`);
    return { 
      id, 
      photoUrl,
      message: photoUrl ? '사진이 업로드되었습니다.' : '사진이 삭제되었습니다.' 
    };
  }
}
