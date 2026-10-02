import { Module } from '@nestjs/common';
import { MfsBomController } from './controllers/mfs-bom.controller';
import { RawBomController } from './controllers/raw-bom.controller';
import { ReplaceBomController } from './controllers/replace-bom.controller';
import { MfsBomService } from './services/mfs-bom.service';
import { RawBomService } from './services/raw-bom.service';
import { ReplaceBomService } from './services/replace-bom.service';

@Module({
  controllers: [ReplaceBomController, RawBomController, MfsBomController],
  providers: [ReplaceBomService, RawBomService, MfsBomService],
})
export class BomModule {}
