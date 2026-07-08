/**
 * @file src/modules/scheduler/services/scheduler-noti.service.ts
 * @description 스케줄러 알림 서비스 - 작업 실행 결과 알림 생성/조회/읽음처리를 관리한다.
 *
 * 초보자 가이드:
 * 1. **generateNotiId()**: Oracle sequence 기반 NOTI_ID 채번
 * 2. **createNotification()**: 실행 실패/완료 등 관리자에게 알림 생성
 * 3. **findByUser()**: 특정 사용자의 최근 알림 목록 조회
 * 4. **getUnreadCount()**: 읽지 않은 알림 개수 (헤더 벨 아이콘 뱃지용)
 * 5. **markAsRead()**: 개별 알림 읽음 처리
 * 6. **markAllAsRead()**: 사용자의 모든 미읽은 알림 일괄 읽음 처리
 */

import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { SchedulerNotification } from '../../../entities/scheduler-notification.entity';

@Injectable()
export class SchedulerNotiService {
  private readonly logger = new Logger(SchedulerNotiService.name);

  constructor(
    @InjectRepository(SchedulerNotification)
    private readonly notiRepo: Repository<SchedulerNotification>,
    private readonly dataSource: DataSource,
  ) {}

  // =============================================
  // 채번
  // =============================================

  /**
   * NOTI_ID 채번: Oracle sequence
   * @param organizationId 조직 ID
   * @returns 다음 NOTI_ID
   */
  async generateNotiId(organizationId: number): Promise<number> {
    const result = await this.dataSource.query(
      `SELECT SEQ_SCHEDULER_NOTIFICATIONS.NEXTVAL AS "nextId" FROM DUAL`,
    );
    return result[0].nextId;
  }

  // =============================================
  // CRUD
  // =============================================

  /**
   * 알림 생성 (notiId 자동 채번)
   * @param data 알림 데이터
   * @returns 생성된 알림
   */
  async createNotification(
    data: Partial<SchedulerNotification>,
  ): Promise<SchedulerNotification> {
    const organizationId = data.organizationId!;
    const notiId = await this.generateNotiId(organizationId);

    const noti = this.notiRepo.create({
      ...data,
      notiId,
      isRead: 'N',
    });

    const saved = await this.notiRepo.save(noti);
    this.logger.log(`알림 생성: organizationId=${organizationId}, notiId=${notiId}, userId=${data.userId}`);
    return saved;
  }

  /**
   * 특정 사용자의 최근 알림 목록 조회
   * @param userId 사용자 ID
   * @param organizationId 조직 ID
   * @param limit 조회 건수 (기본 20)
   */
  async findByUser(
    userId: string,
    organizationId: number,
    limit: number = 20,
  ): Promise<SchedulerNotification[]> {
    return this.notiRepo.find({
      where: { userId, organizationId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }

  /**
   * 읽지 않은 알림 개수 조회
   * @param userId 사용자 ID
   * @param organizationId 조직 ID
   */
  async getUnreadCount(userId: string, organizationId: number): Promise<number> {
    return this.notiRepo.count({
      where: { userId, organizationId, isRead: 'N' },
    });
  }

  /**
   * 개별 알림 읽음 처리
   * @param organizationId 조직 ID
   * @param notiId 알림 ID
   */
  async markAsRead(organizationId: number, notiId: number): Promise<void> {
    await this.notiRepo.update(
      { organizationId, notiId },
      { isRead: 'Y' },
    );
  }

  /**
   * 사용자의 모든 미읽은 알림 일괄 읽음 처리
   * @param userId 사용자 ID
   * @param organizationId 조직 ID
   */
  async markAllAsRead(userId: string, organizationId: number): Promise<void> {
    await this.dataSource.query(
      `UPDATE "SCHEDULER_NOTIFICATIONS"
          SET "IS_READ" = 'Y'
        WHERE "ORGANIZATION_ID" = :1 AND "USER_ID" = :2 AND "IS_READ" = 'N'`,
      [organizationId, userId],
    );
    this.logger.log(`알림 일괄 읽음 처리: organizationId=${organizationId}, userId=${userId}`);
  }
}
