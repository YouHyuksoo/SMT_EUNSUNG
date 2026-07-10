/**
 * @file src/modules/scheduler/services/scheduler-noti.service.spec.ts
 * @description SchedulerNotiService ?⑥쐞 ?뚯뒪?? *
 * 珥덈낫??媛?대뱶:
 * - target: ?뚯뒪?????SUT), mock*: 紐⑦궧???섏〈?? * - ?ㅽ뻾: `pnpm test -- -t "SchedulerNotiService"`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { SchedulerNotiService } from './scheduler-noti.service';
import { SchedulerNotification } from '../../../entities/scheduler-notification.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('SchedulerNotiService', () => {
  let target: SchedulerNotiService;
  let mockNotiRepo: DeepMocked<Repository<SchedulerNotification>>;
  let mockDataSource: DeepMocked<DataSource>;

  beforeEach(async () => {
    mockNotiRepo = createMock<Repository<SchedulerNotification>>();
    mockDataSource = createMock<DataSource>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SchedulerNotiService,
        { provide: getRepositoryToken(SchedulerNotification), useValue: mockNotiRepo },
        { provide: DataSource, useValue: mockDataSource },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<SchedulerNotiService>(SchedulerNotiService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // ??? generateNotiId ???
  describe('generateNotiId', () => {
    it('should return next noti ID', async () => {
      // Arrange
      mockDataSource.query.mockResolvedValue([{ nextId: 3 }]);

      // Act
      const result = await target.generateNotiId(1);

      // Assert
      expect(result).toBe(3);
    });
  });

  // ??? createNotification ???
  describe('createNotification', () => {
    it('should create notification with auto ID', async () => {
      // Arrange
      mockDataSource.query.mockResolvedValue([{ nextId: 1 }]);
      const noti = { notiId: 1, isRead: 'N', userId: 'admin@test.com' } as SchedulerNotification;
      mockNotiRepo.create.mockReturnValue(noti);
      mockNotiRepo.save.mockResolvedValue(noti);

      // Act
      const result = await target.createNotification({
        organizationId: 1,
        userId: 'admin@test.com',
        message: 'Test',
      });

      // Assert
      expect(result.notiId).toBe(1);
      expect(result.isRead).toBe('N');
    });
  });

  // ??? findByUser ???
  describe('findByUser', () => {
    it('should return user notifications', async () => {
      // Arrange
      const notis = [{ notiId: 1, userId: 'user' }] as SchedulerNotification[];
      mockNotiRepo.find.mockResolvedValue(notis);

      // Act
      const result = await target.findByUser('user', 1);

      // Assert
      expect(result).toEqual(notis);
      expect(mockNotiRepo.find).toHaveBeenCalledWith({
        where: { userId: 'user', organizationId: 1 },
        order: { createdAt: 'DESC' },
        take: 20,
      });
    });

    it('should respect custom limit', async () => {
      // Arrange
      mockNotiRepo.find.mockResolvedValue([]);

      // Act
      await target.findByUser('user', 1, 5);

      // Assert
      expect(mockNotiRepo.find).toHaveBeenCalledWith(
        expect.objectContaining({ take: 5 }),
      );
    });
  });

  // ??? getUnreadCount ???
  describe('getUnreadCount', () => {
    it('should return unread count', async () => {
      // Arrange
      mockNotiRepo.count.mockResolvedValue(3);

      // Act
      const result = await target.getUnreadCount('user', 1);

      // Assert
      expect(result).toBe(3);
      expect(mockNotiRepo.count).toHaveBeenCalledWith({
        where: { userId: 'user', organizationId: 1, isRead: 'N' },
      });
    });
  });

  // ??? markAsRead ???
  describe('markAsRead', () => {
    it('should mark notification as read', async () => {
      // Arrange
      mockNotiRepo.update.mockResolvedValue({ affected: 1 } as any);

      // Act
      await target.markAsRead(1, 1);

      // Assert
      expect(mockNotiRepo.update).toHaveBeenCalledWith(
        { organizationId: 1, notiId: 1 },
        { isRead: 'Y' },
      );
    });
  });

  // ??? markAllAsRead ???
  describe('markAllAsRead', () => {
    it('should mark all notifications as read', async () => {
      // Arrange
      mockDataSource.query.mockResolvedValue({ affected: 5 });

      // Act
      await target.markAllAsRead('user', 1);

      // Assert
      expect(mockDataSource.query).toHaveBeenCalled();
    });
  });
});


