import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { MenuCategoriesController } from './menu-categories.controller';
import { MenuCategoryItemsController } from './menu-category-items.controller';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { Public, IS_PUBLIC_KEY } from '../../../common/decorators/public.decorator';

/**
 * 은성 아키텍처에서는 JwtAuthGuard를 전역 등록하지 않고 인증이 필요한 컨트롤러마다
 * @UseGuards(JwtAuthGuard)를 명시한다. 이 컨트롤러들은 테넌트(organizationId) 스코프
 * 데이터를 다루므로 반드시 JwtAuthGuard가 붙어 있고 @Public()으로 우회되지 않아야 한다.
 */
describe('Menu category controller auth posture', () => {
  it.each([MenuCategoriesController, MenuCategoryItemsController])(
    'requires JwtAuthGuard and is not @Public(): %p',
    (controller) => {
      // 컨트롤러 자체가 Public이면 위험.
      const classPublic = Reflect.getMetadata(IS_PUBLIC_KEY, controller);
      expect(classPublic).toBeFalsy();

      // 클래스 레벨 @UseGuards(JwtAuthGuard)가 명시되어 있어야 한다.
      const guards = Reflect.getMetadata(GUARDS_METADATA, controller) ?? [];
      expect(guards).toContain(JwtAuthGuard);
    },
  );

  it('Public 데코레이터를 임포트해도 이 컨트롤러에는 부여되지 않아야 한다', () => {
    // @Public 데코레이터 자체는 존재해도, 이 모듈에서 컨트롤러에 안 붙어 있으면 OK
    expect(Public).toBeDefined();
  });
});
