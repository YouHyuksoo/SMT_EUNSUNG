import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductSalePrice } from '../../entities/product-sale-price.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { SalePriceController } from './controllers/sale-price.controller';
import { SalePriceService } from './services/sale-price.service';

@Module({ imports: [TypeOrmModule.forFeature([ProductSalePrice, IsysUser, IsysOrganization])], controllers: [SalePriceController], providers: [SalePriceService, JwtAuthGuard] })
export class MasterSalePriceModule {}
