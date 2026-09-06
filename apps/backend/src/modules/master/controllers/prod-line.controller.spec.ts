import { GUARDS_METADATA } from '@nestjs/common/constants';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ProdLineController } from './prod-line.controller';

describe('ProdLineController authentication contract', () => {
  it('requires JwtAuthGuard so OrganizationId is populated', () => {
    const guards = Reflect.getMetadata(GUARDS_METADATA, ProdLineController) ?? [];
    expect(guards).toContain(JwtAuthGuard);
  });
});
