import { MenuFavoritesController } from './menu-favorites.controller';
import { MenuFavoritesService } from '../services/menu-favorites.service';
import { BadRequestException } from '@nestjs/common';

describe('MenuFavoritesController', () => {
  it('findMine maps organization and user id to favorite scope', async () => {
    const service = {
      findMine: jest.fn().mockResolvedValue(['MST_PART']),
    } as unknown as MenuFavoritesService;
    const controller = new MenuFavoritesController(service);

    const result = await controller.findMine({
      user: { id: 'tester', email: 'tester@test.com', organizationId: 1 },
    } as never);

    expect(service.findMine).toHaveBeenCalledWith({ organizationId: 1, userId: 'tester' });
    expect(result.data).toEqual(['MST_PART']);
  });

  it('replaceMine passes menuCodes in order with scope', async () => {
    const service = {
      replaceMine: jest.fn().mockResolvedValue(['PROD_ORDER', 'MST_PART']),
    } as unknown as MenuFavoritesService;
    const controller = new MenuFavoritesController(service);

    await controller.replaceMine({ menuCodes: ['PROD_ORDER', 'MST_PART'] }, {
      user: { id: 'tester', organizationId: 1 },
    } as never);

    expect(service.replaceMine).toHaveBeenCalledWith(
      ['PROD_ORDER', 'MST_PART'],
      { organizationId: 1, userId: 'tester' },
    );
  });

  it('rejects missing organization/user info instead of silently defaulting scope', async () => {
    const service = { findMine: jest.fn() } as unknown as MenuFavoritesService;
    const controller = new MenuFavoritesController(service);

    await expect(
      controller.findMine({ user: { id: 'tester' } } as never),
    ).rejects.toThrow(BadRequestException);

    expect(service.findMine).not.toHaveBeenCalled();
  });
});
