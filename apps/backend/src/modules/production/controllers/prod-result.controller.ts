import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  HttpCode,
  HttpStatus,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiQuery,
  ApiBody,
} from '@nestjs/swagger';
import { ProdResultService } from '../services/prod-result.service';
import {
  CreateProdResultDto,
  UpdateProdResultDto,
  ProdResultQueryDto,
  ProdOrderResultQueryDto,
  CompleteProdResultDto,
} from '../dto/prod-result.dto';
import { ResponseUtil } from '../../../common/dto/response.dto';

@ApiTags('Production - Prod Results')
@Controller('production/prod-results')
export class ProdResultController {
  constructor(private readonly prodResultService: ProdResultService) {}

  @Get()
  @ApiOperation({ summary: 'List production results' })
  @ApiResponse({ status: 200, description: 'Success' })
  async findAll(@Query() query: ProdResultQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.prodResultService.findAll(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('job-order/:orderNo')
  @ApiOperation({ summary: 'List by job order' })
  @ApiParam({ name: 'orderNo', description: 'Job order no' })
  @ApiResponse({ status: 200, description: 'Success' })
  async findByJobOrderId(@Param('orderNo') orderNo: string, @OrganizationId() organizationId: number) {
    const data = await this.prodResultService.findByJobOrderId(orderNo, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('summary/by-job-order')
  @ApiOperation({ summary: 'List job orders with production result summary' })
  @ApiResponse({ status: 200, description: 'Success' })
  async getSummaryByJobOrderList(
    @Query() query: ProdOrderResultQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.prodResultService.getSummaryByJobOrderList(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get(':resultNo')
  @ApiOperation({ summary: 'Get one result' })
  @ApiParam({ name: 'resultNo', description: 'Result no' })
  @ApiResponse({ status: 200, description: 'Success' })
  @ApiResponse({ status: 404, description: 'Not found' })
  async findById(@Param('resultNo') resultNo: string, @OrganizationId() organizationId: number) {
    const data = await this.prodResultService.findById(resultNo, organizationId);
    return ResponseUtil.success(data);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create production result' })
  @ApiResponse({ status: 201, description: 'Created' })
  async create(@Body() dto: CreateProdResultDto, @OrganizationId() organizationId: number) {
    const data = await this.prodResultService.create(dto, organizationId);
    return ResponseUtil.success(data, 'Created');
  }

  @Put(':resultNo')
  @ApiOperation({ summary: 'Update production result' })
  @ApiParam({ name: 'resultNo', description: 'Result no' })
  @ApiResponse({ status: 200, description: 'Updated' })
  async update(
    @Param('resultNo') resultNo: string,
    @Body() dto: UpdateProdResultDto,
    @OrganizationId() organizationId: number,
  ) {
    const data = await this.prodResultService.update(resultNo, dto, organizationId);
    return ResponseUtil.success(data, 'Updated');
  }

  @Delete(':resultNo')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete production result' })
  @ApiParam({ name: 'resultNo', description: 'Result no' })
  @ApiResponse({ status: 200, description: 'Deleted' })
  async delete(@Param('resultNo') resultNo: string, @OrganizationId() organizationId: number) {
    await this.prodResultService.delete(resultNo, organizationId);
    return ResponseUtil.success(null, 'Deleted');
  }

  @Post(':resultNo/complete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Complete production result' })
  @ApiParam({ name: 'resultNo', description: 'Result no' })
  @ApiResponse({ status: 200, description: 'Completed' })
  async complete(
    @Param('resultNo') resultNo: string,
    @Body() dto: CompleteProdResultDto,
    @OrganizationId() organizationId: number,
  ) {
    const data = await this.prodResultService.complete(resultNo, dto, organizationId);
    return ResponseUtil.success(data, 'Completed');
  }

  @Post(':resultNo/cancel')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Cancel production result' })
  @ApiParam({ name: 'resultNo', description: 'Result no' })
  @ApiBody({ schema: { type: 'object', properties: { remark: { type: 'string', description: 'Cancel reason' } } } })
  @ApiResponse({ status: 200, description: 'Canceled' })
  async cancel(
    @Param('resultNo') resultNo: string,
    @Body('remark') remark?: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.prodResultService.cancel(resultNo, remark, organizationId);
    return ResponseUtil.success(data, 'Canceled');
  }

  @Get('summary/job-order/:orderNo')
  @ApiOperation({ summary: 'Summary by job order' })
  @ApiParam({ name: 'orderNo', description: 'Job order no' })
  @ApiResponse({ status: 200, description: 'Success' })
  async getSummaryByJobOrder(@Param('orderNo') orderNo: string, @OrganizationId() organizationId: number) {
    const data = await this.prodResultService.getSummaryByJobOrder(orderNo, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('summary/equip/:equipCode')
  @ApiOperation({ summary: 'Summary by equipment' })
  @ApiParam({ name: 'equipCode', description: 'Equipment code' })
  @ApiQuery({ name: 'fromDate', required: false, description: 'YYYY-MM-DD' })
  @ApiQuery({ name: 'toDate', required: false, description: 'YYYY-MM-DD' })
  @ApiResponse({ status: 200, description: 'Success' })
  async getSummaryByEquip(
    @Param('equipCode') equipCode: string,
    @Query('fromDate') fromDate?: string,
    @Query('toDate') toDate?: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.prodResultService.getSummaryByEquip(equipCode, fromDate, toDate, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('summary/worker/:workerId')
  @ApiOperation({ summary: 'Summary by worker' })
  @ApiParam({ name: 'workerId', description: 'Worker id' })
  @ApiQuery({ name: 'fromDate', required: false, description: 'YYYY-MM-DD' })
  @ApiQuery({ name: 'toDate', required: false, description: 'YYYY-MM-DD' })
  @ApiResponse({ status: 200, description: 'Success' })
  async getSummaryByWorker(
    @Param('workerId') workerId: string,
    @Query('fromDate') fromDate?: string,
    @Query('toDate') toDate?: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.prodResultService.getSummaryByWorker(workerId, fromDate, toDate, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('summary/daily')
  @ApiOperation({ summary: 'Daily summary' })
  @ApiQuery({ name: 'fromDate', required: true, description: 'YYYY-MM-DD' })
  @ApiQuery({ name: 'toDate', required: true, description: 'YYYY-MM-DD' })
  @ApiResponse({ status: 200, description: 'Success' })
  async getDailySummary(
    @Query('fromDate') fromDate: string,
    @Query('toDate') toDate: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.prodResultService.getDailySummary(fromDate, toDate, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('summary/by-product')
  @ApiOperation({ summary: 'Summary by product' })
  @ApiQuery({ name: 'fromDate', required: false, description: 'YYYY-MM-DD' })
  @ApiQuery({ name: 'toDate', required: false, description: 'YYYY-MM-DD' })
  @ApiQuery({ name: 'search', required: false, description: 'Search keyword' })
  @ApiResponse({ status: 200, description: 'Success' })
  async getSummaryByProduct(
    @Query('fromDate') fromDate?: string,
    @Query('toDate') toDate?: string,
    @Query('search') search?: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.prodResultService.getSummaryByProduct(fromDate, toDate, search, organizationId);
    return ResponseUtil.success(data);
  }
}
