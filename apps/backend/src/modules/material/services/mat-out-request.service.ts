import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere } from 'typeorm';
import { StockTransaction } from '../../../entities/stock-transaction.entity';
import { MatStock } from '../../../entities/mat-stock.entity';
import { MatLot } from '../../../entities/mat-lot.entity';
import { NumberingService } from '../../../shared/numbering.service';
import { TransactionService } from '../../../shared/transaction.service';

@Injectable()
export class MatOutRequestService {
  constructor(
    @InjectRepository(StockTransaction)
    private readonly stockTxRepo: Repository<StockTransaction>,
    @InjectRepository(MatStock)
    private readonly matStockRepo: Repository<MatStock>,
    @InjectRepository(MatLot)
    private readonly matLotRepo: Repository<MatLot>,
    private readonly tx: TransactionService,
    private readonly numbering: NumberingService,
  ) {}

  private tenantWhere(organizationId?: number | null) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  private assertSameTenant(
    context: string,
    row: { organizationId?: number | null },
    organizationId?: number | null,
  ) {
    if (organizationId != null && row.organizationId !== organizationId) {
      throw new BadRequestException(`${context} 조직 정보가 일치하지 않습니다. request=${organizationId}, row=${row.organizationId ?? 'NULL'}`);
    }
  }

  async findPending(query: { page?: number; limit?: number }, organizationId?: number) {
    const { page = 1, limit = 20 } = query;
    const where: FindOptionsWhere<StockTransaction> = {
      status: 'PENDING_APPROVAL',
      ...(organizationId != null && { organizationId }),
    };

    const [data, total] = await this.stockTxRepo.findAndCount({
      where,
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: 'DESC' },
    });

