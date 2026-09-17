import { Module } from '@nestjs/common';
import { CurrentInventoryController } from './controllers/current-inventory.controller';
import { CurrentInventoryService } from './services/current-inventory.service';

@Module({
  controllers: [CurrentInventoryController],
  providers: [CurrentInventoryService],
})
export class MaterialCurrentInventoryModule {}
