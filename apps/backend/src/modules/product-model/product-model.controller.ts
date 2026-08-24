// 제품 모델 마스터 REST 컨트롤러 (글로벌 prefix /api/v1): /master/product-models
import { Controller, Get } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { ProductModelService } from './product-model.service';

@Public()
@Controller('master/product-models')
export class ProductModelController {
  constructor(private readonly service: ProductModelService) {}

  @Get()
  async list() {
    return { list: await this.service.list() };
  }
}
