/**
 * @file src/modules/smt/smt-bom.service.ts
 * @description SMT BOM 관리 + BOM 관리리포트
 *              PB w_smt_bom_create_master / w_smt_bom_master_rpt 이식
 *
 * 초보자 가이드:
 * 1. **SMT BOM 은 "이 모델의 이 자리에 이 부품" 표다.** 키가 일곱 컬럼 + 조직인데
 *    자리(LOCATION_CODE)와 설비(MACHINE)가 키에 들어 있어서다. 같은 부품이
 *    여러 자리에 물리면 여러 행이다.
 * 2. **모델명이 필수다.** 28,417행이라 모델을 안 정하면 전부 끌어온다.
 *    PB retrieve 도 `PARENT_ITEM_CODE = :ARG_PARENT_ITEM` 로 등호였다.
 * 3. **적용기간 방식이 PB 와 같다.** `DATESET <= 기준일` 이고
 *    `NVL(DATEEND, 9999-12-31) >= 기준일` 이다. DATEEND 가 NOT NULL 이지만
 *    PB 가 NVL 을 쓰고 있었으므로 유지한다.
 * 4. **일괄작업 세 개는 PKG_MES_SMT 안에 있다** — 라인 교체 / 모델명 변경 / 범위 삭제.
 *    PB 는 라인 교체를 '-X' 임시접미어 네 단계 UPDATE 로 했다. 그 순서를 깨면
 *    중간에 키가 겹친다.
 * 5. **PB 의 '위치 주소 일괄이동' 은 옮기지 않았다.** PB 조건이
 *    `length(location_code) = 4` 인데 이 DB 28,417행 중 길이 4인 행이 0이다
 *    (길이 3이 28,162행, 7이 252행, 2가 3행). 은성에서는 아무 행도 안 바뀌는
 *    죽은 기능이고, 조건을 고쳐 옮기면 PB 가 0행 건드리던 대량 UPDATE 가
 *    28,162행을 건드리게 된다. 필요하면 별도로 합의해 넣는다.
 * 6. **BOM 관리리포트는 라벨·바코드용 목록이다.** PB 가 `'*'||값||'*'` 로 만들던
 *    코드39 바코드 문자열을 그대로 내린다. PB 의 프린터 드라이버 라벨 레이아웃은
 *    옮기지 않았다.
 */
import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  SmtBomDeleteScopeDto,
  SmtBomKeyDto,
  SmtBomLineSwapDto,
  SmtBomModelRenameDto,
  SmtBomQueryDto,
  SmtBomReportQueryDto,
  SmtBomUpsertDto,
} from './smt-bom.dto';

const EDITABLE: Array<[column: string, field: keyof SmtBomUpsertDto]> = [
  ['ITEM_UNIT_QTY', 'itemUnitQty'],
  ['SORT_SEQUENCE', 'sortSequence'],
  ['WORKSTAGE_CODE', 'workstageCode'],
  ['ITEM_TYPE', 'itemType'],
  ['LINE_TYPE', 'lineType'],
  ['SMT_MODEL_NAME', 'smtModelName'],
  ['TABLE_ID', 'tableId'],
  ['REVISION', 'revision'],
  ['FEEDER_SHAFT', 'feederShaft'],
  ['FEEDER_TYPE', 'feederType'],
  ['LOCATION_INFO', 'locationInfo'],
  ['COMMENTS', 'comments'],
  ['BOM_LEVEL', 'bomLevel'],
  ['MODEL_NAME', 'modelName'],
];

