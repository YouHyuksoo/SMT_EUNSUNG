import { Body, Controller, Get, HttpCode, HttpStatus, Post, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { CreatePrdLabelsDto } from '../dto/product-label.dto';
import { ProductLabelService } from '../services/product-label.service';

@ApiTags('Production - Product Label')
@Controller('production/product-label')
export class ProductLabelController {
  constructor(private readonly service: ProductLabelService) {}

  @Get('results')
  @ApiOperation({ summary: 'List labelable production results' })
  async findLabelableResults(@OrganizationId() organizationId: number) {
    const data = await this.service.findLabelableResults(organizationId);
    return ResponseUtil.success(data);
  }

  @Get('oqc-passed')
  @ApiOperation({ summary: 'List OQC passed and labelable production results' })
  async findLabelableOqcPassed(@OrganizationId() organizationId: number) {
    const data = await this.service.findLabelableOqcPassed(organizationId);
    return ResponseUtil.success(data);
  }

  @Post('create')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Issue product labels (prdUid)' })
  async createLabels(
    @Body() dto: CreatePrdLabelsDto,
    @OrganizationId() organizationId: number,
  ) {
    const data = await this.service.createPrdLabels(dto, organizationId);
    return ResponseUtil.success(data, `${data.length} product labels created`);
  }
}
