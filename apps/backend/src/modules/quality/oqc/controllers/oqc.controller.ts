import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiParam, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../../common/dto/response.dto';
import { AuthenticatedRequest, JwtAuthGuard } from '../../../../common/guards/jwt-auth.guard';
import {
  CreateOqcRequestDto,
  ExecuteOqcInspectionDto,
  OqcRequestQueryDto,
  UpdateOqcResultDto,
} from '../dto/oqc.dto';
import { OqcService } from '../services/oqc.service';

@ApiTags('Quality - OQC')
@Controller('quality/oqc')
export class OqcController {
  constructor(private readonly oqcService: OqcService) {}

  @Get('stats')
  @ApiOperation({ summary: 'OQC stats' })
  @ApiResponse({ status: 200, description: 'OK' })
  async getStats(@OrganizationId() organizationId?: number) {
    const data = await this.oqcService.getStats(organizationId);
    return ResponseUtil.success(data);
  }

  @Get('available-boxes')
  @ApiOperation({ summary: 'Available boxes for OQC' })
  @ApiQuery({ name: 'itemCode', required: false })
  @ApiResponse({ status: 200, description: 'OK' })
  async getAvailableBoxes(
    @Query('itemCode') itemCode?: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.oqcService.getAvailableBoxes(itemCode, organizationId);
    return ResponseUtil.success(data);
  }

  @Get()
  @ApiOperation({ summary: 'OQC request list' })
  @ApiResponse({ status: 200, description: 'OK' })
  async findAll(
    @Query() query: OqcRequestQueryDto,
    @OrganizationId() organizationId?: number,
  ) {
    const result = await this.oqcService.findAll(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get(':id')
  @ApiOperation({ summary: 'OQC request detail' })
  @ApiParam({ name: 'id' })
  @ApiResponse({ status: 200, description: 'OK' })
  @ApiResponse({ status: 404, description: 'Not found' })
  async findById(@Param('id') id: string, @OrganizationId() organizationId?: number) {
    const data = await this.oqcService.findById(id, organizationId);
    return ResponseUtil.success(data);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create OQC request' })
  @ApiResponse({ status: 201, description: 'Created' })
  async createRequest(
    @Body() dto: CreateOqcRequestDto,
    @Req() req: AuthenticatedRequest,
    @OrganizationId() organizationId?: number,
  ) {
    const userId = req.user?.id;
    const data = await this.oqcService.createRequest(dto, organizationId, userId);
    return ResponseUtil.success(data, 'OQC request created');
  }

  @Post(':id/execute')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Execute OQC inspection' })
  @ApiParam({ name: 'id' })
  @ApiResponse({ status: 200, description: 'OK' })
  async executeInspection(
    @Param('id') id: string,
    @Body() dto: ExecuteOqcInspectionDto,
    @Req() req: AuthenticatedRequest,
    @OrganizationId() organizationId?: number,
  ) {
    const userId = req.user?.id;
    const data = await this.oqcService.executeInspection(id, dto, userId, organizationId);
    return ResponseUtil.success(data, `Result: ${dto.result}`);
  }

  @Patch(':id/result')
  @ApiOperation({ summary: 'Update OQC result' })
  @ApiParam({ name: 'id' })
  @ApiResponse({ status: 200, description: 'OK' })
  async updateResult(
    @Param('id') id: string,
    @Body() dto: UpdateOqcResultDto,
    @Req() req: AuthenticatedRequest,
    @OrganizationId() organizationId?: number,
  ) {
    const userId = req.user?.id;
    const data = await this.oqcService.updateResult(id, dto, userId, organizationId);
    return ResponseUtil.success(data, 'OQC result updated');
  }
}
