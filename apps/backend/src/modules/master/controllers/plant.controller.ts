/**
 * @file src/modules/master/controllers/plant.controller.ts
 * @description PLANTS 공장/작업장/라인/CELL CRUD API 컨트롤러.
 */

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
import { ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { PLANT_TYPE_VALUES } from '@smt/shared';
import { Company, Plant } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { CreatePlantDto, PlantQueryDto, UpdatePlantDto } from '../dto/plant.dto';
import { PlantService } from '../services/plant.service';

@ApiTags('기준정보 - 공장/라인')
@UseGuards(JwtAuthGuard)
@Controller('master/plants')
export class PlantController {
  constructor(private readonly plantService: PlantService) {}

  @Get('hierarchy')
  @ApiOperation({ summary: '계층 트리 조회' })
  async findHierarchy(
    @Query('plantCode') plantCode: string | undefined,
    @Company() company: string,
    @Plant() plantCd: string,
  ) {
    const data = await this.plantService.findHierarchy(plantCode, company, plantCd);
    return ResponseUtil.success(data);
  }

  @Get('types/:type')
  @ApiOperation({ summary: '타입별 목록 조회' })
  @ApiParam({ name: 'type', enum: PLANT_TYPE_VALUES })
  async findByType(
    @Param('type') type: string,
    @Company() company: string,
    @Plant() plantCd: string,
  ) {
    const data = await this.plantService.findByType(type, company, plantCd);
    return ResponseUtil.success(data);
  }

  @Get()
  @ApiOperation({ summary: '목록 조회' })
  async findAll(
    @Query() query: PlantQueryDto,
    @Company() company: string,
    @Plant() plantCd: string,
  ) {
    const result = await this.plantService.findAll(query, company, plantCd);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get(':plantCode/:shopCode/:lineCode/:cellCode')
  @ApiOperation({ summary: '복합키 상세 조회' })
  @ApiParam({ name: 'plantCode' })
  @ApiParam({ name: 'shopCode' })
  @ApiParam({ name: 'lineCode' })
  @ApiParam({ name: 'cellCode' })
  async findById(
    @Param('plantCode') plantCode: string,
    @Param('shopCode') shopCode: string,
    @Param('lineCode') lineCode: string,
    @Param('cellCode') cellCode: string,
    @Company() company: string,
    @Plant() plantCd: string,
  ) {
    const data = await this.plantService.findById(plantCode, shopCode, lineCode, cellCode, company, plantCd);
    return ResponseUtil.success(data);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: '생성' })
  async create(
    @Body() dto: CreatePlantDto,
    @Company() company: string,
    @Plant() plantCd: string,
  ) {
    const data = await this.plantService.create(dto, company, plantCd);
    return ResponseUtil.success(data, '공장/라인이 생성되었습니다.');
  }

  @Put(':plantCode/:shopCode/:lineCode/:cellCode')
  @ApiOperation({ summary: '복합키 수정' })
  async update(
    @Param('plantCode') plantCode: string,
    @Param('shopCode') shopCode: string,
    @Param('lineCode') lineCode: string,
    @Param('cellCode') cellCode: string,
    @Body() dto: UpdatePlantDto,
    @Company() company: string,
    @Plant() plantCd: string,
  ) {
    const data = await this.plantService.update(
      plantCode,
      dto,
      shopCode,
      lineCode,
      cellCode,
      company,
      plantCd,
    );
    return ResponseUtil.success(data, '공장/라인이 수정되었습니다.');
  }

  @Delete(':plantCode/:shopCode/:lineCode/:cellCode')
  @ApiOperation({ summary: '복합키 삭제' })
  async delete(
    @Param('plantCode') plantCode: string,
    @Param('shopCode') shopCode: string,
    @Param('lineCode') lineCode: string,
    @Param('cellCode') cellCode: string,
    @Company() company: string,
    @Plant() plantCd: string,
  ) {
    await this.plantService.delete(plantCode, shopCode, lineCode, cellCode, company, plantCd);
    return ResponseUtil.success(null, '공장/라인이 삭제되었습니다.');
  }
}
