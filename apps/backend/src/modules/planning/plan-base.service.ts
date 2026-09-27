/**
 * @file src/modules/planning/plan-base.service.ts
 * @description 제품생산계획(MI)·반제품생산계획(SMD) 공통 구현.
 *
 * 초보자 가이드:
 * 1. **두 화면은 테이블만 다르다.** 키(PLAN_DATE + PLAN_SEQUENCE + ORG),
 *    시간대 10칸, 조회조건, 확정처리가 같다. 그래서 규칙을 한 번만 쓰고
 *    테이블·뷰·필수컬럼 차이만 설정으로 받는다.
 * 2. **NOT NULL 이 두 테이블에서 다르다** — 아래 PLAN_TABLES 의 `required` 참고.
 *    MI 는 WORKSTAGE_CODE 와 PLAN_PRIORITY 가 필수이고 SMD 에는 WORKSTAGE_CODE
 *    컬럼이 아예 없고 PLAN_PRIORITY 는 비워도 된다.
 *    반대로 SMD 는 ITEM_CODE·WORK_ORDER_NO·PCB_ITEM·MASTER_MODEL_NAME·
 *    PRODUCTION_TYPE 이 필수다. 폼에서 먼저 막지 않으면 DB 가 거부한다.
 * 3. **MFS 는 NOT NULL 이고 기본값이 '*' 다.** PB 가 계획을 해제할 때
 *    `MFS='*'` 로 되돌리는 것과 같은 규약이다 — 롯트카드가 붙으면 그 번호가 들어간다.
 *    이 서비스는 MFS 를 화면에서 받지 않는다 (롯트카드 쪽이 쓰는 값이다).
 * 4. **실적은 뷰에서 좌측 외부조인으로 붙인다.** 계획일·라인·모델(·공정)로 맞춘다.
 *    내부조인으로 바꾸면 실적이 아직 없는 계획이 목록에서 사라진다.
 */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import { PlanConfirmDto, PlanKeyDto, PlanQueryDto, PlanUpsertDto } from './plan.dto';
import {
  actualTimeColumns,
  like,
  planTimeColumns,
  planTimeFieldPairs,
  planTimeSumExpression,
  timeDescColumns,
} from './plan-shared';

export interface PlanTableConfig {
  /** 화면에 보일 이름. 오류 문구에 쓴다. */
  label: string;
  table: 'IP_PRODUCT_MI_PLAN' | 'IP_PRODUCT_SMD_PLAN';
  /** 실적 뷰 */
  actualView: 'IP_PRODUCT_ACTUAL_TIME_V' | 'IP_ASSEMBLY_ACTUAL_TIME_V';
  /** 이 테이블에만 있는 컬럼 ↔ DTO 필드 */
  extraColumns: Array<[column: string, field: keyof PlanUpsertDto]>;
  /** 이 테이블에서 NOT NULL 인 DTO 필드 (키·수량 제외) */
  required: Array<[field: keyof PlanUpsertDto, label: string]>;
  /** 실적 뷰 조인에 공정코드를 포함하는가 (MI 만 해당) */
  joinWorkstage: boolean;
}

export const PLAN_TABLES: Record<'mi' | 'smd', PlanTableConfig> = {
  mi: {
    label: '제품생산계획',
    table: 'IP_PRODUCT_MI_PLAN',
    actualView: 'IP_PRODUCT_ACTUAL_TIME_V',
    extraColumns: [['WORKSTAGE_CODE', 'workstageCode']],
    // PLAN_PRIORITY 는 MI 에서 NOT NULL 이고 SMD 에서는 nullable 이다.
    // 실측으로 확인했다 (없이 INSERT 하면 ORA-01400).
    required: [['workstageCode', '공정코드'], ['planPriority', '계획 우선순위']],
    joinWorkstage: true,
  },
  smd: {
    label: '반제품생산계획',
    table: 'IP_PRODUCT_SMD_PLAN',
    actualView: 'IP_ASSEMBLY_ACTUAL_TIME_V',
    extraColumns: [
      ['SHIFT_CODE', 'shiftCode'],
      ['PRODUCTION_TYPE', 'productionType'],
      ['MFS_GROUP_NO', 'mfsGroupNo'],
    ],
    required: [
      ['itemCode', '품목코드'],
      ['workOrderNo', '작업지시번호'],
      ['pcbItem', 'PCB 면'],
      ['masterModelName', '마스터 모델명'],
      ['productionType', '생산유형'],
    ],
    joinWorkstage: false,
  },
};