@Injectable()
export class SmtBomService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_des_bom_smt_create_lst. */
  async find(query: SmtBomQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.PARENT_ITEM_CODE AS "parentItemCode",
              b.CHILD_ITEM_CODE AS "childItemCode",
              b.LINE_CODE AS "lineCode", b.MACHINE AS "machine",
              b.LOCATION_CODE AS "locationCode",
              b.LOCATION_INFO AS "locationInfo",
              b.PCB_ITEM AS "pcbItem", pcb.CODE_MEAN_KOR AS "pcbItemName",
              b.TABLE_ID AS "tableId",
              TO_CHAR(b.DATESET, 'YYYY-MM-DD') AS "dateSet",
              TO_CHAR(b.DATEEND, 'YYYY-MM-DD') AS "dateEnd",
              b.SORT_SEQUENCE AS "sortSequence", b.ITEM_UNIT_QTY AS "itemUnitQty",
              b.WORKSTAGE_CODE AS "workstageCode", b.BOM_LEVEL AS "bomLevel",
              b.ITEM_TYPE AS "itemType", it.CODE_MEAN_KOR AS "itemTypeName",
              b.LINE_TYPE AS "lineType", lt.CODE_MEAN_KOR AS "lineTypeName",
              b.REVISION AS "revision", b.FEEDER_SHAFT AS "feederShaft",
              b.FEEDER_TYPE AS "feederType",
              b.SMT_MODEL_NAME AS "smtModelName", b.MODEL_NAME AS "modelName",
              b.COMMENTS AS "comments",
              c.ITEM_NAME AS "childItemName", c.ITEM_SPEC AS "childItemSpec",
              c.ITEM_UOM AS "childItemUom", uom.CODE_MEAN_KOR AS "childItemUomName",
              p.ITEM_NAME AS "parentItemName", p.ITEM_SPEC AS "parentItemSpec",
              b.ENTER_BY AS "enterBy", b.ENTER_DATE AS "enterDate",
              b.LAST_MODIFY_BY AS "lastModifyBy", b.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM ID_ENG_BOM_SMT b
         LEFT JOIN ID_ITEM c
                ON c.ITEM_CODE = b.CHILD_ITEM_CODE
               AND c.ORGANIZATION_ID = b.ORGANIZATION_ID
         LEFT JOIN ID_ITEM p
                ON p.ITEM_CODE = b.PARENT_ITEM_CODE
               AND p.ORGANIZATION_ID = b.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE it
                ON it.CODE_TYPE = 'ITEM TYPE' AND it.CODE_NAME = b.ITEM_TYPE
         LEFT JOIN ISYS_BASECODE lt
                ON lt.CODE_TYPE = 'LINE TYPE' AND lt.CODE_NAME = b.LINE_TYPE
         LEFT JOIN ISYS_BASECODE pcb
                ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = b.PCB_ITEM
         LEFT JOIN ISYS_BASECODE uom
                ON uom.CODE_TYPE = 'ITEM UOM' AND uom.CODE_NAME = c.ITEM_UOM
        WHERE b.ORGANIZATION_ID = :organizationId
          AND b.PARENT_ITEM_CODE = :modelName
          AND NVL(b.LINE_CODE, '*') LIKE :lineCode
          AND NVL(b.MACHINE, '*') LIKE :machine
          AND NVL(b.PCB_ITEM, '*') LIKE :pcbItem
          AND NVL(b.REVISION, '0000') LIKE :revision
          AND NVL(b.FEEDER_SHAFT, '*') LIKE :feederShaft
          AND b.DATESET <= TO_DATE(:dateSet, 'YYYY-MM-DD')
          AND NVL(b.DATEEND, TO_DATE('99991231', 'YYYYMMDD')) >= TO_DATE(:dateSet, 'YYYY-MM-DD')
        ORDER BY b.LINE_CODE, b.MACHINE, b.TABLE_ID,
                 SUBSTR(b.LOCATION_CODE, 2), b.SORT_SEQUENCE`,
      {
          organizationId,
          modelName: query.modelName.trim(),
          lineCode: this.like(query.lineCode),
          machine: this.like(query.machine),
          pcbItem: this.like(query.pcbItem),
          revision: this.like(query.revision),
          feederShaft: this.like(query.feederShaft),
          dateSet: query.dateSet ?? new Date().toISOString().slice(0, 10),
        } as unknown as unknown[],
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /** 모델 셀렉터 원천 — PB d_smt_bom_model_list (IP_PRODUCT_MODEL_MASTER, 327행). */
  async findModels(organizationId: number) {
    return (await this.dataSource.query(
      `SELECT DISTINCT m.MODEL_NAME AS "modelName", m.MODEL_SUFFIX AS "modelSuffix"
         FROM IP_PRODUCT_MODEL_MASTER m
        WHERE m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MODEL_NAME`,
      { organizationId } as unknown as unknown[],
    )) as Record<string, unknown>[];
  }

  private keyBinds(key: SmtBomKeyDto, organizationId: number) {
    return {
      parentItemCode: key.parentItemCode,
      childItemCode: key.childItemCode,
      dateSet: key.dateSet,
      locationCode: key.locationCode,
      lineCode: key.lineCode,
      machine: key.machine,
      pcbItem: key.pcbItem,
      organizationId,
    };
  }

  private readonly KEY_WHERE = `
    PARENT_ITEM_CODE = :parentItemCode
    AND CHILD_ITEM_CODE = :childItemCode
    AND DATESET = TO_DATE(:dateSet, 'YYYY-MM-DD')
    AND LOCATION_CODE = :locationCode
    AND LINE_CODE = :lineCode
    AND MACHINE = :machine
    AND PCB_ITEM = :pcbItem
    AND ORGANIZATION_ID = :organizationId`;

  async create(dto: SmtBomUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const [dup] = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM ID_ENG_BOM_SMT WHERE ${this.KEY_WHERE}`,
        [this.keyBinds(dto, organizationId)] as unknown as unknown[],
      )) as { CNT: number }[];
      if (Number(dup?.CNT ?? 0) > 0) {
        throw new ConflictException('이미 있는 BOM 행입니다 (같은 모델·라인·설비·자리·면).');
      }

      const columns = [
        'PARENT_ITEM_CODE', 'CHILD_ITEM_CODE', 'LOCATION_CODE',
        'LINE_CODE', 'MACHINE', 'PCB_ITEM', 'ORGANIZATION_ID', 'DATESET', 'DATEEND',
      ];
      const values = [
        ':parentItemCode', ':childItemCode', ':locationCode',
        ':lineCode', ':machine', ':pcbItem', ':organizationId',
        `TO_DATE(:dateSet, 'YYYY-MM-DD')`, `TO_DATE(:dateEnd, 'YYYY-MM-DD')`,
      ];
      const binds: Record<string, unknown> = {
        ...this.keyBinds(dto, organizationId),
        dateEnd: dto.dateEnd,
        userId,
      };
      for (const [column, field] of EDITABLE) {
        columns.push(column);
        values.push(`:${field}`);
        // WORKSTAGE_CODE 는 NOT NULL 이고 이 DB 는 전부 '*' 다 (DTO 주석 참고)
        binds[field] = dto[field] ?? (field === 'workstageCode' ? '*' : null);
      }
      columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
      values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

      await qr.query(
        `INSERT INTO ID_ENG_BOM_SMT (${columns.join(', ')}) VALUES (${values.join(', ')})`,
        binds as unknown as unknown[],
      );
      return { created: 1 };
    });
  }

  async update(dto: SmtBomUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const binds: Record<string, unknown> = {
        ...this.keyBinds(dto, organizationId),
        dateEnd: dto.dateEnd,
        userId,
      };
      const sets = [`DATEEND = TO_DATE(:dateEnd, 'YYYY-MM-DD')`];
      for (const [column, field] of EDITABLE) {
        sets.push(`${column} = :${field}`);
        // WORKSTAGE_CODE 는 NOT NULL 이고 이 DB 는 전부 '*' 다 (DTO 주석 참고)
        binds[field] = dto[field] ?? (field === 'workstageCode' ? '*' : null);
      }
      sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

      const result = await qr.query(
        `UPDATE ID_ENG_BOM_SMT SET ${sets.join(', ')} WHERE ${this.KEY_WHERE}`,
        binds as unknown as unknown[],
      );
      const affected = Number((result as { rowsAffected?: number })?.rowsAffected ?? 0);
      if (affected === 0) throw new NotFoundException('BOM 행을 찾을 수 없습니다.');
      return { changed: affected };
    });
  }

  async remove(key: SmtBomKeyDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DELETE FROM ID_ENG_BOM_SMT WHERE ${this.KEY_WHERE}`,
        [this.keyBinds(key, organizationId)] as unknown as unknown[],
      );
      const affected = Number((result as { rowsAffected?: number })?.rowsAffected ?? 0);
      if (affected === 0) throw new NotFoundException('BOM 행을 찾을 수 없습니다.');
      return { deleted: affected };
    });
  }

  /**
   * 프로시저를 돌린다. 음수 결과는 marker 를 실은 ORA 예외로 올라오고,
   * toError 가 그 코드를 이 화면의 말로 바꾼다.
   *
   * OUT 바인드를 쓰지 않는다 — 이 저장소는 서비스에서 oracledb 를 직접 쓰지 않는다.
   * 그래서 "몇 건 바뀌었나" 는 호출한 쪽이 전후를 세어 구한다.
   */
  private async runProcedure(
    qr: { query: (sql: string, params?: unknown[]) => Promise<unknown> },
    call: string,
    marker: string,
    binds: Record<string, unknown>,
    toError: (code: number) => Error,
  ) {
    await qr
      .query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           ${call}
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20033, '${marker}:' || v_result);
           END IF;
         END;`,
        binds as unknown as unknown[],
      )
      .catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        const matched = new RegExp(`${marker}:(-?\d+)`).exec(message);
        if (!matched) throw error;
        throw toError(Number(matched[1]));
      });
  }

  /** 라인 교체 — PKG_MES_SMT.SP_SMT_BOM_LINE_SWAP. */
  async swapLines(dto: SmtBomLineSwapDto, organizationId: number, userId: string) {
    if (dto.lineCode1 === dto.lineCode2) {
      throw new BadRequestException('두 라인코드가 같습니다.');
    }
    return this.tx.run(async (qr) => {
      const before = await this.countByLines(qr, dto, organizationId);
      await this.runProcedure(
        qr,
        `PKG_MES_SMT.SP_SMT_BOM_LINE_SWAP(
           :lineCode1, :lineCode2, :organizationId, :userId, v_result);`,
        'SMT_BOM_LINE_SWAP_FAILED',
        { lineCode1: dto.lineCode1, lineCode2: dto.lineCode2, organizationId, userId },
        (code) => {
          if (code === -1) return new BadRequestException('두 라인코드가 같습니다.');
          if (code === -2) {
            return new ConflictException(
              "'-X' 로 끝나는 임시 라인코드가 이미 데이터에 있습니다. 먼저 정리하세요.",
            );
          }
          if (code === -3) return new NotFoundException('두 라인 중 한쪽에 BOM 이 없습니다.');
          return new BadRequestException(`라인 교체 실패 (${code})`);
        },
      );
      const after = await this.countByLines(qr, dto, organizationId);
      return { line1: after.line1, line2: after.line2, before };
    });
  }

  private async countByLines(
    qr: { query: <T>(sql: string, params?: unknown[]) => Promise<T> },
    dto: SmtBomLineSwapDto,
    organizationId: number,
  ) {
    const rows = (await qr.query(
      `SELECT LINE_CODE, COUNT(*) AS CNT FROM ID_ENG_BOM_SMT
        WHERE LINE_CODE IN (:lineCode1, :lineCode2)
          AND ORGANIZATION_ID = :organizationId
        GROUP BY LINE_CODE`,
      { lineCode1: dto.lineCode1, lineCode2: dto.lineCode2, organizationId } as unknown as unknown[],
    )) as { LINE_CODE: string; CNT: number }[];
    const find = (code: string) =>
      Number(rows.find((r) => r.LINE_CODE === code)?.CNT ?? 0);
    return { line1: find(dto.lineCode1), line2: find(dto.lineCode2) };
  }

  /** 모델명 변경 — PKG_MES_SMT.SP_SMT_BOM_MODEL_RENAME. */
  async renameModel(dto: SmtBomModelRenameDto, organizationId: number, userId: string) {
    if (dto.oldModelName === dto.newModelName) {
      throw new BadRequestException('바꿀 모델명이 현재와 같습니다.');
    }
    return this.tx.run(async (qr) => {
      await this.runProcedure(
        qr,
        `PKG_MES_SMT.SP_SMT_BOM_MODEL_RENAME(
           :oldModelName, :newModelName, :organizationId, :userId, v_result);`,
        'SMT_BOM_RENAME_FAILED',
        {
          oldModelName: dto.oldModelName,
          newModelName: dto.newModelName,
          organizationId,
          userId,
        },
        (code) => {
          if (code === -1) return new NotFoundException(`BOM 이 없습니다: ${dto.oldModelName}`);
          if (code === -2) {
            return new ConflictException(`이미 쓰는 모델명입니다: ${dto.newModelName}`);
          }
          return new BadRequestException(`모델명 변경 실패 (${code})`);
        },
      );
      const rows = (await qr.query(
        `SELECT
           (SELECT COUNT(*) FROM ID_ENG_BOM_SMT
             WHERE PARENT_ITEM_CODE = :newModelName AND ORGANIZATION_ID = :organizationId)
         + (SELECT COUNT(*) FROM ID_ENG_BOM_SMT_REPLACE
             WHERE PARENT_ITEM_CODE = :newModelName AND ORGANIZATION_ID = :organizationId)
         + (SELECT COUNT(*) FROM IB_PRODUCT_PLANDATA
             WHERE MODEL_NAME = :newModelName AND ORGANIZATION_ID = :organizationId)
           AS CNT FROM DUAL`,
        { newModelName: dto.newModelName, organizationId } as unknown as unknown[],
      )) as { CNT: number }[];
      return { newModelName: dto.newModelName, rows: Number(rows?.[0]?.CNT ?? 0) };
    });
  }

  /** 범위 삭제 — PKG_MES_SMT.SP_SMT_BOM_DELETE_SCOPE. */
  async deleteScope(dto: SmtBomDeleteScopeDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const pcb = `${dto.pcbItem ?? ''}%`;
      const [before] = (await qr.query(
        `SELECT (SELECT COUNT(*) FROM ID_ENG_BOM_SMT
                  WHERE PARENT_ITEM_CODE = :modelName AND LINE_CODE = :lineCode
                    AND NVL(PCB_ITEM, '*') LIKE :pcb AND ORGANIZATION_ID = :organizationId)
              + (SELECT COUNT(*) FROM ID_ENG_BOM_SMT_REPLACE
                  WHERE PARENT_ITEM_CODE = :modelName AND LINE_CODE = :lineCode
                    AND NVL(PCB_ITEM, '*') LIKE :pcb AND ORGANIZATION_ID = :organizationId)
                AS CNT FROM DUAL`,
        { modelName: dto.modelName, lineCode: dto.lineCode, pcb, organizationId } as unknown as unknown[],
      )) as { CNT: number }[];
      await this.runProcedure(
        qr,
        `PKG_MES_SMT.SP_SMT_BOM_DELETE_SCOPE(
           :modelName, :lineCode, :pcb, :organizationId, v_result);`,
        'SMT_BOM_DELETE_SCOPE_FAILED',
        { modelName: dto.modelName, lineCode: dto.lineCode, pcb, organizationId },
        (code) => {
          if (code === -1) return new NotFoundException('지울 BOM 이 없습니다.');
          // 프로시저가 -2 * 계획건수 로 실어 보낸다
          return new ConflictException(
            `배포된 계획 ${Math.abs(code) / 2}건이 이 BOM 을 쓰고 있습니다. 계획을 먼저 지우세요.`,
          );
        },
      );
      return { deleted: Number(before?.CNT ?? 0) };
    });
  }

  /**
   * BOM 관리리포트 — PB d_smt_plandata_list_rpt.
   *
   * SQL 안에서 불리던 DB 함수 네 개를 그대로 호출한다. TypeScript 로 다시
   * 구현하지 않는다 — 캐리어 크기·확정단가·PCB면 판정이 PB 와 갈리면 라벨이 틀린다.
   *   f_get_carrier_size / f_get_mat_max_unit_price_cfm / F_GET_PCB_ITEM_BY_NAME
   */
  async findReport(query: SmtBomReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT d.REPLACE_YN AS "replaceYn",
              d.MODEL_NAME AS "modelName", d.ITEM_CODE AS "itemCode",
              d.ITEM_UNIT_QTY * f_get_carrier_size(d.MODEL_NAME, d.ORGANIZATION_ID)
                AS "itemUnitQty",
              a.ITEM_NAME AS "itemName", a.ITEM_SPEC AS "itemSpec",
              a.ITEM_UOM AS "itemUom", a.LOCATION_ADDRESS AS "locationAddress",
              a.FEEDER_SIZE AS "feederType", a.MSL_LEVEL AS "mslLevel",
              b.ITEM_NAME AS "parentItemName", b.ITEM_SPEC AS "parentItemSpec",
              d.LOCATION_CODE AS "locationCode", d.LINE_CODE AS "lineCode",
              d.MACHINE AS "machine", d.TABLE_ID AS "tableId",
              d.PCB_ITEM AS "pcbItem", d.REVISION AS "revision",
              lm.LINE_NAME AS "lineName", lm.MACHINE_NAME AS "machineName",
              lm.LINE_DIVISION AS "lineDivision",
              '*' || d.LINE_CODE || '-' || d.MACHINE || '*' AS "lineCodeBarcode",
              '*' || d.LOCATION_CODE || '*' AS "locationBarcode",
              '*' || d.MODEL_NAME || '*' AS "parentItemBarcode",
              F_GET_PCB_ITEM_BY_NAME(:modelName) AS "pcbItemCode",
              '*' || F_GET_PCB_ITEM_BY_NAME(:modelName) || '*' AS "pcbItemBarcode",
              f_get_mat_max_unit_price_cfm(d.ITEM_CODE, 'F', TRUNC(SYSDATE), 1)
                AS "unitPrice"
         FROM IB_PRODUCT_PLANDATA d
         LEFT JOIN ID_ITEM a
                ON a.ITEM_CODE = d.ITEM_CODE AND a.ORGANIZATION_ID = d.ORGANIZATION_ID
         LEFT JOIN ID_ITEM b
                ON b.ITEM_CODE = d.MODEL_NAME AND b.ORGANIZATION_ID = d.ORGANIZATION_ID
         LEFT JOIN IB_LINE_MASTER lm
                ON lm.LINE_CODE = d.LINE_CODE AND lm.MACHINE = d.MACHINE
               AND lm.ORGANIZATION_ID = d.ORGANIZATION_ID
        WHERE d.ORGANIZATION_ID = :organizationId
          AND d.MODEL_NAME = :modelName
          AND NVL(d.LINE_CODE, '*') LIKE :lineCode
          AND NVL(d.PCB_ITEM, '*') LIKE :pcbItem
          AND NVL(d.REVISION, '0000') LIKE :revision
        ORDER BY d.LINE_CODE, d.MACHINE, d.TABLE_ID, SUBSTR(d.LOCATION_CODE, 2)`,
      {
          organizationId,
          modelName: query.modelName.trim(),
          lineCode: this.like(query.lineCode),
          pcbItem: this.like(query.pcbItem),
          revision: this.like(query.revision),
        } as unknown as unknown[],
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }
}
