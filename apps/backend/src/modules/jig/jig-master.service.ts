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
         AND j.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    // PB 정렬: jig_type A, jig_status D, jig_code A, jig_lot_no A
    const rows = await this.dataSource.query(
      `${body} ORDER BY "jigType", "jigStatus" DESC, "jigCode", "jigLotNo"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 적용모델 목록 — PB d_mcn_jig_apply_model_lst */
  async findApplyModels(query: JigApplyModelQueryDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT JIG_CODE AS "jigCode", JIG_LOT_NO AS "jigLotNo", ITEM_CODE AS "itemCode",
              APPLY_SMT_MODEL_NAME AS "applySmtModelName",
              ENTER_BY AS "enterBy", ENTER_DATE AS "enterDate",
              LAST_MODIFY_BY AS "lastModifyBy", LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IMCN_JIG_APPLY_MODEL
        WHERE JIG_CODE = :jigCode AND JIG_LOT_NO = :jigLotNo
          AND ORGANIZATION_ID = :organizationId
        ORDER BY ITEM_CODE`,
      { jigCode: query.jigCode, jigLotNo: query.jigLotNo, organizationId } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }

  private async exists(jigCode: string, jigLotNo: string, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IMCN_JIG
        WHERE JIG_CODE = :jigCode AND JIG_LOT_NO = :jigLotNo AND ORGANIZATION_ID = :organizationId`,
      { jigCode, jigLotNo, organizationId } as unknown as unknown[],
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
      binds as unknown as unknown[],
    );
    return { jigCode: dto.jigCode, jigLotNo: dto.jigLotNo };
  }

  /** 수정 — PB f_set_security_row('MODIFY') 와 같이 LAST_MODIFY_* 만 갱신한다. */
  async update(dto: JigMasterUpsertDto, organizationId: number, userId: string) {
    if (!await this.exists(dto.jigCode, dto.jigLotNo, organizationId)) {
      throw new NotFoundException(`지그를 찾을 수 없습니다 (${dto.jigCode}/${dto.jigLotNo}).`);
    }
    const sets: string[] = [];
    const binds: OracleRow = {
      jigCode: dto.jigCode, jigLotNo: dto.jigLotNo, organizationId, userId,
    };
    for (const [column, field] of EDITABLE) {
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    for (const [column, field] of DATE_FIELDS) {
      sets.push(`${column} = TO_DATE(:${field}, 'YYYY-MM-DD')`);
      binds[field] = dto[field] ?? null;
    }
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

    await this.dataSource.query(
      `UPDATE IMCN_JIG SET ${sets.join(', ')}
        WHERE JIG_CODE = :jigCode AND JIG_LOT_NO = :jigLotNo AND ORGANIZATION_ID = :organizationId`,
      binds as unknown as unknown[],
    );
    return { jigCode: dto.jigCode, jigLotNo: dto.jigLotNo };
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
          { jigType: dto.jigType, fromJigLot: from, toJigLot: to } as unknown as unknown[],
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
