/**
 * @file src/modules/quality/services/repair-history.service.ts
 * @description 공정수리이력조회 — PB w_pln_product_pcb_repair_master 의 dw_3("Repair History") 이식
 *
 * 원본 DataWindow: d_pln_product_work_qc_hst (retrieve 인자 10개)
 * 조회 전용이다. master 화면의 수리접수·저장·삭제·출고(DML)는 이식 범위 밖이다.
 *
 * PB 원본과의 의도적 차이 한 가지:
 * 원본은 `FROM IP_PRODUCT_WORK_QC, ID_ITEM` 에 `(+)` 아우터 조인을 걸어 두지만
 * SELECT 목록에 ID_ITEM 컬럼이 하나도 없다. (ITEM_CODE, ORGANIZATION_ID) 가 고유해
 * 행이 늘지도 줄지도 않으므로 조인을 제거했다 — 결과는 동치다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { parseDateStart } from '../../../shared/date.util';
import { RepairHistoryQueryDto } from '../dto/repair-history.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class RepairHistoryService {
  constructor(private readonly dataSource: DataSource) {}

  async find(query: RepairHistoryQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = {
      organizationId,
      modelName: this.like(query.modelName),
      serialNo: this.like(query.serialNo),
      lineCode: this.like(query.lineCode),
      workstageCode: this.like(query.workstageCode),
      receiptDeficit: this.like(query.receiptDeficit),
      inspectHandling: this.like(query.inspectHandling),
      repairResultCode: this.like(query.repairResultCode),
      // 'YYYY-MM-DD' 를 new Date() 로 바로 넘기면 UTC 자정으로 해석돼 KST 기준 +9시간 밀린다.
      dateFrom: parseDateStart(query.dateFrom) ?? new Date(1900, 0, 1),
      dateTo: parseDateStart(query.dateTo) ?? new Date(9999, 11, 30),
    };

    // PB 원본 그대로: QC_DATE >= :dateFrom AND QC_DATE < :dateTo + 1 (종료일 포함)
    const from = `
      FROM IP_PRODUCT_WORK_QC qc
      -- PB 는 DDDW(vd_line_code/vd_workstage_code)로 코드 대신 이름을 보여준다.
      -- 코드+조직이 유일해 조인으로 행이 늘지 않는다. 근거: docs/database/pb-dddw-inventory.md
      LEFT JOIN IP_PRODUCT_LINE ln
             ON ln.LINE_CODE = qc.LINE_CODE AND ln.ORGANIZATION_ID = qc.ORGANIZATION_ID
      LEFT JOIN IP_PRODUCT_WORKSTAGE ws
             ON ws.WORKSTAGE_CODE = qc.WORKSTAGE_CODE AND ws.ORGANIZATION_ID = qc.ORGANIZATION_ID
      LEFT JOIN IP_PRODUCT_LINE rln
             ON rln.LINE_CODE = qc.REPAIR_LINE_CODE AND rln.ORGANIZATION_ID = qc.ORGANIZATION_ID
      LEFT JOIN IP_PRODUCT_WORKSTAGE rws
             ON rws.WORKSTAGE_CODE = qc.REPAIR_WORKSTAGE_CODE AND rws.ORGANIZATION_ID = qc.ORGANIZATION_ID
      WHERE qc.ORGANIZATION_ID = :organizationId
        AND NVL(qc.MODEL_NAME, '*') LIKE :modelName
        AND NVL(qc.SERIAL_NO, '*') LIKE :serialNo
        AND NVL(qc.LINE_CODE, '*') LIKE :lineCode
        AND NVL(qc.WORKSTAGE_CODE, '*') LIKE :workstageCode
        AND NVL(qc.RECEIPT_DEFICIT, '*') LIKE :receiptDeficit
        AND NVL(qc.QC_INSPECT_HANDLING, '*') LIKE :inspectHandling
        AND NVL(qc.REPAIR_RESULT_CODE, '*') LIKE :repairResultCode
        AND qc.QC_DATE >= :dateFrom
        AND qc.QC_DATE < :dateTo + 1
    `;

    const select = `
      SELECT qc.QC_SEQUENCE AS "qcSequence",
             qc.LINE_CODE AS "lineCode",
             ln.LINE_NAME AS "lineName",
             qc.WORKSTAGE_CODE AS "workstageCode",
             ws.WORKSTAGE_NAME AS "workstageName",
             qc.SERIAL_NO AS "serialNo",
             qc.QC_RESULT AS "qcResult",
             qc.BAD_REASON_CODE AS "badReasonCode",
             qc.BAD_QTY AS "badQty",
             qc.DEFECT_QTY AS "defectQty",
             qc.CHARGER AS "charger",
             qc.REPAIR_BY AS "repairBy",
             qc.QC_DATE AS "qcDate",
             qc.REPAIR_DATE AS "repairDate",
             qc.QC_INSPECT_HANDLING AS "qcInspectHandling",
             qc.RECEIPT_DEFICIT AS "receiptDeficit",
             qc.REPAIR_RESULT_CODE AS "repairResultCode",
             qc.REPAIR_METHOD AS "repairMethod",
             qc.REPAIR_LINE_CODE AS "repairLineCode",
             rln.LINE_NAME AS "repairLineName",
             qc.REPAIR_WORKSTAGE_CODE AS "repairWorkstageCode",
             rws.WORKSTAGE_NAME AS "repairWorkstageName",
             qc.BAD_CAUSE_BY AS "badCauseBy",
             qc.LCR_MEASURE AS "lcrMeasure",
             qc.MACHINE_CODE AS "machineCode",
             qc.SHIFT_CODE AS "shiftCode",
             qc.ITEM_CODE AS "itemCode",
             qc.MODEL_NAME AS "modelName",
             qc.MODEL_SUFFIX AS "modelSuffix",
             qc.LOCATION_CODE AS "locationCode",
             qc.COMMENTS AS "comments",
             qc.ENTER_BY AS "enterBy",
             qc.ENTER_DATE AS "enterDate",
             qc.LAST_MODIFY_BY AS "lastModifyBy",
             qc.LAST_MODIFY_DATE AS "lastModifyDate",
             qc.ORGANIZATION_ID AS "organizationId",
             ROUND((SYSDATE - qc.QC_DATE) * 24, 2) AS "tatTime"
      ${from}
      ORDER BY qc.RECEIPT_DEFICIT, qc.QC_INSPECT_HANDLING, qc.QC_SEQUENCE
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY
    `;
    const count = `SELECT COUNT(*) AS "total" ${from}`;
    const offset = (query.page - 1) * query.limit;

    const rows = await this.dataSource.query(
      select,
      { ...binds, offset, limit: query.limit } as unknown as unknown[],
    ) as OracleRow[];
    const totals = await this.dataSource.query(count, binds as unknown as unknown[]) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page: query.page, limit: query.limit };
  }

  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }
}
