import { Module } from '@nestjs/common';
import { WorkstageInventoryController } from './controllers/workstage-inventory.controller';
import { WorkstageInventoryService } from './services/workstage-inventory.service';

@Module({
  controllers: [WorkstageInventoryController],
  providers: [WorkstageInventoryService],
})
export class MaterialWorkstageInventoryModule {}
