import { GUARDS_METADATA } from '@nestjs/common/constants';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { SalePriceController } from './sale-price.controller';

describe('SalePriceController', () => {
  it('requires JwtAuthGuard', () => {
    const guards = Reflect.getMetadata(GUARDS_METADATA, SalePriceController) ?? [];
    expect(guards).toContain(JwtAuthGuard);
  });
});
