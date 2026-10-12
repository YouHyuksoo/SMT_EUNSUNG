/**
 * @file src/modules/jig/jig-master.service.ts
 * @description 지그마스터 — PB w_mcn_jig_master 이식
 *
 * 초보자 가이드:
 * 1. **키**: IMCN_JIG 는 JIG_CODE + JIG_LOT_NO + ORGANIZATION_ID 가 유일하다(XPKIMCN_JIG).
 *    PB 는 ROWID 로 단건을 잡지만 웹은 이 복합키를 쓴다.
 * 2. **감사컬럼**: PB f_set_security_row 가 하던 일이다. 본문으로 받지 않고
 *    등록 시 ENTER_BY/ENTER_DATE + LAST_MODIFY_*, 수정 시 LAST_MODIFY_* 만 서버가 채운다.
 * 3. **적용모델 복사**: 로직은 이 서비스가 아니라 PKG_MES_MAC.SP_COPY_APPLY_MODEL 에 있다.
 *    PB 화면과 웹이 같은 DB 오브젝트를 호출해야 결과가 갈리지 않는다.
 * 4. **키 변경**: 수정 본문에 originalJigCode/originalJigLotNo 가 오고 새 키와 다르면
 *    IMCN_JIG 와 IMCN_JIG_APPLY_MODEL 의 키만 한 트랜잭션으로 바꾼다. 이력 테이블은 옛 키로 남긴다.
 *    FK 가 없으므로 중복·장착 여부는 이 서비스가 먼저 확인한다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  JigApplyModelCopyDto,
  JigApplyModelQueryDto,
  JigMasterQueryDto,
  JigMasterUpsertDto,
} from './jig-master.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type OracleRow = Record<string, unknown>;

/** 등록·수정에서 사용자가 값을 넣는 컬럼. 감사컬럼은 여기에 없다. */
const EDITABLE: Array<[column: string, field: keyof JigMasterUpsertDto]> = [
  ['JIG_NAME', 'jigName'], ['JIG_TYPE', 'jigType'], ['JIG_STATUS', 'jigStatus'],
  ['USE_STATUS', 'useStatus'], ['ACQUISITION_TYPE', 'acquisitionType'],
  ['JIG_MODEL_NAME', 'jigModelName'], ['LINE_CODE', 'lineCode'],
  ['WORKSTAGE_CODE', 'workstageCode'], ['MACHINE_CODE', 'machineCode'],
  ['CUSTOMER_CODE', 'customerCode'], ['SUPPLIER_CODE', 'supplierCode'],
  ['NATION_CODE', 'nationCode'], ['ITEM_CODE', 'itemCode'], ['JIG_SPEC', 'jigSpec'],
  ['PCB_ITEM', 'pcbItem'], ['SOLDER_TYPE', 'solderType'], ['CAPACITY_UOM', 'capacityUom'],
  ['LOCATION_ADDRESS', 'locationAddress'], ['MANUAL_LOCATION_COMMENT', 'manualLocationComment'],
  ['MANAGEMENT_COMMNETS', 'managementCommnets'], ['USE_TPM_YN', 'useTpmYn'],
  ['USE_NSNP_YN', 'useNsnpYn'], ['TENSION_CHECK_YN', 'tensionCheckYn'],
  ['CAPACITY', 'capacity'], ['RESERVED_CAPACITY', 'reservedCapacity'],
  ['USE_RATE', 'useRate'], ['UPH_VALUE', 'uphValue'], ['BREAK_VALUE', 'breakValue'],
  ['HIT_VALUE', 'hitValue'], ['MIN_TENSION', 'minTension'], ['MAX_TENSION', 'maxTension'],
];

/** TO_DATE 로 넣어야 하는 날짜 컬럼 */
const DATE_FIELDS: Array<[column: string, field: keyof JigMasterUpsertDto]> = [
  ['ACQUISITION_DATE', 'acquisitionDate'], ['RECEIPT_DATE', 'receiptDate'],
  ['LAST_INSPECT_DATE', 'lastInspectDate'], ['ISSUE_DATE', 'issueDate'],
  ['DESTROY_DATE', 'destroyDate'],
];

/** IMCN_JIG_APPLY_MODEL.JIG_LOT_NO 칸 길이. 키를 바꿀 때 새 LOT 이 이보다 길면 막는다. */
const APPLY_MODEL_LOT_MAX = 50;

