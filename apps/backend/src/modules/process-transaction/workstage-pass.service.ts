import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { OracleService } from '../../common/services/oracle.service';
import { WorkstagePassQueryDto, WorkstagePassScanDto } from './workstage-pass.dto';

type Row = Record<string, unknown>;

@Injectable()
export class WorkstagePassService {
  constructor(private readonly dataSource: DataSource, private readonly oracle: OracleService) {}

  async find(query: WorkstagePassQueryDto, organizationId: number) {
    const mode = query.mode ?? 'history';
    const binds = {
      organizationId, lineCode: this.like(query.lineCode), workstageCode: this.like(query.workstageCode),
      modelName: this.like(query.modelName), serialNo: this.like(query.serialNo),
      dateFrom: query.dateFrom ?? '1900-01-01', dateTo: query.dateTo ?? '2999-12-31',
    };
    const where = `FROM IP_PRODUCT_WORKSTAGE_IO io
      WHERE io.ORGANIZATION_ID = :organizationId
        AND io.LINE_CODE LIKE :lineCode AND io.WORKSTAGE_CODE LIKE :workstageCode
        AND NVL(io.MODEL_NAME, ' ') LIKE :modelName AND NVL(io.SERIAL_NO, ' ') LIKE :serialNo
        AND io.IO_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
        AND io.IO_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1`;
    const detail = `SELECT io.IO_DATE AS "ioDate", io.IO_SEQUENCE AS "ioSequence", io.RUN_NO AS "runNo",
      io.ITEM_CODE AS "itemCode", io.SERIAL_NO AS "serialNo", io.LINE_CODE AS "lineCode",
      io.WORKSTAGE_CODE AS "workstageCode", io.IO_DEFICIT AS "ioDeficit", io.IO_QTY AS "ioQty",
      io.OUT_DATE AS "outDate", io.MODEL_NAME AS "modelName", io.MODEL_SUFFIX AS "modelSuffix",
      io.WORKSTAGE_TYPE AS "workstageType", io.LOT_NO AS "lotNo", io.WIP_SEQ AS "wipSeq" ${where}`;
    const body = mode === 'inventory'
      ? `SELECT TRUNC(NVL(io.ACTUAL_DATE, io.IO_DATE)) AS "actualDate", io.WORKSTAGE_CODE AS "workstageCode", io.MODEL_NAME AS "modelName", SUM(io.IO_QTY) AS "ioQty" ${where} AND io.IO_DEFICIT = 'I' GROUP BY TRUNC(NVL(io.ACTUAL_DATE, io.IO_DATE)), io.WORKSTAGE_CODE, io.MODEL_NAME`
      : mode === 'workstageSummary'
        ? `SELECT io.WORKSTAGE_CODE AS "workstageCode", io.MODEL_NAME AS "modelName", io.IO_DEFICIT AS "ioDeficit", SUM(io.IO_QTY) AS "ioQty" ${where} GROUP BY io.WORKSTAGE_CODE, io.MODEL_NAME, io.IO_DEFICIT`
        : `${detail}${mode === 'wait' ? " AND io.IO_DEFICIT = 'I' AND io.OUT_DATE IS NULL" : ''}`;
    const totals = await this.dataSource.query(`SELECT COUNT(*) AS "total" FROM (${body})`, { ...binds } as never) as Row[];
    const page = query.page ?? 1; const limit = query.limit ?? 500;
    const rows = await this.dataSource.query(`${body} ORDER BY 1 DESC OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as never) as Row[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  async scan(dto: WorkstagePassScanDto, organizationId: number, userId?: string) {
    const pid = dto.pid.trim(); const lineCode = dto.lineCode.trim(); const workstageCode = dto.workstageCode.trim();
    if (!pid || !lineCode || !workstageCode) throw new BadRequestException('PID, 라인, 공정은 필수입니다.');
    const checks = await this.dataSource.query(`SELECT INTERLOCK_CHECK_TYPE AS "interlockCheckType"
      FROM IQ_INTERLOCK_CHECK_CONDITION WHERE ORGANIZATION_ID = :organizationId
        AND LINE_CODE = :lineCode AND WORKSTAGE_CODE = :workstageCode AND NVL(USE_YN, 'Y') = 'Y'
      ORDER BY CHECK_SEQUENCE`, { organizationId, lineCode, workstageCode } as never) as Row[];
    for (const check of checks) {
      const result = await this.oracle.callProcScalar('P_INTERLOCK_CHECK', [
        { name: 'result', type: 'STRING', maxSize: 100 }, { name: 'message', type: 'STRING', maxSize: 2000 },
        { name: 'ngMessage', type: 'STRING', maxSize: 2000 }, { name: 'okMessage', type: 'STRING', maxSize: 2000 },
      ], { lineCode, workstageCode, machineCode: '*', serialNo: pid, interlockCheckType: check.interlockCheckType });
      if (String(result.result ?? '').toUpperCase() === 'NG') throw new BadRequestException(String(result.ngMessage ?? result.message ?? '인터록 검사에 실패했습니다.'));
    }
    const statuses = await this.dataSource.query(`SELECT F_CHECK_PID_STATUS_4_WS(:pid) AS "status" FROM DUAL`, { pid } as never) as Row[];
    if (String(statuses[0]?.status ?? '').toUpperCase() !== 'OK') throw new BadRequestException(String(statuses[0]?.status ?? 'PID 상태를 확인할 수 없습니다.'));

    const magazine = await this.dataSource.query(`SELECT ITEM_CODE AS "itemCode", MODEL_NAME AS "modelName", MODEL_SUFFIX AS "modelSuffix",
      RUN_NO AS "runNo", NVL(LOT_QTY, 1) AS "ioQty" FROM IP_PRODUCT_RUN_CARD_IO
      WHERE MAGAZINE_LABEL_NO = :pid AND ORGANIZATION_ID = :organizationId AND ROWNUM = 1`, { pid, organizationId } as never) as Row[];
    const barcode = magazine.length ? [] : await this.dataSource.query(`SELECT ITEM_CODE AS "itemCode", MODEL_NAME AS "modelName", MODEL_SUFFIX AS "modelSuffix",
      RUN_NO AS "runNo", 1 AS "ioQty" FROM IP_PRODUCT_2D_BARCODE
      WHERE SERIAL_NO = :pid AND ORGANIZATION_ID = :organizationId AND ROWNUM = 1`, { pid, organizationId } as never) as Row[];
    const product = magazine[0] ?? barcode[0];
    if (!product) throw new BadRequestException('등록되지 않은 PID입니다.');

    return this.dataSource.transaction(async manager => {
      if (dto.cancel) {
        const affected = await manager.query(`DELETE FROM IP_PRODUCT_WORKSTAGE_IO WHERE ORGANIZATION_ID = :organizationId
          AND SERIAL_NO = :pid AND LINE_CODE = :lineCode AND WORKSTAGE_CODE = :workstageCode AND IO_DEFICIT = 'I'
          AND WIP_SEQ = (SELECT MAX(WIP_SEQ) FROM IP_PRODUCT_WORKSTAGE_IO WHERE ORGANIZATION_ID = :organizationId2 AND SERIAL_NO = :pid2
            AND LINE_CODE = :lineCode2 AND WORKSTAGE_CODE = :workstageCode2 AND IO_DEFICIT = 'I')`,
          [organizationId, pid, lineCode, workstageCode, organizationId, pid, lineCode, workstageCode]);
        if (!Number(affected)) throw new BadRequestException('취소할 공정통과 이력이 없습니다.');
        return { action: 'cancel', pid };
      }
      if (!dto.rework) {
        const duplicate = await manager.query(`SELECT COUNT(*) AS "count" FROM IP_PRODUCT_WORKSTAGE_IO WHERE ORGANIZATION_ID = :organizationId
          AND SERIAL_NO = :pid AND LINE_CODE = :lineCode AND WORKSTAGE_CODE = :workstageCode AND IO_DEFICIT = 'I'`,
          [organizationId, pid, lineCode, workstageCode]);
        if (Number(duplicate[0]?.count ?? 0) > 0) throw new BadRequestException('이미 통과 처리된 PID입니다.');
      }
      await manager.query(`INSERT INTO IP_PRODUCT_WORKSTAGE_IO
        (IO_DATE, IO_SEQUENCE, RUN_NO, ITEM_CODE, SERIAL_NO, LINE_CODE, WORKSTAGE_CODE, IO_DEFICIT, IO_QTY,
         ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, MODEL_NAME, MODEL_SUFFIX, WORKSTAGE_TYPE)
        VALUES (SYSDATE, SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL, :runNo, :itemCode, :pid, :lineCode, :workstageCode, 'I', :ioQty,
         :organizationId, SYSDATE, :userId, SYSDATE, :userId2, :modelName, :modelSuffix, :workstageType)`,
        [product.runNo, product.itemCode, pid, lineCode, workstageCode, Number(product.ioQty ?? 1) || 1, organizationId,
          userId ?? 'SYSTEM', userId ?? 'SYSTEM', product.modelName, product.modelSuffix, dto.workstageType ?? null]);
      return { action: 'scan', pid, modelName: product.modelName, ioQty: Number(product.ioQty ?? 1) || 1 };
    });
  }

  private like(value?: string) { return value?.trim() ? `${value.trim()}%` : '%'; }
}
