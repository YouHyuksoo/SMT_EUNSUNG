import { Module } from '@nestjs/common';
import { ApplyItemController } from './design.controllers';
import { ApplyItemService } from './apply-item.service';

@Module({
  controllers: [ApplyItemController],
  providers: [ApplyItemService],
})
export class DesignModule {}
