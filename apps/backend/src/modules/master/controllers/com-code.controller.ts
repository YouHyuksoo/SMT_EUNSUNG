import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiParam, ApiResponse, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ComCodeQueryDto, CreateComCodeDto, UpdateComCodeDto } from '../dto/com-code.dto';
import { ComCodeService } from '../services/com-code.service';

@ApiTags('Master - ComCode')
@Controller('master/com-codes')
export class ComCodeController {
  constructor(private readonly comCodeService: ComCodeService) {}

  @Get('all-active')
  @ApiOperation({ summary: 'Get all active common codes grouped by groupCode' })
  @ApiResponse({ status: 200, description: 'OK' })
  async findAllActive(@OrganizationId() organizationId?: number) {
    const data = await this.comCodeService.findAllActive(company, plant);
    return ResponseUtil.success(data);
  }

  @Get('groups')
  @ApiOperation({ summary: 'Get all code groups' })
  @ApiResponse({ status: 200, description: 'OK' })
  async findAllGroups(@OrganizationId() organizationId?: number) {
    const data = await this.comCodeService.findAllGroups(company, plant);
    return ResponseUtil.success(data);
  }

  @Get('groups/:groupCode')
  @ApiOperation({ summary: 'Get codes by groupCode' })
  @ApiParam({ name: 'groupCode' })
  @ApiResponse({ status: 200, description: 'OK' })
  async findByGroupCode(
    @Param('groupCode') groupCode: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.comCodeService.findByGroupCode(groupCode, organizationId);
    return ResponseUtil.success(data);
  }

  @Get()
  @ApiOperation({ summary: 'Get common codes' })
  @ApiResponse({ status: 200, description: 'OK' })
  async findAll(
    @Query() query: ComCodeQueryDto,
    @OrganizationId() organizationId?: number,
  ) {
    const result = await this.comCodeService.findAll(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get one common code by id' })
  @ApiParam({ name: 'id' })
  @ApiResponse({ status: 200, description: 'OK' })
  @ApiResponse({ status: 404, description: 'Not found' })
  async findById(@Param('id') id: string, @OrganizationId() organizationId?: number) {
    const data = await this.comCodeService.findById(id, organizationId);
    return ResponseUtil.success(data);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create common code' })
  @ApiResponse({ status: 201, description: 'Created' })
  async create(
    @Body() dto: CreateComCodeDto,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.comCodeService.create(dto, organizationId);
    return ResponseUtil.success(data, 'Common code created');
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update common code' })
  @ApiParam({ name: 'id' })
  @ApiResponse({ status: 200, description: 'OK' })
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateComCodeDto,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.comCodeService.update(id, dto, organizationId);
    return ResponseUtil.success(data, 'Common code updated');
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete common code' })
  @ApiParam({ name: 'id' })
  @ApiResponse({ status: 200, description: 'OK' })
  async delete(@Param('id') id: string, @OrganizationId() organizationId?: number) {
    await this.comCodeService.delete(id, organizationId);
    return ResponseUtil.success(null, 'Common code deleted');
  }

  @Delete('groups/:groupCode')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete common codes by groupCode' })
  @ApiParam({ name: 'groupCode' })
  @ApiResponse({ status: 200, description: 'OK' })
  async deleteByGroupCode(
    @Param('groupCode') groupCode: string,
    @OrganizationId() organizationId?: number,
  ) {
    const result = await this.comCodeService.deleteByGroupCode(groupCode, organizationId);
    return ResponseUtil.success(result, `${result.count} codes deleted`);
  }
}