/**
 * IP_PRODUCT_LINE 에서 지금 장착된 지그LOT 을 담는 칸.
 * 직전 장착(LAST_*) 칸은 보지 않는다 — 라인에서 뗀 지그는 바꿀 수 있어야 한다(2026-10-12 현장 결정).
 */
const MOUNT_COLUMNS: Array<[column: string, label: string]> = [
  ['MASK_LOT_NO', '메탈마스크'], ['MASK_LOT_NO2', '메탈마스크2'],
  ['SQUEEZE_LOT_NO', '스퀴즈'], ['SQUEEZE_LOT_NO2', '스퀴즈2'], ['SQUEZE_LOT_NO', '스퀴즈(검사)'],
];

@Injectable()
export class JigMasterService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** PB 규약: 빈 값이면 '%' 가 되어 전체를 조회한다. */
  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /**
   * 목록 — PB d_mcn_jig_lst.
   * 코드컬럼은 그리드에 코드가 아니라 뜻이 보이도록 기초코드·기준정보 이름을 함께 내린다.
   */
  async find(query: JigMasterQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      jigCode: this.like(query.jigCode),
      jigLotNo: this.like(query.jigLotNo),
      jigType: this.like(query.jigType),
      lineCode: this.like(query.lineCode),
      jigStatus: this.like(query.jigStatus),
      jigModelName: this.like(query.jigModelName),
    };
    const body = `
      SELECT j.JIG_CODE AS "jigCode", j.JIG_LOT_NO AS "jigLotNo", j.JIG_NAME AS "jigName",
             j.JIG_TYPE AS "jigType", tp.CODE_MEAN_KOR AS "jigTypeName",
             j.JIG_STATUS AS "jigStatus", stt.CODE_MEAN_KOR AS "jigStatusName",
             j.USE_STATUS AS "useStatus", ust.CODE_MEAN_KOR AS "useStatusName",
             j.ACQUISITION_TYPE AS "acquisitionType", acq.CODE_MEAN_KOR AS "acquisitionTypeName",
             j.PCB_ITEM AS "pcbItem", pcb.CODE_MEAN_KOR AS "pcbItemName",
             j.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             j.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             j.MACHINE_CODE AS "machineCode",
             j.ITEM_CODE AS "itemCode", j.JIG_MODEL_NAME AS "jigModelName",
             j.JIG_SPEC AS "jigSpec", j.SOLDER_TYPE AS "solderType",
             j.CUSTOMER_CODE AS "customerCode", j.SUPPLIER_CODE AS "supplierCode",
             j.NATION_CODE AS "nationCode",
             j.CAPACITY AS "capacity", j.CAPACITY_UOM AS "capacityUom",
             j.RESERVED_CAPACITY AS "reservedCapacity", j.USE_RATE AS "useRate",
             j.UPH_VALUE AS "uphValue", j.BREAK_VALUE AS "breakValue", j.HIT_VALUE AS "hitValue",
             j.MIN_TENSION AS "minTension", j.MAX_TENSION AS "maxTension",
             j.TENSION_CHECK_YN AS "tensionCheckYn", j.USE_TPM_YN AS "useTpmYn",
             j.USE_NSNP_YN AS "useNsnpYn",
             j.LOCATION_ADDRESS AS "locationAddress",
             j.MANUAL_LOCATION_COMMENT AS "manualLocationComment",
             j.MANAGEMENT_COMMNETS AS "managementCommnets",
             j.ACQUISITION_DATE AS "acquisitionDate", j.RECEIPT_DATE AS "receiptDate",
             j.LAST_INSPECT_DATE AS "lastInspectDate", j.ISSUE_DATE AS "issueDate",
             j.DESTROY_DATE AS "destroyDate",
             j.JIG_IMAGE_FILE_NAME AS "jigImageFileName",
             j.ENTER_BY AS "enterBy", j.ENTER_DATE AS "enterDate",
             j.LAST_MODIFY_BY AS "lastModifyBy", j.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_JIG j
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = j.LINE_CODE AND ln.ORGANIZATION_ID = j.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_WORKSTAGE ws
               ON ws.WORKSTAGE_CODE = j.WORKSTAGE_CODE AND ws.ORGANIZATION_ID = j.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE tp
               ON tp.CODE_TYPE = 'JIG TYPE' AND tp.CODE_NAME = j.JIG_TYPE
              AND tp.ORGANIZATION_ID = j.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE stt
               ON stt.CODE_TYPE = 'JIG STATUS' AND stt.CODE_NAME = j.JIG_STATUS
              AND stt.ORGANIZATION_ID = j.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE ust
               ON ust.CODE_TYPE = 'USE STATUS' AND ust.CODE_NAME = j.USE_STATUS
              AND ust.ORGANIZATION_ID = j.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE acq
               ON acq.CODE_TYPE = 'ACQUISITION TYPE' AND acq.CODE_NAME = j.ACQUISITION_TYPE
              AND acq.ORGANIZATION_ID = j.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE pcb
               ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = j.PCB_ITEM
              AND pcb.ORGANIZATION_ID = j.ORGANIZATION_ID
       WHERE j.JIG_CODE LIKE :jigCode
         AND NVL(j.JIG_LOT_NO, '*') LIKE :jigLotNo
         AND j.JIG_TYPE LIKE :jigType
         AND NVL(j.LINE_CODE, '*') LIKE :lineCode
         AND NVL(j.JIG_STATUS, '*') LIKE :jigStatus
         AND NVL(j.JIG_MODEL_NAME, '*') LIKE :jigModelName
         AND j.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    // PB 정렬: jig_type A, jig_status D, jig_code A, jig_lot_no A
    const rows = await this.dataSource.query(
      `${body} ORDER BY "jigType", "jigStatus" DESC, "jigCode", "jigLotNo"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 적용모델 목록 — PB d_mcn_jig_apply_model_lst */
  async findApplyModels(query: JigApplyModelQueryDto, organizationId: number) {
    return this.dataSource.query<OracleRow[]>(
      `SELECT JIG_CODE AS "jigCode", JIG_LOT_NO AS "jigLotNo", ITEM_CODE AS "itemCode",
              APPLY_SMT_MODEL_NAME AS "applySmtModelName",
              ENTER_BY AS "enterBy", ENTER_DATE AS "enterDate",
              LAST_MODIFY_BY AS "lastModifyBy", LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IMCN_JIG_APPLY_MODEL
        WHERE JIG_CODE = :jigCode AND JIG_LOT_NO = :jigLotNo
          AND ORGANIZATION_ID = :organizationId
        ORDER BY ITEM_CODE`,
      namedBinds({ jigCode: query.jigCode, jigLotNo: query.jigLotNo, organizationId }),
    );
  }

  private async exists(jigCode: string, jigLotNo: string, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IMCN_JIG
        WHERE JIG_CODE = :jigCode AND JIG_LOT_NO = :jigLotNo AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ jigCode, jigLotNo, organizationId }),
    ) as OracleRow[];
    return Number(rows[0]?.cnt ?? 0) > 0;
  }

  /** 등록 — 감사컬럼은 PB f_set_security_row('ALL') 과 같은 값으로 서버가 채운다. */
  async create(dto: JigMasterUpsertDto, organizationId: number, userId: string) {
    if (await this.exists(dto.jigCode, dto.jigLotNo, organizationId)) {
      throw new ConflictException(`이미 등록된 지그입니다 (${dto.jigCode}/${dto.jigLotNo}).`);
    }
    const columns = ['JIG_CODE', 'JIG_LOT_NO', 'ORGANIZATION_ID'];
    const values = [':jigCode', ':jigLotNo', ':organizationId'];
    const binds: OracleRow = {
      jigCode: dto.jigCode, jigLotNo: dto.jigLotNo, organizationId, userId,
    };
    for (const [column, field] of EDITABLE) {
      columns.push(column);
      values.push(`:${field}`);
      binds[field] = dto[field] ?? null;
    }
    for (const [column, field] of DATE_FIELDS) {
      columns.push(column);
      values.push(`TO_DATE(:${field}, 'YYYY-MM-DD')`);
      binds[field] = dto[field] ?? null;
    }
    columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
    values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

    await this.dataSource.query(
      `INSERT INTO IMCN_JIG (${columns.join(', ')}) VALUES (${values.join(', ')})`,
      namedBinds(binds),
    );
    return { jigCode: dto.jigCode, jigLotNo: dto.jigLotNo };
  }

  /** 수정에서 사용자가 고치는 칸의 SET 절. 감사컬럼 LAST_MODIFY_* 도 여기서 붙는다. */
  private editableSets(dto: JigMasterUpsertDto, binds: OracleRow): string[] {
    const sets: string[] = [];
    for (const [column, field] of EDITABLE) {
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    for (const [column, field] of DATE_FIELDS) {
      sets.push(`${column} = TO_DATE(:${field}, 'YYYY-MM-DD')`);
      binds[field] = dto[field] ?? null;
    }
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');
    return sets;
  }

  /**
   * 수정 — PB f_set_security_row('MODIFY') 와 같이 LAST_MODIFY_* 만 갱신한다.
   * originalJigCode/originalJigLotNo 가 새 키와 다르면 키 변경(changeKey)으로 넘긴다.
   */
  async update(dto: JigMasterUpsertDto, organizationId: number, userId: string) {
    const fromCode = dto.originalJigCode || dto.jigCode;
    const fromLot = dto.originalJigLotNo || dto.jigLotNo;
    if (fromCode !== dto.jigCode || fromLot !== dto.jigLotNo) {
      return this.changeKey(dto, { jigCode: fromCode, jigLotNo: fromLot }, organizationId, userId);
    }
    if (!await this.exists(dto.jigCode, dto.jigLotNo, organizationId)) {
      throw new NotFoundException(`지그를 찾을 수 없습니다 (${dto.jigCode}/${dto.jigLotNo}).`);
    }
    const binds: OracleRow = {
      jigCode: dto.jigCode, jigLotNo: dto.jigLotNo, organizationId, userId,
    };
    const sets = this.editableSets(dto, binds);

    await this.dataSource.query(
      `UPDATE IMCN_JIG SET ${sets.join(', ')}
        WHERE JIG_CODE = :jigCode AND JIG_LOT_NO = :jigLotNo AND ORGANIZATION_ID = :organizationId`,
      namedBinds(binds),
    );
    return { jigCode: dto.jigCode, jigLotNo: dto.jigLotNo };
  }

  /**
   * 지그코드·지그LOT 변경 — 한 트랜잭션에서 IMCN_JIG 와 IMCN_JIG_APPLY_MODEL 의 키만 바꾼다.
   * 투입이력·점검·수리·제품추적 등 이력 테이블은 옛 키로 남긴다(업무 결정).
   * 막는 경우: 새 LOT 이 적용모델 칸 길이 초과 / 새 키 중복 / 새 LOT 을 다른 지그코드가 사용 /
   * 새 키로 남아 있는 적용모델 행 / 라인에 장착된 지그.
   */
  private async changeKey(
    dto: JigMasterUpsertDto,
    from: { jigCode: string; jigLotNo: string },
    organizationId: number,
    userId: string,
  ) {
    const to = { jigCode: dto.jigCode, jigLotNo: dto.jigLotNo };
    if (to.jigLotNo.length > APPLY_MODEL_LOT_MAX) {
      throw new BadRequestException(
        `지그LOT 은 ${APPLY_MODEL_LOT_MAX}자까지 입력할 수 있습니다 (적용모델 LOT 칸 길이).`,
      );
    }

    return this.tx.run(async (qr) => {
      const keyBinds = { fromCode: from.jigCode, fromLot: from.jigLotNo, organizationId };
      // 원래 행을 잠가 동시에 같은 지그를 고치는 것을 막는다
      const original = await qr.query(
        `SELECT JIG_CODE FROM IMCN_JIG
          WHERE JIG_CODE = :fromCode AND JIG_LOT_NO = :fromLot AND ORGANIZATION_ID = :organizationId
          FOR UPDATE`,
        namedBinds(keyBinds),
      ) as OracleRow[];
      if (original.length === 0) {
        throw new NotFoundException(`지그를 찾을 수 없습니다 (${from.jigCode}/${from.jigLotNo}).`);
      }

      const duplicate = await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IMCN_JIG
          WHERE JIG_CODE = :toCode AND JIG_LOT_NO = :toLot AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ toCode: to.jigCode, toLot: to.jigLotNo, organizationId }),
      ) as OracleRow[];
      if (Number(duplicate[0]?.cnt ?? 0) > 0) {
        throw new ConflictException(`이미 등록된 지그입니다 (${to.jigCode}/${to.jigLotNo}).`);
      }

      const sameLot = await qr.query(
        `SELECT JIG_CODE AS "jigCode" FROM IMCN_JIG
          WHERE JIG_LOT_NO = :toLot AND ORGANIZATION_ID = :organizationId
            AND JIG_CODE <> :toCode
            AND NOT (JIG_CODE = :fromCode AND JIG_LOT_NO = :fromLot)`,
        namedBinds({ ...keyBinds, toCode: to.jigCode, toLot: to.jigLotNo }),
      ) as OracleRow[];
      if (sameLot.length > 0) {
        const codes = sameLot.map((row) => String(row.jigCode)).join(', ');
        throw new ConflictException(
          `지그LOT ${to.jigLotNo} 을 다른 지그코드(${codes})가 사용하고 있습니다.`,
        );
      }

      const leftover = await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IMCN_JIG_APPLY_MODEL
          WHERE JIG_CODE = :toCode AND JIG_LOT_NO = :toLot AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ toCode: to.jigCode, toLot: to.jigLotNo, organizationId }),
      ) as OracleRow[];
      const leftoverCount = Number(leftover[0]?.cnt ?? 0);
      if (leftoverCount > 0) {
        throw new ConflictException(
          `새 지그코드·지그LOT(${to.jigCode}/${to.jigLotNo})으로 남아 있는 적용모델 ${leftoverCount}건이 있습니다. 먼저 정리하세요.`,
        );
      }

      const mounted = await qr.query(
        MOUNT_COLUMNS.map(([column]) => `
          SELECT LINE_CODE AS "lineCode", '${column}' AS "columnName" FROM IP_PRODUCT_LINE
           WHERE ${column} = :fromLot AND ORGANIZATION_ID = :organizationId`).join(' UNION ALL '),
        namedBinds({ fromLot: from.jigLotNo, organizationId }),
      ) as OracleRow[];
      if (mounted.length > 0) {
        const where = mounted.map((row) => {
          const label = MOUNT_COLUMNS.find(([column]) => column === row.columnName)?.[1] ?? row.columnName;
          return `라인 ${String(row.lineCode)} ${String(label)}`;
        }).join(', ');
        throw new ConflictException(
          `라인에 장착된 지그라 지그코드·지그LOT 을 바꿀 수 없습니다 (${where}). 라인에서 내린 뒤 바꾸세요.`,
        );
      }

      const binds: OracleRow = { ...keyBinds, toCode: to.jigCode, toLot: to.jigLotNo, userId };
      const sets = this.editableSets(dto, binds);
      await qr.query(
        `UPDATE IMCN_JIG SET JIG_CODE = :toCode, JIG_LOT_NO = :toLot, ${sets.join(', ')}
          WHERE JIG_CODE = :fromCode AND JIG_LOT_NO = :fromLot AND ORGANIZATION_ID = :organizationId`,
        namedBinds(binds),
      );
      await qr.query(
        `UPDATE IMCN_JIG_APPLY_MODEL
            SET JIG_CODE = :toCode, JIG_LOT_NO = :toLot,
                LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE JIG_CODE = :fromCode AND JIG_LOT_NO = :fromLot AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ ...keyBinds, toCode: to.jigCode, toLot: to.jigLotNo, userId }),
      );
      return to;
    });
  }

  /**
   * 적용모델 복사 — PB cb_9 → PKG_MES_MAC.SP_COPY_APPLY_MODEL 전환.
   * 입력 검증(빈 값·동일 지그)은 PB 가 메시지박스로 막던 것이라 여기서 400 으로 돌려준다.
   */
  async copyApplyModels(dto: JigApplyModelCopyDto, organizationId: number) {
    const from = dto.fromJigLotNo.trim();
    const to = dto.toJigLotNo.trim();
    if (!from) throw new BadRequestException('복사 원본 지그를 입력하세요.');
    if (!to) throw new BadRequestException('복사 대상 지그를 선택하세요.');
    if (from === to) throw new BadRequestException('원본 지그와 대상 지그가 같습니다.');

    return this.tx.run(async (qr) => {
      try {
        await qr.query(
          `DECLARE
             v_result NUMBER;
           BEGIN
             PKG_MES_MAC.SP_COPY_APPLY_MODEL(:jigType, :fromJigLot, :toJigLot, v_result);
             IF v_result < 0 THEN
               RAISE_APPLICATION_ERROR(-20002, 'APPLY_MODEL_COPY_FAILED:' || v_result);
             END IF;
           END;`,
          namedBinds({ jigType: dto.jigType, fromJigLot: from, toJigLot: to }),
        );
      } catch (error: unknown) {
        const message = error instanceof Error ? error.message : String(error);
        const matched = /APPLY_MODEL_COPY_FAILED:(-?\d+)/.exec(message);
        if (!matched) throw error;
        throw new BadRequestException(
          matched[1] === '-2'
            ? '원본 지그와 대상 지그가 같습니다.'
            : `복사할 원본 지그가 없습니다 (${from}).`,
        );
      }
      const copied = await this.findApplyModels(
        { jigCode: to, jigLotNo: to }, organizationId,
      );
      return { copied: copied.length };
    });
  }
}
