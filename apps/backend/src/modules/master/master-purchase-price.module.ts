import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PurchaseUnitPrice } from '../../entities/purchase-unit-price.entity';
import { SupplierMaster } from '../../entities/supplier-master.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PurchasePriceController } from './controllers/purchase-price.controller';
import { PurchasePriceService } from './services/purchase-price.service';

@Module({
  imports: [TypeOrmModule.forFeature([PurchaseUnitPrice, SupplierMaster, IsysUser, IsysOrganization])],
  controllers: [PurchasePriceController],
  providers: [PurchasePriceService, JwtAuthGuard],
})
export class MasterPurchasePriceModule {}
