/**
 * @file src/modules/smt/smt-bom-replace.service.ts
 * @description SMT BOM 대체관리 — PB w_smt_bom_replace_master 이식
 *
 * 초보자 가이드:
 * 1. **대체 BOM 은 "이 자리에 원래 품목 대신 이것도 쓸 수 있다"는 표다.**
 *    계획배포 때 REPLACE_YN='Y' 행으로 IB_PRODUCT_PLANDATA 에 같이 펼쳐진다.
 *    그래서 여기 남은 옛 모델명은 다음 배포에 섞여 들어간다 —
 *    모델명 변경은 PKG_MES_SMT.SP_SMT_BOM_MODEL_RENAME 이 이 테이블까지 함께 바꾼다.
 * 2. **키가 여섯 컬럼이다.** PARENT + CHILD + REPLACE + LINE_CODE + LOCATION_CODE + ORG.
 *    수정 화면에서 여섯 개를 모두 잠근다. 하나라도 열어두면 UPDATE 의 WHERE 가
 *    다른 행을 가리키고, 화면에는 "찾을 수 없습니다" 만 나온다.
 * 3. **적용기간은 DATESET ~ DATEEND 이고 둘 다 NOT NULL 이다.** PB 의 수정용 뷰는
 *    오늘이 그 사이에 드는 행만 보여준다 (effectiveOnly='Y').
 * 4. 원 품목과 대체 품목은 ID_ITEM 을 좌측 외부조인해 이름을 붙인다.
 *    조인을 내부조인으로 바꾸면 품목마스터에 없는 코드가 목록에서 사라진다.
 */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  SmtBomReplaceKeyDto,
  SmtBomReplaceQueryDto,
  SmtBomReplaceUpsertDto,
} from './smt-bom-replace.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

const EDITABLE: Array<[column: string, field: keyof SmtBomReplaceUpsertDto]> = [
  ['ITEM_UNIT_QTY', 'itemUnitQty'],
  ['SORT_SEQUENCE', 'sortSequence'],
  ['WORKSTAGE_CODE', 'workstageCode'],
  ['ITEM_TYPE', 'itemType'],
  ['LINE_TYPE', 'lineType'],
  ['MACHINE', 'machine'],
  ['MODEL_NAME', 'modelName'],
  ['TABLE_ID', 'tableId'],
  ['PCB_ITEM', 'pcbItem'],
  ['REVISION', 'revision'],
  ['FEEDER_SHAFT', 'feederShaft'],
  ['SMT_MODEL_NAME', 'smtModelName'],
  ['COMMENTS', 'comments'],
  ['BOM_LEVEL', 'bomLevel'],
];

