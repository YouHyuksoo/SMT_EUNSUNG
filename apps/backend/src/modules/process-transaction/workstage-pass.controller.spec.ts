import { GUARDS_METADATA } from '@nestjs/common/constants';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { WorkstagePassController } from './workstage-pass.controller';

describe('WorkstagePassController', () => {
  it('OrganizationId 사용 화면은 JwtAuthGuard를 적용한다', () => {
    expect(Reflect.getMetadata(GUARDS_METADATA, WorkstagePassController)).toContain(JwtAuthGuard);
  });
});