    return { data, total, page, limit };
  }

  async create(dto: { matUid: string; itemCode: string; qty: number; outType: string; reason?: string; workerId?: string; organizationId?: number }) {
    const lot = await this.matLotRepo.findOne({
      where: {
        matUid: dto.matUid,
        ...(dto.organizationId != null ? { organizationId: dto.organizationId } : {}),
      },
    });
    if (lot?.status === 'HOLD') {
      throw new BadRequestException(`Cannot create material-out request for HOLD lot: ${dto.matUid}`);
    }

    const stock = await this.matStockRepo.findOne({
      where: {
        matUid: dto.matUid,
        itemCode: dto.itemCode,
        ...(dto.organizationId != null ? { organizationId: dto.organizationId } : {}),
      },
    });

    if (!stock) throw new NotFoundException('Material stock not found.');

    const availableQty = stock.availableQty ?? Math.max(0, stock.qty - (stock.reservedQty ?? 0));
    if (availableQty < dto.qty) {
      throw new BadRequestException('Insufficient available stock.');
    }

    return this.tx.run(async (queryRunner) => {
      const transNo = await this.numbering.nextInTx(queryRunner, 'STOCK_TX');

      const tx = queryRunner.manager.create(StockTransaction, {
        transNo,
        transType: 'MAT_OUT',
        fromWarehouseId: stock.warehouseCode,
        itemCode: dto.itemCode,
        matUid: dto.matUid,
        qty: -dto.qty,
        remark: `Material-out request (${dto.outType}): ${dto.reason || ''}`,
        workerId: dto.workerId,
        refType: dto.outType,
        status: 'PENDING_APPROVAL',
        organizationId: dto.organizationId,
      });
      await queryRunner.manager.save(tx);

      await queryRunner.manager.update(
        MatStock,
        {
          warehouseCode: stock.warehouseCode,
          itemCode: dto.itemCode,
          matUid: dto.matUid,
          ...(dto.organizationId != null ? { organizationId: dto.organizationId } : {}),
        },
        {
          reservedQty: (stock.reservedQty ?? 0) + dto.qty,
          availableQty: Math.max(0, (stock.availableQty ?? stock.qty - (stock.reservedQty ?? 0)) - dto.qty),
        },
      );

      return tx;
    });
  }

  async approve(transNo: string, approverId: string, organizationId?: number) {
    const tx = await this.stockTxRepo.findOne({ where: { transNo, ...this.tenantWhere(organizationId) } });
    if (!tx) throw new NotFoundException('Stock transaction not found.');
    this.assertSameTenant('자재출고요청 거래', tx, organizationId);
    if (tx.status !== 'PENDING_APPROVAL') throw new BadRequestException('Transaction is not pending approval.');

    const txTenantWhere = this.tenantWhere(tx.organizationId);

    if (tx.matUid) {
      const lot = await this.matLotRepo.findOne({ where: { matUid: tx.matUid, ...txTenantWhere } });
      if (lot?.status === 'HOLD') {
        throw new BadRequestException(`Cannot approve material-out for HOLD lot: ${tx.matUid}`);
      }
    }

    const stock = await this.matStockRepo.findOne({
      where: {
        ...(tx.fromWarehouseId ? { warehouseCode: tx.fromWarehouseId } : {}),
        ...(tx.matUid ? { matUid: tx.matUid } : {}),
        itemCode: tx.itemCode,
        ...txTenantWhere,
      },
    });
    if (!stock) throw new NotFoundException('Material stock not found.');

    const absQty = Math.abs(tx.qty);
    if (stock.qty < absQty) {
      throw new BadRequestException(`Insufficient physical stock. Current qty: ${stock.qty}`);
    }

    await this.matStockRepo.update(
      {
        warehouseCode: stock.warehouseCode,
        itemCode: tx.itemCode,
        ...(tx.matUid ? { matUid: tx.matUid } : {}),
        ...txTenantWhere,
      },
      {
        qty: stock.qty - absQty,
        reservedQty: Math.max(0, (stock.reservedQty ?? 0) - absQty),
        availableQty: Math.max(0, stock.qty - absQty - Math.max(0, (stock.reservedQty ?? 0) - absQty)),
      },
    );

    await this.stockTxRepo.update(
      { transNo, ...txTenantWhere },
      {
        status: 'DONE',
        approverId,
        approvedAt: new Date(),
      },
    );

    return { transNo, status: 'DONE' };
  }

  async reject(transNo: string, approverId: string, organizationId?: number) {
    const tx = await this.stockTxRepo.findOne({ where: { transNo, ...this.tenantWhere(organizationId) } });
    if (!tx) throw new NotFoundException('Stock transaction not found.');
    this.assertSameTenant('자재출고요청 거래', tx, organizationId);
    if (tx.status !== 'PENDING_APPROVAL') throw new BadRequestException('Transaction is not pending approval.');

    await this.unlockStock(tx);
    await this.stockTxRepo.update(
      { transNo, ...this.tenantWhere(tx.organizationId) },
      {
        status: 'REJECTED',
        approverId,
        approvedAt: new Date(),
      },
    );

    return { transNo, status: 'REJECTED' };
  }

  async cancel(transNo: string, organizationId?: number) {
    const tx = await this.stockTxRepo.findOne({ where: { transNo, ...this.tenantWhere(organizationId) } });
    if (!tx) throw new NotFoundException('Stock transaction not found.');
    this.assertSameTenant('자재출고요청 거래', tx, organizationId);
    if (tx.status !== 'PENDING_APPROVAL') {
      throw new BadRequestException('Only pending approval transaction can be canceled.');
    }

    await this.unlockStock(tx);
    await this.stockTxRepo.update({ transNo, ...this.tenantWhere(tx.organizationId) }, { status: 'CANCELED' });
    return { transNo, status: 'CANCELED' };
  }

  private async unlockStock(tx: StockTransaction) {
    if (!tx.matUid) return;

    const stock = await this.matStockRepo.findOne({
      where: {
        ...(tx.fromWarehouseId ? { warehouseCode: tx.fromWarehouseId } : {}),
        matUid: tx.matUid,
        itemCode: tx.itemCode,
        ...this.tenantWhere(tx.organizationId),
      },
    });

    if (!stock) return;

    const absQty = Math.abs(tx.qty);
    await this.matStockRepo.update(
      {
        warehouseCode: stock.warehouseCode,
        itemCode: tx.itemCode,
        matUid: tx.matUid,
        ...this.tenantWhere(tx.organizationId),
      },
      {
        reservedQty: Math.max(0, (stock.reservedQty ?? 0) - absQty),
        availableQty: stock.qty - Math.max(0, (stock.reservedQty ?? 0) - absQty),
      },
    );
  }
}
