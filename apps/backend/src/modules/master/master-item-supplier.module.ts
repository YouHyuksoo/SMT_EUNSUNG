import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ItemSupplier } from '../../entities/item-supplier.entity';
import { ItemSupplierController } from './controllers/item-supplier.controller';
import { ItemSupplierService } from './services/item-supplier.service';
@Module({ imports: [TypeOrmModule.forFeature([ItemSupplier])], controllers: [ItemSupplierController], providers: [ItemSupplierService] })
export class MasterItemSupplierModule {}
