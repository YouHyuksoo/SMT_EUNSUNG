import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { IS_PUBLIC_KEY } from '../../../common/decorators/public.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { EquipmentResultQueryController } from './equipment-result-query.controller';

describe('EquipmentResultQueryController authentication posture', () => {
  it('requires the class-level JwtAuthGuard and is not public', () => {
    expect(Reflect.getMetadata(IS_PUBLIC_KEY, EquipmentResultQueryController)).toBeFalsy();
    expect(Reflect.getMetadata(GUARDS_METADATA, EquipmentResultQueryController) ?? []).toContain(JwtAuthGuard);
  });
});