/** 두 테이블에 공통으로 있는 수정 가능 컬럼. 감사컬럼과 MFS 는 여기에 없다. */
const COMMON_COLUMNS: Array<[column: string, field: keyof PlanUpsertDto]> = [
  ['LINE_CODE', 'lineCode'],
  ['MODEL_NAME', 'modelName'],
  ['MODEL_SUFFIX', 'modelSuffix'],
  ['PLAN_QTY', 'planQty'],
  ['PLAN_PRIORITY', 'planPriority'],
  ['ITEM_CODE', 'itemCode'],
  ['PARENT_ITEM_CODE', 'parentItemCode'],
  ['WORK_ORDER_NO', 'workOrderNo'],
  ['PCB_ITEM', 'pcbItem'],
  ['PLAN_STATUS', 'planStatus'],
  ['CUSTOMER_CODE', 'customerCode'],
  ['LOT_DIVIDE_YN', 'lotDivideYn'],
  ['PLAN_CAPA_QTY', 'planCapaQty'],
  ['MC_TIME', 'mcTime'],
  ['PLAN_QTY_D1', 'planQtyD1'],
  ['PLAN_QTY_D2', 'planQtyD2'],
  ['PLAN_QTY_D3', 'planQtyD3'],
  ['MASTER_MODEL_NAME', 'masterModelName'],
  ['COMMENTS', 'comments'],
];

type Row = Record<string, unknown>;

