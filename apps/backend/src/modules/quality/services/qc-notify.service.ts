/**
 * @file src/modules/quality/services/qc-notify.service.ts
 * @description 품질이상발생관리 + 품질알림관리 —
 *              PB w_qc_notify_master · w_qc_eco_notify_master 이식
 *
 * 초보자 가이드:
 * 1. **품질이상발생의 키는 발생일자 + 발생항번 + ORGANIZATION_ID 다** (기본키 제약은 없다).
 *    항번은 SEQ_QC_NOTIFY_SEQUENCE 로 채번한다 — PB 가 쓰던 시퀀스다.
 * 2. **PB 는 ROWID 로 단건을 잡았다.** 웹은 ROWID 를 내보내지 않고 위 키를 쓴다.
 * 3. **첨부 이미지는 이관 범위 밖이다.** PB 는 NG / 검사 / 문서 이미지 3종을 컬럼에 담고
 *    f_download_qc_* 로 내려줬다. 목록에는 첨부가 있는지만 보여준다.
 * 4. **품질알림(ECO)은 품질이상발생과 다른 테이블이다** — 품목마스터(ID_ITEM)의
 *    ECO_CHECK_YN / ECO_CHECK_COMMENTS 를 바꾼다. PB 도 그랬다.
 */
import { Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import {
  EcoNotifyQueryDto,
  EcoNotifyUpdateDto,
  QcNotifyCreateDto,
  QcNotifyKeyDto,
  QcNotifyQueryDto,
  QcNotifyStatusDto,
  QcNotifyUpdateDto,
} from '../dto/qc-notify.dto';
import { namedBinds } from '../../../common/utils/named-binds.util';

type OracleRow = Record<string, unknown>;

/** 등록·수정에서 사용자가 값을 넣는 컬럼. 키·감사·첨부 컬럼은 여기에 없다. */
const EDITABLE: Array<[column: string, field: keyof QcNotifyCreateDto]> = [
  ['MODEL_NAME', 'modelName'], ['LINE_CODE', 'lineCode'],
  ['WORKSTAGE_CODE', 'workstageCode'], ['MACHINE_CODE', 'machineCode'],
  ['ITEM_CODE', 'itemCode'], ['RUN_NO', 'runNo'],
  ['GRADE', 'grade'], ['BAD_REASON_CODE', 'badReasonCode'],
  ['DETECT_LOCATION', 'detectLocation'], ['MATERIAL_MAKER', 'materialMaker'],
  ['LOCATION_INFO', 'locationInfo'], ['BAD_DESCRIPTION', 'badDescription'],
  ['INSPECT_CHARGER', 'inspectCharger'], ['INSPECT_MANAGER', 'inspectManager'],
  ['DEPARTMENT_CODE', 'departmentCode'], ['LINE_STATUS_NOTIFY', 'lineStatusNotify'],
  ['COMMENTS', 'comments'], ['QC_COMMENTS', 'qcComments'],
  ['INSPECT_QTY', 'inspectQty'], ['INSPECT_BAD_QTY', 'inspectBadQty'],
];

/** TO_DATE 로 넣어야 하는 시각 컬럼 */
const TIME_FIELDS: Array<[column: string, field: keyof QcNotifyCreateDto]> = [
  ['START_TIME', 'startTime'], ['END_TIME', 'endTime'],
];

@Injectable()
export class QcNotifyService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_qc_notify_lst */
  async find(query: QcNotifyQueryDto, organizationId: number) {
    const binds: OracleRow = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      modelName: this.like(query.modelName),
      lineCode: this.like(query.lineCode),
      workstageCode: this.like(query.workstageCode),
      itemCode: this.like(query.itemCode),
      materialMaker: this.like(query.materialMaker),
      machineCode: this.like(query.machineCode),
      notifyStatus: this.like(query.notifyStatus),
      keyword: query.keyword?.trim() ? `%${query.keyword.trim()}%` : null,
    };
    const body = `
      SELECT n.ACTION_DATE AS "actionDate", n.NOTIFY_SEQUENCE AS "notifySequence",
             n.MODEL_NAME AS "modelName",
             n.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             n.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             n.MACHINE_CODE AS "machineCode",
             n.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
             n.RUN_NO AS "runNo",
             n.START_TIME AS "startTime", n.END_TIME AS "endTime",
             n.INSPECT_QTY AS "inspectQty", n.INSPECT_BAD_QTY AS "inspectBadQty",
             n.GRADE AS "grade", grd.CODE_MEAN_KOR AS "gradeName",
             n.BAD_REASON_CODE AS "badReasonCode", bad.CODE_MEAN_KOR AS "badReasonName",
             n.DETECT_LOCATION AS "detectLocation", det.CODE_MEAN_KOR AS "detectLocationName",
             n.NOTIFY_STATUS AS "notifyStatus", nst.CODE_MEAN_KOR AS "notifyStatusName",
             n.COMPLETE_YN AS "completeYn", cpl.CODE_MEAN_KOR AS "completeName",
             n.COMPLETE_DATE AS "completeDate",
             n.MATERIAL_MAKER AS "materialMaker", n.LOCATION_INFO AS "locationInfo",
             n.BAD_DESCRIPTION AS "badDescription",
             n.INSPECT_CHARGER AS "inspectCharger", n.INSPECT_MANAGER AS "inspectManager",
             n.DEPARTMENT_CODE AS "departmentCode",
             n.LINE_STATUS_NOTIFY AS "lineStatusNotify",
             n.COMMENTS AS "comments", n.QC_COMMENTS AS "qcComments",
             CASE WHEN NVL(LENGTH(n.NG_IMAGE), 0) > 0 THEN 'Y' ELSE 'N' END AS "ngImageYn",
             CASE WHEN NVL(LENGTH(n.INSPECT_IMAGE), 0) > 0 THEN 'Y' ELSE 'N' END
               AS "inspectImageYn",
             CASE WHEN NVL(LENGTH(n.DOCUMENT_IMAGE), 0) > 0 THEN 'Y' ELSE 'N' END
               AS "documentImageYn",
             n.NG_IMAGE_FILE_NAME AS "ngImageFileName",
             n.INSPECT_IMAGE_FILE_NAME AS "inspectImageFileName",
             n.DOCUMENT_IMAGE_FILE_NAME AS "documentImageFileName",
             n.ENTER_BY AS "enterBy", n.ENTER_DATE AS "enterDate",
             n.LAST_MODIFY_BY AS "lastModifyBy", n.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IQ_DAILY_NOTIFY n
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = n.ITEM_CODE AND i.ORGANIZATION_ID = n.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = n.LINE_CODE AND ln.ORGANIZATION_ID = n.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_WORKSTAGE ws
               ON ws.WORKSTAGE_CODE = n.WORKSTAGE_CODE
              AND ws.ORGANIZATION_ID = n.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE grd
               ON grd.CODE_TYPE = 'GRADE' AND grd.CODE_NAME = n.GRADE
              AND grd.ORGANIZATION_ID = n.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE bad
               ON bad.CODE_TYPE = 'BAD REASON CODE' AND bad.CODE_NAME = n.BAD_REASON_CODE
              AND bad.ORGANIZATION_ID = n.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE det
               ON det.CODE_TYPE = 'DETECT LOCATION' AND det.CODE_NAME = n.DETECT_LOCATION
              AND det.ORGANIZATION_ID = n.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE nst
               ON nst.CODE_TYPE = 'NOTIFY STATUS' AND nst.CODE_NAME = n.NOTIFY_STATUS
              AND nst.ORGANIZATION_ID = n.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cpl
               ON cpl.CODE_TYPE = 'COMPLETE YN' AND cpl.CODE_NAME = n.COMPLETE_YN
              AND cpl.ORGANIZATION_ID = n.ORGANIZATION_ID
       WHERE TRUNC(n.ACTION_DATE) >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND TRUNC(n.ACTION_DATE) <= TO_DATE(:dateTo, 'YYYY-MM-DD')
         AND NVL(n.MODEL_NAME, '*') LIKE :modelName
         AND NVL(n.LINE_CODE, '*') LIKE :lineCode
         AND NVL(n.WORKSTAGE_CODE, '*') LIKE :workstageCode
         AND NVL(n.ITEM_CODE, '*') LIKE :itemCode
         AND NVL(n.MATERIAL_MAKER, '*') LIKE :materialMaker
         AND NVL(n.MACHINE_CODE, '*') LIKE :machineCode
         AND NVL(n.NOTIFY_STATUS, '*') LIKE :notifyStatus
         AND (:keyword IS NULL
              OR n.BAD_DESCRIPTION LIKE :keyword
              OR n.COMMENTS LIKE :keyword
              OR n.QC_COMMENTS LIKE :keyword)
         AND n.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "actionDate" DESC, "notifySequence" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 등록 — 발생일자는 오늘, 항번은 SEQ_QC_NOTIFY_SEQUENCE 로 서버가 채운다 */
  async create(dto: QcNotifyCreateDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const seq = await qr.query(
        `SELECT SEQ_QC_NOTIFY_SEQUENCE.NEXTVAL AS "seq" FROM DUAL`, [],
      ) as OracleRow[];
      const notifySequence = Number(seq[0]?.seq ?? 0);

      const columns = [
        'ACTION_DATE', 'NOTIFY_SEQUENCE', 'ORGANIZATION_ID', 'NOTIFY_STATUS', 'COMPLETE_YN',
      ];
      const values = ['TRUNC(SYSDATE)', ':notifySequence', ':organizationId', `'W'`, `'W'`];
      const binds: OracleRow = { notifySequence, organizationId, userId };
      for (const [column, field] of EDITABLE) {
        columns.push(column);
        values.push(`:${field}`);
        binds[field] = dto[field] ?? null;
      }
      for (const [column, field] of TIME_FIELDS) {
        columns.push(column);
        values.push(`TO_DATE(:${field}, 'YYYY-MM-DD"T"HH24:MI')`);
        binds[field] = dto[field] ? String(dto[field]).slice(0, 16) : null;
      }
      columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
      values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

      await qr.query(
        `INSERT INTO IQ_DAILY_NOTIFY (${columns.join(', ')}) VALUES (${values.join(', ')})`,
        namedBinds(binds),
      );
      return { notifySequence };
    });
  }

  private async exists(dto: QcNotifyKeyDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IQ_DAILY_NOTIFY
        WHERE ACTION_DATE = TO_DATE(:actionDate, 'YYYY-MM-DD')
          AND NOTIFY_SEQUENCE = :notifySequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({
        actionDate: dto.actionDate.slice(0, 10),
        notifySequence: dto.notifySequence,
        organizationId,
      }),
    ) as OracleRow[];
    return Number(rows[0]?.cnt ?? 0) > 0;
  }

  /** 수정 — 키는 바꿀 수 없다. 조치상태는 별도 API 로 바꾼다. */
  async update(dto: QcNotifyUpdateDto, organizationId: number, userId: string) {
    if (!await this.exists(dto, organizationId)) {
      throw new NotFoundException('품질이상발생 건을 찾을 수 없습니다.');
    }
    const sets: string[] = [];
    const binds: OracleRow = {
      actionDate: dto.actionDate.slice(0, 10),
      notifySequence: dto.notifySequence,
      organizationId,
      userId,
    };
    for (const [column, field] of EDITABLE) {
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    for (const [column, field] of TIME_FIELDS) {
      sets.push(`${column} = TO_DATE(:${field}, 'YYYY-MM-DD"T"HH24:MI')`);
      binds[field] = dto[field] ? String(dto[field]).slice(0, 16) : null;
    }
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

    await this.dataSource.query(
      `UPDATE IQ_DAILY_NOTIFY SET ${sets.join(', ')}
        WHERE ACTION_DATE = TO_DATE(:actionDate, 'YYYY-MM-DD')
          AND NOTIFY_SEQUENCE = :notifySequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds(binds),
    );
    return { notifySequence: dto.notifySequence };
  }

  /**
   * 조치상태 변경 — 완료('Y')로 바꾸면 완료일시를 서버가 찍는다.
   * 완료가 아닌 상태로 되돌리면 완료일시를 지운다.
   */
  async changeStatus(dto: QcNotifyStatusDto, organizationId: number, userId: string) {
    if (!await this.exists(dto, organizationId)) {
      throw new NotFoundException('품질이상발생 건을 찾을 수 없습니다.');
    }
    const sets: string[] = ['LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE'];
    const binds: OracleRow = {
      actionDate: dto.actionDate.slice(0, 10),
      notifySequence: dto.notifySequence,
      organizationId,
      userId,
    };
    if (dto.notifyStatus !== undefined) {
      sets.push('NOTIFY_STATUS = :notifyStatus');
      binds.notifyStatus = dto.notifyStatus;
    }
    if (dto.completeYn !== undefined) {
      sets.push('COMPLETE_YN = :completeYn');
      sets.push(`COMPLETE_DATE = CASE WHEN :completeYn = 'Y' THEN SYSDATE ELSE NULL END`);
      binds.completeYn = dto.completeYn;
    }
    await this.dataSource.query(
      `UPDATE IQ_DAILY_NOTIFY SET ${sets.join(', ')}
        WHERE ACTION_DATE = TO_DATE(:actionDate, 'YYYY-MM-DD')
          AND NOTIFY_SEQUENCE = :notifySequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds(binds),
    );
    return { notifySequence: dto.notifySequence };
  }

  /** 삭제 */
  async remove(dto: QcNotifyKeyDto, organizationId: number) {
    if (!await this.exists(dto, organizationId)) {
      throw new NotFoundException('품질이상발생 건을 찾을 수 없습니다.');
    }
    await this.dataSource.query(
      `DELETE FROM IQ_DAILY_NOTIFY
        WHERE ACTION_DATE = TO_DATE(:actionDate, 'YYYY-MM-DD')
          AND NOTIFY_SEQUENCE = :notifySequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({
        actionDate: dto.actionDate.slice(0, 10),
        notifySequence: dto.notifySequence,
        organizationId,
      }),
    );
    return { deleted: true };
  }

  /** 품질알림(ECO) 대상 — PB d_qc_eco_notify_lst (품목마스터 기준) */
  async findEcoTargets(query: EcoNotifyQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      itemCode: this.like(query.itemCode),
      itemName: this.like(query.itemName),
      modelName: this.like(query.modelName),
      ecoCheckYn: this.like(query.ecoCheckYn),
    };
    const body = `
      SELECT i.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
             i.ITEM_SPEC AS "itemSpec", i.ITEM_UOM AS "itemUom",
             i.MODEL_NAME AS "modelName", i.MODEL_SUFFIX AS "modelSuffix",
             i.ISSUE_PACKING_QTY AS "issuePackingQty",
             i.ECO_CHECK_YN AS "ecoCheckYn",
             i.ECO_CHECK_COMMENTS AS "ecoCheckComments",
             i.MSL_LEVEL AS "mslLevel", i.LOCATION_ADDRESS AS "locationAddress",
             i.ENTER_BY AS "enterBy", i.ENTER_DATE AS "enterDate",
             i.LAST_MODIFY_BY AS "lastModifyBy", i.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM ID_ITEM i
       WHERE i.ITEM_CODE LIKE :itemCode
         AND NVL(i.ITEM_NAME, '*') LIKE :itemName
         AND NVL(i.MODEL_NAME, '*') LIKE :modelName
         AND NVL(i.ECO_CHECK_YN, '*') LIKE :ecoCheckYn
         AND i.DATESET <= TRUNC(SYSDATE) AND i.DATEEND >= TRUNC(SYSDATE)
         AND i.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "itemCode"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 품질알림 확인 처리 — 체크한 품목의 ECO 확인여부·설명을 바꾼다 */
  async updateEcoCheck(dto: EcoNotifyUpdateDto, organizationId: number, userId: string) {
    const codes = [...new Set(dto.itemCodes.map((value) => value.trim()).filter(Boolean))];
    if (codes.length === 0) {
      throw new NotFoundException('처리할 품목을 고르세요.');
    }
    return this.tx.run(async (qr) => {
      // 사후 COUNT 로 세면 "이미 그 값이던 품목" 과 "없는 품목" 을 구분할 수 없다.
      // 바꾸기 전에 현재 값을 읽어 두고 실제로 달라진 것만 센다.
      const before = await qr.query(
        `SELECT ITEM_CODE AS "itemCode", ECO_CHECK_YN AS "ecoCheckYn"
           FROM ID_ITEM
          WHERE ITEM_CODE IN (${codes.map((_, i) => `:c${i}`).join(', ')})
            AND ORGANIZATION_ID = :organizationId
            AND DATESET <= TRUNC(SYSDATE) AND DATEEND >= TRUNC(SYSDATE)`,
        namedBinds({
          ...Object.fromEntries(codes.map((value, i) => [`c${i}`, value])),
          organizationId,
        }),
      ) as OracleRow[];
      const existing = new Map(
        before.map((row) => [String(row.itemCode), String(row.ecoCheckYn ?? '')]),
      );

      for (const itemCode of codes) {
        if (!existing.has(itemCode)) continue;
        await qr.query(
          `UPDATE ID_ITEM
              SET ECO_CHECK_YN       = :ecoCheckYn,
                  ECO_CHECK_COMMENTS = :ecoCheckComments,
                  LAST_MODIFY_BY     = :userId,
                  LAST_MODIFY_DATE   = SYSDATE
            WHERE ITEM_CODE = :itemCode AND ORGANIZATION_ID = :organizationId
              AND DATESET <= TRUNC(SYSDATE) AND DATEEND >= TRUNC(SYSDATE)`,
          namedBinds({
            ecoCheckYn: dto.ecoCheckYn,
            ecoCheckComments: dto.ecoCheckComments ?? null,
            userId,
            itemCode,
            organizationId,
          }),
        );
      }

      const changed = [...existing.entries()]
        .filter(([, value]) => value !== dto.ecoCheckYn).length;
      return {
        requested: codes.length,
        changed,
        alreadySet: existing.size - changed,
        missing: codes.filter((itemCode) => !existing.has(itemCode)).length,
      };
    });
  }
}