@Injectable()
export class SmtBomReplaceService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_des_bom_smt_replace_lst / _4_modify_lst (두 DW 가 조건만 다르다). */
  async find(query: SmtBomReplaceQueryDto, organizationId: number) {
    const effectiveOnly = query.effectiveOnly === 'Y';
    const rows = (await this.dataSource.query(
      `SELECT r.PARENT_ITEM_CODE AS "parentItemCode",
              r.CHILD_ITEM_CODE AS "childItemCode",
              r.REPLACE_ITEM_CODE AS "replaceItemCode",
              r.LINE_CODE AS "lineCode", r.LOCATION_CODE AS "locationCode",
              r.MACHINE AS "machine", r.MODEL_NAME AS "modelName",
              r.TABLE_ID AS "tableId", r.PCB_ITEM AS "pcbItem",
              pcb.CODE_MEAN_KOR AS "pcbItemName",
              r.DATESET AS "dateSet", r.DATEEND AS "dateEnd",
              r.SORT_SEQUENCE AS "sortSequence", r.ITEM_UNIT_QTY AS "itemUnitQty",
              r.WORKSTAGE_CODE AS "workstageCode", r.BOM_LEVEL AS "bomLevel",
              r.ITEM_TYPE AS "itemType", it.CODE_MEAN_KOR AS "itemTypeName",
              r.LINE_TYPE AS "lineType", lt.CODE_MEAN_KOR AS "lineTypeName",
              r.REVISION AS "revision", r.FEEDER_SHAFT AS "feederShaft",
              r.SMT_MODEL_NAME AS "smtModelName", r.COMMENTS AS "comments",
              c.ITEM_NAME AS "childItemName", c.ITEM_SPEC AS "childItemSpec",
              c.ITEM_UOM AS "childItemUom",
              p.ITEM_NAME AS "parentItemName", p.ITEM_SPEC AS "parentItemSpec",
              rep.ITEM_NAME AS "replaceItemName", rep.ITEM_SPEC AS "replaceItemSpec",
              r.ENTER_BY AS "enterBy", r.ENTER_DATE AS "enterDate",
              r.LAST_MODIFY_BY AS "lastModifyBy", r.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM ID_ENG_BOM_SMT_REPLACE r
         LEFT JOIN ID_ITEM c
                ON c.ITEM_CODE = r.CHILD_ITEM_CODE
               AND c.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN ID_ITEM p
                ON p.ITEM_CODE = r.PARENT_ITEM_CODE
               AND p.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN ID_ITEM rep
                ON rep.ITEM_CODE = r.REPLACE_ITEM_CODE
               AND rep.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE it
                ON it.CODE_TYPE = 'ITEM TYPE' AND it.CODE_NAME = r.ITEM_TYPE
         LEFT JOIN ISYS_BASECODE lt
                ON lt.CODE_TYPE = 'LINE TYPE' AND lt.CODE_NAME = r.LINE_TYPE
         LEFT JOIN ISYS_BASECODE pcb
                ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = r.PCB_ITEM
        WHERE r.ORGANIZATION_ID = :organizationId
          AND NVL(r.MODEL_NAME, '*') LIKE :modelName
          AND NVL(r.CHILD_ITEM_CODE, '*') LIKE :childItemCode
          AND NVL(r.REPLACE_ITEM_CODE, '*') LIKE :replaceItemCode
          AND NVL(r.LINE_CODE, '*') LIKE :lineCode
          AND NVL(r.MACHINE, '*') LIKE :machine
          ${effectiveOnly ? 'AND r.DATESET <= TRUNC(SYSDATE) AND r.DATEEND >= TRUNC(SYSDATE)' : ''}
        ORDER BY r.MODEL_NAME, r.LINE_CODE, r.LOCATION_CODE, r.SORT_SEQUENCE`,
      namedBinds({
          organizationId,
          modelName: this.like(query.modelName),
          childItemCode: this.like(query.childItemCode),
          replaceItemCode: this.like(query.replaceItemCode),
          lineCode: this.like(query.lineCode),
          machine: this.like(query.machine),
        }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  private keyBinds(key: SmtBomReplaceKeyDto, organizationId: number) {
    return {
      parentItemCode: key.parentItemCode,
      childItemCode: key.childItemCode,
      replaceItemCode: key.replaceItemCode,
      lineCode: key.lineCode,
      locationCode: key.locationCode,
      organizationId,
    };
  }

  private readonly KEY_WHERE = `
    PARENT_ITEM_CODE = :parentItemCode
    AND CHILD_ITEM_CODE = :childItemCode
    AND REPLACE_ITEM_CODE = :replaceItemCode
    AND LINE_CODE = :lineCode
    AND LOCATION_CODE = :locationCode
    AND ORGANIZATION_ID = :organizationId`;

  async create(dto: SmtBomReplaceUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const [dup] = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM ID_ENG_BOM_SMT_REPLACE WHERE ${this.KEY_WHERE}`,
        namedBinds([this.keyBinds(dto, organizationId)]),
      )) as { CNT: number }[];
      if (Number(dup?.CNT ?? 0) > 0) {
        throw new ConflictException('이미 있는 대체 BOM 입니다.');
      }

      const columns = [
        'PARENT_ITEM_CODE', 'CHILD_ITEM_CODE', 'REPLACE_ITEM_CODE',
        'LINE_CODE', 'LOCATION_CODE', 'ORGANIZATION_ID',
      ];
      const values = [
        ':parentItemCode', ':childItemCode', ':replaceItemCode',
        ':lineCode', ':locationCode', ':organizationId',
      ];
      const binds: Record<string, unknown> = {
        ...this.keyBinds(dto, organizationId),
        dateSet: dto.dateSet,
        dateEnd: dto.dateEnd,
        userId,
      };
      columns.push('DATESET', 'DATEEND');
      values.push(`TO_DATE(:dateSet, 'YYYY-MM-DD')`, `TO_DATE(:dateEnd, 'YYYY-MM-DD')`);
      for (const [column, field] of EDITABLE) {
        columns.push(column);
        values.push(`:${field}`);
        // WORKSTAGE_CODE 는 NOT NULL 이고 이 DB 는 전부 '*' 다 (DTO 주석 참고)
        binds[field] = dto[field] ?? (field === 'workstageCode' ? '*' : null);
      }
      columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
      values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

      await qr.query(
        `INSERT INTO ID_ENG_BOM_SMT_REPLACE (${columns.join(', ')})
         VALUES (${values.join(', ')})`,
        namedBinds(binds),
      );
      return { created: 1 };
    });
  }

  async update(dto: SmtBomReplaceUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const binds: Record<string, unknown> = {
        ...this.keyBinds(dto, organizationId),
        dateSet: dto.dateSet,
        dateEnd: dto.dateEnd,
        userId,
      };
      const sets = [
        `DATESET = TO_DATE(:dateSet, 'YYYY-MM-DD')`,
        `DATEEND = TO_DATE(:dateEnd, 'YYYY-MM-DD')`,
      ];
      for (const [column, field] of EDITABLE) {
        sets.push(`${column} = :${field}`);
        // WORKSTAGE_CODE 는 NOT NULL 이고 이 DB 는 전부 '*' 다 (DTO 주석 참고)
        binds[field] = dto[field] ?? (field === 'workstageCode' ? '*' : null);
      }
      sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

      const result = await qr.query(
        `UPDATE ID_ENG_BOM_SMT_REPLACE SET ${sets.join(', ')} WHERE ${this.KEY_WHERE}`,
        namedBinds(binds),
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) throw new NotFoundException('대체 BOM 을 찾을 수 없습니다.');
      return { changed: affected };
    });
  }

  async remove(key: SmtBomReplaceKeyDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DELETE FROM ID_ENG_BOM_SMT_REPLACE WHERE ${this.KEY_WHERE}`,
        namedBinds([this.keyBinds(key, organizationId)]),
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) throw new NotFoundException('대체 BOM 을 찾을 수 없습니다.');
      return { deleted: affected };
    });
  }
}