@Injectable()
export class PlanBaseService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 목록 — PB d_pln_mi_master_plan_lst_tree / d_pln_smd_master_plan_lst_tree. */
  async find(cfg: PlanTableConfig, query: PlanQueryDto, organizationId: number) {
    const hasWorkstage = cfg.joinWorkstage;
    const extraSelect = cfg.extraColumns
      .map(([column, field]) => `p.${column} AS "${String(field)}"`)
      .join(', ');

    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(p.PLAN_DATE, 'YYYY-MM-DD') AS "planDate",
              p.PLAN_SEQUENCE AS "planSequence",
              p.PLAN_PRIORITY AS "planPriority",
              p.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              p.MFS AS "mfs",
              p.MODEL_NAME AS "modelName", p.MODEL_SUFFIX AS "modelSuffix",
              p.MASTER_MODEL_NAME AS "masterModelName",
              p.PARENT_ITEM_CODE AS "parentItemCode",
              p.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
              i.ITEM_SPEC AS "itemSpec", i.ITEM_UOM AS "itemUom",
              i.ITEM_CLASS AS "itemClass",
              p.WORK_ORDER_NO AS "workOrderNo",
              p.PLAN_QTY AS "planQty", p.ACTUAL_QTY AS "actualQty",
              ${planTimeSumExpression('p')} AS "planTimeSum",
              p.PLAN_QTY_D1 AS "planQtyD1", p.PLAN_QTY_D2 AS "planQtyD2",
              p.PLAN_QTY_D3 AS "planQtyD3",
              p.PLAN_CAPA_QTY AS "planCapaQty", p.MC_TIME AS "mcTime",
              p.PCB_ITEM AS "pcbItem", pcb.CODE_MEAN_KOR AS "pcbItemName",
              p.PLAN_STATUS AS "planStatus", ps.CODE_MEAN_KOR AS "planStatusName",
              p.PLAN_TRANSFER_YN AS "planTransferYn",
              p.LOT_DIVIDE_YN AS "lotDivideYn",
              p.CONFIRM_YN AS "confirmYn", p.CONFIRM_BY AS "confirmBy",
              p.CONFIRM_DATE AS "confirmDate",
              p.CUSTOMER_CODE AS "customerCode",
              p.COMMENTS AS "comments",
              ${extraSelect ? `${extraSelect},` : ''}
              ${planTimeColumns('p')},
              ${timeDescColumns('p')},
              ${actualTimeColumns('v')},
              F_GET_CARRIER_SIZE(p.MODEL_NAME, p.ORGANIZATION_ID) AS "carrierSize",
              p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate",
              p.LAST_MODIFY_BY AS "lastModifyBy", p.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM ${cfg.table} p
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = p.ITEM_CODE
               AND i.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = p.LINE_CODE
               AND pl.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE pcb
                ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = p.PCB_ITEM
         LEFT JOIN ISYS_BASECODE ps
                ON ps.CODE_TYPE = 'PLAN STATUS' AND ps.CODE_NAME = p.PLAN_STATUS
         LEFT JOIN ${cfg.actualView} v
                ON v.ACTUAL_DATE = p.PLAN_DATE
               AND v.LINE_CODE = p.LINE_CODE
               AND v.MODEL_NAME = p.MODEL_NAME
               ${hasWorkstage ? 'AND v.WORKSTAGE_CODE = p.WORKSTAGE_CODE' : ''}
        WHERE p.ORGANIZATION_ID = :organizationId
          AND p.PLAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND p.PLAN_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode
          AND NVL(p.MODEL_NAME, '*') LIKE :modelName
          AND NVL(p.PLAN_STATUS, '*') LIKE :planStatus
          ${hasWorkstage ? 'AND NVL(p.WORKSTAGE_CODE, \'*\') LIKE :workstageCode' : ''}
        ORDER BY p.PLAN_DATE, p.LINE_CODE, p.PLAN_PRIORITY, p.PLAN_SEQUENCE`,
      {
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: like(query.lineCode),
        modelName: like(query.modelName),
        planStatus: like(query.planStatus),
        ...(hasWorkstage ? { workstageCode: like(query.workstageCode) } : {}),
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /** 등록·수정이 쓰는 컬럼 목록. 테이블별 추가 컬럼과 시간대 10칸을 합친다. */
  private editableColumns(cfg: PlanTableConfig): Array<[string, string]> {
    return [
      ...COMMON_COLUMNS.map(([c, f]) => [c, String(f)] as [string, string]),
      ...cfg.extraColumns.map(([c, f]) => [c, String(f)] as [string, string]),
      ...planTimeFieldPairs(),
    ];
  }

  /** NOT NULL 인데 비어 있는 것을 폼 대신 한 번 더 막는다. */
  private assertRequired(cfg: PlanTableConfig, dto: PlanUpsertDto) {
    const missing = cfg.required.filter(([field]) => {
      const value = dto[field];
      return value === undefined || value === null || String(value).trim() === '';
    });
    if (missing.length > 0) {
      throw new ConflictException(
        `${cfg.label}: ${missing.map(([, label]) => label).join(', ')} 은(는) 필수입니다.`,
      );
    }
  }

  async create(
    cfg: PlanTableConfig,
    dto: PlanUpsertDto,
    organizationId: number,
    userId: string,
  ) {
    this.assertRequired(cfg, dto);
    return this.tx.run(async (qr) => {
      // 순번을 안 주면 그 날짜의 최대순번 + 1. 같은 트랜잭션 안에서 읽고 넣는다.
      let sequence = dto.planSequence;
      if (sequence === undefined || sequence === null) {
        const rows = (await qr.query(
          `SELECT NVL(MAX(PLAN_SEQUENCE), 0) + 1 AS NEXT_SEQ FROM ${cfg.table}
            WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
              AND ORGANIZATION_ID = :organizationId`,
          { planDate: dto.planDate, organizationId } as unknown as unknown[],
        )) as Array<{ NEXT_SEQ: number }>;
        sequence = Number(rows?.[0]?.NEXT_SEQ ?? 1);
      } else {
        const dup = (await qr.query(
          `SELECT COUNT(*) AS CNT FROM ${cfg.table}
            WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
              AND PLAN_SEQUENCE = :planSequence
              AND ORGANIZATION_ID = :organizationId`,
          {
            planDate: dto.planDate,
            planSequence: sequence,
            organizationId,
          } as unknown as unknown[],
        )) as Array<{ CNT: number }>;
        if (Number(dup?.[0]?.CNT ?? 0) > 0) {
          throw new ConflictException(
            `이미 있는 계획입니다: ${dto.planDate} / 순번 ${sequence}`,
          );
        }
      }

      const columns = ['PLAN_DATE', 'PLAN_SEQUENCE', 'ORGANIZATION_ID', 'MFS'];
      const values = [
        `TO_DATE(:planDate, 'YYYY-MM-DD')`,
        ':planSequence',
        ':organizationId',
        // MFS 는 NOT NULL 이고 롯트카드가 붙기 전에는 '*' 다 (가이드 3번)
        `'*'`,
      ];
      const binds: Record<string, unknown> = {
        planDate: dto.planDate,
        planSequence: sequence,
        organizationId,
        userId,
      };
      for (const [column, field] of this.editableColumns(cfg)) {
        columns.push(column);
        values.push(`:${field}`);
        binds[field] = (dto as unknown as Record<string, unknown>)[field] ?? null;
      }
      columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
      values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

      await qr.query(
        `INSERT INTO ${cfg.table} (${columns.join(', ')}) VALUES (${values.join(', ')})`,
        binds as unknown as unknown[],
      );
      return { planDate: dto.planDate, planSequence: sequence };
    });
  }

  async update(
    cfg: PlanTableConfig,
    dto: PlanUpsertDto,
    organizationId: number,
    userId: string,
  ) {
    this.assertRequired(cfg, dto);
    if (dto.planSequence === undefined || dto.planSequence === null) {
      throw new ConflictException('수정에는 계획순번이 필요합니다.');
    }
    return this.tx.run(async (qr) => {
      const binds: Record<string, unknown> = {
        planDate: dto.planDate,
        planSequence: dto.planSequence,
        organizationId,
        userId,
      };
      const sets: string[] = [];
      for (const [column, field] of this.editableColumns(cfg)) {
        sets.push(`${column} = :${field}`);
        binds[field] = (dto as unknown as Record<string, unknown>)[field] ?? null;
      }
      sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

      const result = await qr.query(
        `UPDATE ${cfg.table} SET ${sets.join(', ')}
          WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
            AND PLAN_SEQUENCE = :planSequence
            AND ORGANIZATION_ID = :organizationId`,
        binds as unknown as unknown[],
      );
      const affected = Number((result as { rowsAffected?: number })?.rowsAffected ?? 0);
      if (affected === 0) {
        throw new NotFoundException(
          `${cfg.label}을 찾을 수 없습니다: ${dto.planDate} / 순번 ${dto.planSequence}`,
        );
      }
      return { changed: affected };
    });
  }

  /**
   * 삭제 — 롯트카드가 붙어 있으면 거부한다.
   * MFS 가 '*' 가 아니면 그 번호의 롯트카드가 이 계획을 물고 있다는 뜻이다.
   * PB 는 이 검사를 하지 않아 롯트카드가 없는 계획을 가리키게 됐다.
   */
  async remove(cfg: PlanTableConfig, key: PlanKeyDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const rows = (await qr.query(
        `SELECT NVL(MFS, '*') AS MFS FROM ${cfg.table}
          WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
            AND PLAN_SEQUENCE = :planSequence
            AND ORGANIZATION_ID = :organizationId`,
        {
          planDate: key.planDate,
          planSequence: key.planSequence,
          organizationId,
        } as unknown as unknown[],
      )) as Array<{ MFS: string }>;
      const mfs = rows?.[0]?.MFS;
      if (mfs === undefined) {
        throw new NotFoundException(
          `${cfg.label}을 찾을 수 없습니다: ${key.planDate} / 순번 ${key.planSequence}`,
        );
      }
      if (mfs !== '*') {
        throw new ConflictException(
          `롯트카드 ${mfs} 가 이 계획을 쓰고 있습니다. 롯트카드를 먼저 지우세요.`,
        );
      }

      const result = await qr.query(
        `DELETE FROM ${cfg.table}
          WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
            AND PLAN_SEQUENCE = :planSequence
            AND ORGANIZATION_ID = :organizationId`,
        {
          planDate: key.planDate,
          planSequence: key.planSequence,
          organizationId,
        } as unknown as unknown[],
      );
      return { deleted: Number((result as { rowsAffected?: number })?.rowsAffected ?? 0) };
    });
  }

  /** 확정·해제 — CONFIRM_YN/BY/DATE 를 한 번에 바꾼다. */
  async setConfirm(
    cfg: PlanTableConfig,
    dto: PlanConfirmDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `UPDATE ${cfg.table}
            SET CONFIRM_YN = :confirmYn,
                CONFIRM_BY = CASE WHEN :confirmYn = 'Y' THEN :userId ELSE NULL END,
                CONFIRM_DATE = CASE WHEN :confirmYn = 'Y' THEN SYSDATE ELSE NULL END,
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
            AND PLAN_SEQUENCE = :planSequence
            AND ORGANIZATION_ID = :organizationId
            AND NVL(CONFIRM_YN, 'N') <> :confirmYn`,
        {
          confirmYn: dto.confirmYn,
          userId,
          planDate: dto.planDate,
          planSequence: dto.planSequence,
          organizationId,
        } as unknown as unknown[],
      );
      const affected = Number((result as { rowsAffected?: number })?.rowsAffected ?? 0);
      // 0건은 "없는 계획" 과 "이미 그 상태" 두 가지다 — 구분해서 알려준다.
      if (affected === 0) {
        const rows = (await qr.query(
          `SELECT NVL(CONFIRM_YN, 'N') AS CONFIRM_YN FROM ${cfg.table}
            WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
              AND PLAN_SEQUENCE = :planSequence
              AND ORGANIZATION_ID = :organizationId`,
          {
            planDate: dto.planDate,
            planSequence: dto.planSequence,
            organizationId,
          } as unknown as unknown[],
        )) as Array<{ CONFIRM_YN: string }>;
        if (rows.length === 0) {
          throw new NotFoundException(
            `${cfg.label}을 찾을 수 없습니다: ${dto.planDate} / 순번 ${dto.planSequence}`,
          );
        }
        return { changed: 0, alreadySet: true, confirmYn: dto.confirmYn };
      }
      return { changed: affected, alreadySet: false, confirmYn: dto.confirmYn };
    });
  }
}
