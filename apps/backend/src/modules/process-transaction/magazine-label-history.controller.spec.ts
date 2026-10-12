import { GUARDS_METADATA } from '@nestjs/common/constants';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { MagazineLabelHistoryController } from './magazine-label-history.controller';

describe('MagazineLabelHistoryController', () => {
  it('requires JwtAuthGuard when OrganizationId is used', () => {
    expect(Reflect.getMetadata(GUARDS_METADATA, MagazineLabelHistoryController)).toContain(JwtAuthGuard);
  });
});
