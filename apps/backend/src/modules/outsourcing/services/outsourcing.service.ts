/**
 * @file src/modules/outsourcing/services/outsourcing.service.ts
 * @description 외주관리 비즈니스 로직 서비스 - TypeORM Repository 패턴
 */

import {
  Injectable,
  NotFoundException,
  ConflictException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import { SubconOrder } from '../../../entities/subcon-order.entity';
import { SubconDelivery } from '../../../entities/subcon-delivery.entity';
import { SubconReceive } from '../../../entities/subcon-receive.entity';
import { VendorMaster } from '../../../entities/vendor-master.entity';
import { NumberingService } from '../../../shared/numbering.service';
import {
  CreateVendorDto,
  UpdateVendorDto,
  VendorQueryDto,
  CreateSubconOrderDto,
  UpdateSubconOrderDto,
  SubconOrderQueryDto,
  CreateSubconDeliveryDto,
  CreateSubconReceiveDto,
} from '../dto/outsourcing.dto';
import { parseDateStart } from '../../../shared/date.util';

type VendorStockSummary = {
  vendorCode: string;
  vendorName: string;
  deliveredQty: number;
  receivedQty: number;
  stockQty: number;
};

@Injectable()
export class OutsourcingService {
  private readonly logger = new Logger(OutsourcingService.name);

  constructor(
    @InjectRepository(SubconOrder)
    private readonly subconOrderRepository: Repository<SubconOrder>,
    @InjectRepository(SubconDelivery)
    private readonly subconDeliveryRepository: Repository<SubconDelivery>,
    @InjectRepository(SubconReceive)
    private readonly subconReceiveRepository: Repository<SubconReceive>,
    @InjectRepository(VendorMaster)
    private readonly vendorMasterRepository: Repository<VendorMaster>,
    private readonly tx: TransactionService,
    private readonly numbering: NumberingService,
  ) {}

  private tenantWhere(organizationId?: number) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  private vendorWithClientId(vendor: VendorMaster) {
    return { ...vendor, id: vendor.vendorCode };
  }

  // ============================================================================
  // 외주처 마스터
  // ============================================================================

  async findAllVendors(query: VendorQueryDto, organizationId?: number) {
    const { page = 1, limit = 10, vendorType, search, useYn } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.vendorMasterRepository
      .createQueryBuilder('vm')

    if (organizationId != null) {
      queryBuilder.andWhere('vm.organizationId = :organizationId', { organizationId });
    }
    if (vendorType) {
      queryBuilder.andWhere('vm.vendorType = :vendorType', { vendorType });
    }

    if (useYn) {
      queryBuilder.andWhere('vm.useYn = :useYn', { useYn });
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(vm.vendorCode LIKE :search OR vm.vendorName LIKE :searchRaw)',
        { search: `%${upper}%`, searchRaw: `%${search}%` },
      );
    }

    const [data, total] = await Promise.all([
      queryBuilder
        .orderBy('vm.createdAt', 'DESC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    return { data: data.map((vendor) => this.vendorWithClientId(vendor)), total, page, limit };
  }

  async findVendorById(vendorCode: string, organizationId?: number) {
    const vendor = await this.vendorMasterRepository.findOne({
      where: { vendorCode, ...this.tenantWhere(organizationId) },
    });

    if (!vendor) {
      throw new NotFoundException(`외주처를 찾을 수 없습니다: ${vendorCode}`);
    }

    const subconOrders = await this.subconOrderRepository.find({
      where: { vendorCode, ...this.tenantWhere(organizationId) },
      order: { createdAt: 'DESC' },
      take: 10,
    });

    return { ...this.vendorWithClientId(vendor), subconOrders };
  }

  async createVendor(dto: CreateVendorDto, organizationId?: number) {
    const existing = await this.vendorMasterRepository.findOne({
      where: { vendorCode: dto.vendorCode, ...this.tenantWhere(organizationId) },
    });

    if (existing) {
      throw new ConflictException(`이미 존재하는 외주처 코드입니다: ${dto.vendorCode}`);
    }

    const vendor = this.vendorMasterRepository.create({
      vendorCode: dto.vendorCode,
      vendorName: dto.vendorName,
      bizNo: dto.bizNo ?? null,
      ceoName: dto.ceoName ?? null,
      address: dto.address ?? null,
      tel: dto.tel ?? null,
      fax: dto.fax ?? null,
      email: dto.email ?? null,
      contactPerson: dto.contactPerson ?? null,
      vendorType: dto.vendorType ?? null,
      organizationId: organizationId ?? null,
    });
    return this.vendorMasterRepository.save(vendor);
  }

  async updateVendor(vendorCode: string, dto: UpdateVendorDto, organizationId?: number) {
    await this.findVendorById(vendorCode, organizationId);

    const updateData: Partial<Pick<
      VendorMaster,
      | 'vendorName'
      | 'bizNo'
      | 'ceoName'
      | 'address'
      | 'tel'
      | 'fax'
      | 'email'
      | 'contactPerson'
      | 'vendorType'
      | 'useYn'
    >> = {
      ...(dto.vendorName !== undefined ? { vendorName: dto.vendorName } : {}),
      ...(dto.bizNo !== undefined ? { bizNo: dto.bizNo } : {}),
      ...(dto.ceoName !== undefined ? { ceoName: dto.ceoName } : {}),
      ...(dto.address !== undefined ? { address: dto.address } : {}),
      ...(dto.tel !== undefined ? { tel: dto.tel } : {}),
      ...(dto.fax !== undefined ? { fax: dto.fax } : {}),
      ...(dto.email !== undefined ? { email: dto.email } : {}),
      ...(dto.contactPerson !== undefined ? { contactPerson: dto.contactPerson } : {}),
      ...(dto.vendorType !== undefined ? { vendorType: dto.vendorType } : {}),
      ...(dto.useYn !== undefined ? { useYn: dto.useYn } : {}),
    };

    await this.vendorMasterRepository.update({ vendorCode, ...this.tenantWhere(organizationId) }, updateData);
    return this.findVendorById(vendorCode, organizationId);
  }

  async deleteVendor(vendorCode: string, organizationId?: number) {
    await this.findVendorById(vendorCode, organizationId);

    await this.vendorMasterRepository.delete({ vendorCode, ...this.tenantWhere(organizationId) });
    return { vendorCode };
  }

  // ============================================================================
  // 외주발주
  // ============================================================================

  async findAllOrders(query: SubconOrderQueryDto, organizationId?: number) {
    const { page = 1, limit = 10, vendorCode, status, search, fromDate, toDate } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.subconOrderRepository
      .createQueryBuilder('so')
      .leftJoinAndSelect(
        VendorMaster,
        'vm',
        'vm.VENDOR_CODE = so.VENDOR_CODE AND vm.ORGANIZATION_ID = so.ORGANIZATION_ID',
      )

    if (organizationId != null) {
      queryBuilder.andWhere('so.organizationId = :organizationId', { organizationId });
    }
    if (vendorCode) {
      queryBuilder.andWhere('so.vendorCode = :vendorCode', { vendorCode });
    }

    if (status) {
      queryBuilder.andWhere('so.status = :status', { status });
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(so.orderNo LIKE :search OR so.itemCode LIKE :search OR so.itemName LIKE :searchRaw)',
        { search: `%${upper}%`, searchRaw: `%${search}%` },
      );
    }

    if (fromDate) {
      queryBuilder.andWhere("so.orderDate >= TO_DATE(:fromDate, 'YYYY-MM-DD')", { fromDate });
    }
    if (toDate) {
      queryBuilder.andWhere("so.orderDate < TO_DATE(:toDate, 'YYYY-MM-DD') + 1", { toDate });
    }

    const [orders, total] = await Promise.all([
      queryBuilder
        .orderBy('so.createdAt', 'DESC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    // IN 배치 선조회 + GROUP BY 집계로 N+1 방지
    const vendorCodes = [...new Set(orders.map((o) => o.vendorCode).filter(Boolean))] as const;
    const orderNos = orders.map((o) => o.orderNo);

    const [vendors, deliveryCounts, receiveCounts] = await Promise.all([
      vendorCodes.length > 0
        ? this.vendorMasterRepository.find({
            where: { vendorCode: In(vendorCodes), ...this.tenantWhere(organizationId) },
            select: ['vendorCode', 'vendorName'],
          })
        : Promise.resolve([]),
      orderNos.length > 0
        ? this.subconDeliveryRepository
            .createQueryBuilder('d')
            .select('d.orderNo', 'orderNo')
            .addSelect('COUNT(*)', 'cnt')
            .where('d.orderNo IN (:...orderNos)', { orderNos })
            .andWhere(organizationId != null ? 'd.organizationId = :organizationId' : '1=1', organizationId != null ? { organizationId } : {})
            .groupBy('d.orderNo')
            .getRawMany<{ orderNo: string; cnt: string }>()
        : Promise.resolve([]),
      orderNos.length > 0
        ? this.subconReceiveRepository
            .createQueryBuilder('r')
            .select('r.orderNo', 'orderNo')
            .addSelect('COUNT(*)', 'cnt')
            .where('r.orderNo IN (:...orderNos)', { orderNos })
            .andWhere(organizationId != null ? 'r.organizationId = :organizationId' : '1=1', organizationId != null ? { organizationId } : {})
            .groupBy('r.orderNo')
            .getRawMany<{ orderNo: string; cnt: string }>()
        : Promise.resolve([]),
    ]);

    const vendorMap = new Map(vendors.map((v) => [v.vendorCode, v] as const));
    const deliveryMap = new Map(deliveryCounts.map((d) => [d.orderNo, Number(d.cnt)] as const));
    const receiveMap = new Map(receiveCounts.map((r) => [r.orderNo, Number(r.cnt)] as const));

    const data = orders.map((order) => ({
      ...order,
      vendor: vendorMap.get(order.vendorCode) ?? null,
      _count: {
        deliveries: deliveryMap.get(order.orderNo) ?? 0,
        receives: receiveMap.get(order.orderNo) ?? 0,
      },
    }));

    return { data, total, page, limit };
  }

  async findOrderById(orderNo: string, organizationId?: number) {
    const order = await this.subconOrderRepository.findOne({
      where: { orderNo, ...this.tenantWhere(organizationId) },
    });

    if (!order) {
      throw new NotFoundException(`외주발주를 찾을 수 없습니다: ${orderNo}`);
    }

    const vendor = await this.vendorMasterRepository.findOne({
      where: { vendorCode: order.vendorCode, ...this.tenantWhere(organizationId) },
    });

    const deliveries = await this.subconDeliveryRepository.find({
      where: { orderNo, ...this.tenantWhere(organizationId) },
      order: { createdAt: 'DESC' },
    });

    const receives = await this.subconReceiveRepository.find({
      where: { orderNo, ...this.tenantWhere(organizationId) },
      order: { createdAt: 'DESC' },
    });

    return { ...order, vendor, deliveries, receives };
  }

  async createOrder(dto: CreateSubconOrderDto, organizationId?: number) {
    // 통합 채번 서비스로 발주번호 생성
    const orderNo = await this.numbering.nextSubconNo();

    const order = this.subconOrderRepository.create({
      orderNo,
      vendorCode: dto.vendorCode,
      itemCode: dto.itemCode,
      itemName: dto.itemName,
      jobOrderNo: dto.jobOrderNo ?? null,
      routingCode: dto.routingCode ?? null,
      processSeq: dto.processSeq ?? null,
      processCode: dto.processCode ?? null,
      orderQty: dto.orderQty,
      unitPrice: dto.unitPrice,
      orderDate: dto.orderDate ? parseDateStart(dto.orderDate) : new Date(),
      dueDate: parseDateStart(dto.dueDate),
      remark: dto.remark,
      ...this.tenantWhere(organizationId),
    });

    return this.subconOrderRepository.save(order);
  }

  async updateOrder(orderNo: string, dto: UpdateSubconOrderDto, organizationId?: number) {
    await this.findOrderById(orderNo, organizationId);

    const updateData: Partial<SubconOrder> = {};
    if (dto.itemCode !== undefined) updateData.itemCode = dto.itemCode;
    if (dto.itemName !== undefined) updateData.itemName = dto.itemName;
    if (dto.jobOrderNo !== undefined) updateData.jobOrderNo = dto.jobOrderNo || null;
    if (dto.routingCode !== undefined) updateData.routingCode = dto.routingCode || null;
    if (dto.processSeq !== undefined) updateData.processSeq = dto.processSeq ?? null;
    if (dto.processCode !== undefined) updateData.processCode = dto.processCode || null;
    if (dto.orderQty !== undefined) updateData.orderQty = dto.orderQty;
    if (dto.unitPrice !== undefined) updateData.unitPrice = dto.unitPrice;
    if (dto.orderDate !== undefined) updateData.orderDate = parseDateStart(dto.orderDate);
    if (dto.dueDate !== undefined) updateData.dueDate = parseDateStart(dto.dueDate);
    if (dto.status !== undefined) updateData.status = dto.status;
    if (dto.remark !== undefined) updateData.remark = dto.remark;

    await this.subconOrderRepository.update({ orderNo, ...this.tenantWhere(organizationId) }, updateData);
    return this.findOrderById(orderNo, organizationId);
  }

  async cancelOrder(orderNo: string, organizationId?: number) {
    const order = await this.findOrderById(orderNo, organizationId);

    if (order.status !== 'ORDERED') {
      throw new BadRequestException('발주 상태에서만 취소할 수 있습니다.');
    }

    await this.subconOrderRepository.update(
      { orderNo, ...this.tenantWhere(organizationId) },
      { status: 'CANCELED' },
    );
    return this.findOrderById(orderNo, organizationId);
  }

  // ============================================================================
  // 외주 출고
  // ============================================================================

  async createDelivery(dto: CreateSubconDeliveryDto, organizationId?: number) {
    const order = await this.findOrderById(dto.orderId, organizationId);

    // 출고 가능 수량 확인
    const remainQty = order.orderQty - order.deliveredQty;
    if (dto.qty > remainQty) {
      throw new BadRequestException(`출고 가능 수량(${remainQty})을 초과했습니다.`);
    }

    // 출고번호 생성
    const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const count = await this.subconDeliveryRepository.count({
      where: {
        deliveryNo: `SCD${today}%`,
      },
    });
    const deliveryNo = `SCD${today}${String(count + 1).padStart(4, '0')}`;

    return this.tx.run(async (queryRunner) => {
      const delivery = queryRunner.manager.create(SubconDelivery, {
        orderNo: dto.orderId,
        deliveryNo,
        matUid: dto.matUid,
        qty: dto.qty,
        workerId: dto.workerId,
        remark: dto.remark,
        ...this.tenantWhere(organizationId),
      });

      await queryRunner.manager.save(delivery);

      // 발주 출고수량 업데이트
      const newDeliveredQty = order.deliveredQty + dto.qty;
      await queryRunner.manager.update(
        SubconOrder,
        { orderNo: dto.orderId, ...this.tenantWhere(organizationId) },
        {
          deliveredQty: newDeliveredQty,
          status: newDeliveredQty >= order.orderQty ? 'DELIVERED' : 'ORDERED',
        },
      );

      return delivery;
    });
  }

  async findDeliveriesByOrderId(orderNo: string, organizationId?: number) {
    return this.subconDeliveryRepository.find({
      where: { orderNo, ...this.tenantWhere(organizationId) },
      order: { createdAt: 'DESC' },
    });
  }

  // ============================================================================
  // 외주 입고
  // ============================================================================

  async createReceive(dto: CreateSubconReceiveDto, organizationId?: number) {
    const order = await this.findOrderById(dto.orderId, organizationId);

    // 입고번호 생성
    const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const count = await this.subconReceiveRepository.count({
      where: {
        receiveNo: `SCR${today}%`,
      },
    });
    const receiveNo = `SCR${today}${String(count + 1).padStart(4, '0')}`;

    const goodQty = dto.goodQty ?? dto.qty;
    const defectQty = dto.defectQty ?? 0;

    return this.tx.run(async (queryRunner) => {
      const receive = queryRunner.manager.create(SubconReceive, {
        orderNo: dto.orderId,
        receiveNo,
        matUid: dto.matUid,
        qty: dto.qty,
        goodQty,
        defectQty,
        inspectResult: dto.inspectResult,
        workerId: dto.workerId,
        remark: dto.remark,
        ...this.tenantWhere(organizationId),
      });

      await queryRunner.manager.save(receive);

      // 발주 입고수량 업데이트
      const newReceivedQty = order.receivedQty + dto.qty;
      const newDefectQty = order.defectQty + defectQty;

      let newStatus = order.status;
      if (newReceivedQty >= order.orderQty) {
        newStatus = 'RECEIVED';
      } else if (newReceivedQty > 0) {
        newStatus = 'PARTIAL_RECV';
      }

      await queryRunner.manager.update(
        SubconOrder,
        { orderNo: dto.orderId, ...this.tenantWhere(organizationId) },
        {
          receivedQty: newReceivedQty,
          defectQty: newDefectQty,
          status: newStatus,
        },
      );

      return receive;
    });
  }

  async findReceivesByOrderId(orderNo: string, organizationId?: number) {
    return this.subconReceiveRepository.find({
      where: { orderNo, ...this.tenantWhere(organizationId) },
      order: { createdAt: 'DESC' },
    });
  }

  async findAllReceives(query: SubconOrderQueryDto, organizationId?: number) {
    const { page = 1, limit = 10, search } = query;
    const skip = (page - 1) * limit;
    const qb = this.subconReceiveRepository.createQueryBuilder('sr');
    if (organizationId != null) qb.andWhere('sr.organizationId = :organizationId', { organizationId });
    if (search) {
      qb.andWhere('(sr.receiveNo LIKE :search OR sr.orderNo LIKE :search OR sr.matUid LIKE :search)', {
        search: `%${search.toUpperCase()}%`,
      });
    }
    qb.orderBy('sr.createdAt', 'DESC').skip(skip).take(limit);
    const [receives, total] = await Promise.all([qb.getMany(), qb.clone().skip(0).take(undefined).getCount()]);
    const orderNos = [...new Set(receives.map((receive) => receive.orderNo))];
    const orders = orderNos.length
      ? await this.subconOrderRepository.find({
          where: { orderNo: In(orderNos), ...this.tenantWhere(organizationId) },
          select: ['orderNo', 'vendorCode', 'itemCode'],
        })
      : [];
    const orderMap = new Map(orders.map((order) => [order.orderNo, order]));
    const vendorCodes = [...new Set(orders.map((order) => order.vendorCode).filter(Boolean))];
    const vendors = vendorCodes.length
      ? await this.vendorMasterRepository.find({
          where: { vendorCode: In(vendorCodes), ...this.tenantWhere(organizationId) },
          select: ['vendorCode', 'vendorName'],
        })
      : [];
    const vendorMap = new Map(vendors.map((vendor) => [vendor.vendorCode, vendor.vendorName]));
    const data = receives.map((receive) => {
      const order = orderMap.get(receive.orderNo);
      return {
        ...receive,
        id: receive.receiveNo,
        vendorName: order ? vendorMap.get(order.vendorCode) ?? order.vendorCode : '',
        itemCode: order?.itemCode ?? '',
        itemName: '',
        workerName: receive.workerId ?? '',
      };
    });
    return { data, total, page, limit };
  }

  // ============================================================================
  // 통계 및 대시보드
  // ============================================================================

  async getSummary(organizationId?: number) {
    const [totalOrders, activeOrders, pendingReceive, totalVendors] = await Promise.all([
      this.subconOrderRepository.count({ where: this.tenantWhere(organizationId) }),
      this.subconOrderRepository.count({
        where: {
          status: In(['ORDERED', 'DELIVERED', 'PARTIAL_RECV']),
          ...this.tenantWhere(organizationId),
        },
      }),
      this.subconOrderRepository.count({
        where: {
          status: In(['DELIVERED', 'PARTIAL_RECV']),
          ...this.tenantWhere(organizationId),
        },
      }),
      this.vendorMasterRepository.count({ where: { useYn: 'Y', ...this.tenantWhere(organizationId) } }),
    ]);

    return {
      totalOrders,
      activeOrders,
      pendingReceive,
      totalVendors,
    };
  }

  async getVendorStock(organizationId?: number) {
    const orders = await this.subconOrderRepository.find({
      where: {
        status: In(['DELIVERED', 'PARTIAL_RECV']),
        ...this.tenantWhere(organizationId),
      },
    });

    // 외주처별 재고 집계
    const stockByVendor = orders.reduce<Record<string, VendorStockSummary>>((acc, order) => {
      const vendorCode = order.vendorCode;
      if (!acc[vendorCode]) {
        acc[vendorCode] = {
          vendorCode,
          vendorName: '',
          deliveredQty: 0,
          receivedQty: 0,
          stockQty: 0,
        };
      }
      acc[vendorCode].deliveredQty += order.deliveredQty;
      acc[vendorCode].receivedQty += order.receivedQty;
      acc[vendorCode].stockQty += order.deliveredQty - order.receivedQty;
      return acc;
    }, {});

    // IN 배치 선조회로 N+1 방지
    const vendorCodeList = Object.keys(stockByVendor);
    const vendorList = vendorCodeList.length > 0
      ? await this.vendorMasterRepository.find({
          where: { vendorCode: In(vendorCodeList), ...this.tenantWhere(organizationId) },
          select: ['vendorCode', 'vendorName'],
        })
      : [];
    const vendorLookup = new Map(vendorList.map((v) => [v.vendorCode, v] as const));

    for (const code of vendorCodeList) {
      const vendor = vendorLookup.get(code);
      if (vendor) {
        stockByVendor[code].vendorCode = vendor.vendorCode;
        stockByVendor[code].vendorName = vendor.vendorName;
      }
    }

    return Object.values(stockByVendor);
  }
}
