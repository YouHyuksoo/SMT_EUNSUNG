/**
 * @file src/modules/price-confirm/bom-confirm.service.ts
 * @description 설계BOM승인 — PB w_des_bom_confirm_master 이식
 *
 * 초보자 가이드:
 * 1. **작업공간(ID_ENG_BOM_WORKSPACE)은 확정 전 BOM 이다.** 작업번호로 묶여 있고,
 *    승인하면 실제 BOM(ID_ENG_BOM)으로 옮겨진다. 옮기는 일은
 *    PKG_DESIGN.BOM_TRANSLATION 이 한다 — PB 도 그 함수를 불렀다.
 *    TypeScript 로 다시 구현하지 않는다. BOM 전개·레벨 계산 규칙이 갈리면
 *    설계와 생산이 다른 BOM 을 본다.
 * 2. **PB 의 가드를 유지한다** — NEW_BOM_YN='Y' 행이 하나도 없으면 승인하지 않는다.
 *    새로 넣을 것이 없는데 옮기면 기존 BOM 만 흔든다.
 * 3. **SET 품목코드는 작업번호로 정해진다.** PB 는 작업번호를 고르면
 *    `SELECT DISTINCT ITEM_CODE` 로 자동 채웠다. 같은 규칙을 조회 API 로 낸다.
 * 4. **이 표는 이 DB 에서 0행이다** — 은성이 아직 이 절차를 쓰지 않는다.
 *    화면은 동작하지만 승인할 대상이 없다.
 * 5. **'작업공간 비우기' 는 작업번호 단위 전체 삭제다.** PB 와 같고, 되돌릴 수 없다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  BomConfirmApplyDto,
  BomConfirmClearDto,
  BomConfirmQueryDto,
} from './bom-confirm.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class BomConfirmService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 작업번호 목록 — PB ddlb_work_no 가 채우던 것. SET 품목도 함께 낸다. */
  async findWorkNumbers(organizationId: number) {
    return (await this.dataSource.query(
      `SELECT w.BOM_WORK_NO AS "bomWorkNo",
              MAX(w.ITEM_CODE) AS "itemCode",
              MAX(i.ITEM_NAME) AS "itemName",
              COUNT(*) AS "rowCount",
              SUM(CASE WHEN NVL(w.NEW_BOM_YN, 'N') = 'Y' THEN 1 ELSE 0 END) AS "newRowCount",
              MIN(w.ENTER_DATE) AS "enterDate",
              MAX(w.ENTER_BY) AS "enterBy"
         FROM ID_ENG_BOM_WORKSPACE w
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = w.ITEM_CODE
               AND i.ORGANIZATION_ID = w.ORGANIZATION_ID
        WHERE w.ORGANIZATION_ID = :organizationId
        GROUP BY w.BOM_WORK_NO
        ORDER BY w.BOM_WORK_NO DESC`,
      namedBinds({ organizationId }),
    )) as Row[];
  }

  /** 작업공간 BOM 목록 — PB d_des_bom_workspace_query. */
  async find(query: BomConfirmQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT w.BOM_WORK_NO AS "bomWorkNo",
              w.ITEM_CODE AS "itemCode",
              w.PARENT_ITEM_CODE AS "parentItemCode",
              p.ITEM_NAME AS "parentItemName",
              w.CHILD_ITEM_CODE AS "childItemCode",
              c.ITEM_NAME AS "childItemName", c.ITEM_SPEC AS "childItemSpec",
              c.ITEM_UOM AS "childItemUom",
              w.REPLACE_ITEM_CODE AS "replaceItemCode",
              TO_CHAR(w.DATESET, 'YYYY-MM-DD') AS "dateSet",
              TO_CHAR(w.DATEEND, 'YYYY-MM-DD') AS "dateEnd",
              w.SORT_SEQUENCE AS "sortSequence",
              w.ITEM_UNIT_QTY AS "itemUnitQty",
              w.ITEM_UNIT_QTY_EXT AS "itemUnitQtyExt",
              w.WORKSTAGE_CODE AS "workstageCode",
              w.ITEM_TYPE AS "itemType", it.CODE_MEAN_KOR AS "itemTypeName",
              w.LINE_TYPE AS "lineType", lt.CODE_MEAN_KOR AS "lineTypeName",
              w.SCRAP_RATE AS "scrapRate", w.LOSS_RATE AS "lossRate",
              w.ASSY_EXPLOSION_YN AS "assyExplosionYn",
              -- NEW BOM YN 코드표는 이 DB 에 없다. Y/N 원시값을 그대로 낸다.
              NVL(w.NEW_BOM_YN, 'N') AS "newBomYn",
              w.REQUEST_YN AS "requestYn",
              w.PCB_ITEM AS "pcbItem", w.REVISION AS "revision",
              w.LOCATION_INFO AS "locationInfo",
              w.CONFIRM_COMMENT AS "confirmComment",
              w.ENTER_BY AS "enterBy", w.ENTER_DATE AS "enterDate",
              w.LAST_MODIFY_BY AS "lastModifyBy", w.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM ID_ENG_BOM_WORKSPACE w
         LEFT JOIN ID_ITEM p
                ON p.ITEM_CODE = w.PARENT_ITEM_CODE
               AND p.ORGANIZATION_ID = w.ORGANIZATION_ID
         LEFT JOIN ID_ITEM c
                ON c.ITEM_CODE = w.CHILD_ITEM_CODE
               AND c.ORGANIZATION_ID = w.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE it
                ON it.CODE_TYPE = 'ITEM TYPE' AND it.CODE_NAME = w.ITEM_TYPE
         LEFT JOIN ISYS_BASECODE lt
                ON lt.CODE_TYPE = 'LINE TYPE' AND lt.CODE_NAME = w.LINE_TYPE
        WHERE w.ORGANIZATION_ID = :organizationId
          AND (:bomWorkNo IS NULL OR w.BOM_WORK_NO = :bomWorkNo)
          AND NVL(w.ITEM_CODE, '*') LIKE :itemCode
          AND NVL(w.PARENT_ITEM_CODE, '*') LIKE :parentItemCode
        ORDER BY w.BOM_WORK_NO DESC, w.PARENT_ITEM_CODE, w.SORT_SEQUENCE`,
      namedBinds({
        organizationId,
        bomWorkNo: query.bomWorkNo ?? null,
        itemCode: this.like(query.itemCode),
        parentItemCode: this.like(query.parentItemCode),
      }),
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 승인(반영) — PKG_DESIGN.BOM_TRANSLATION.
   *
   * PB 가드를 먼저 확인하고, 반영 뒤 실제 BOM 의 건수를 세어 돌려준다.
   * 함수가 무엇을 얼마나 옮겼는지 직접 알려주지 않으므로 전후를 센다.
   */
  async apply(dto: BomConfirmApplyDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const newRows = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM ID_ENG_BOM_WORKSPACE
          WHERE BOM_WORK_NO = :bomWorkNo
            AND ITEM_CODE = :itemCode
            AND ORGANIZATION_ID = :organizationId
            AND NVL(NEW_BOM_YN, 'N') = 'Y'`,
        namedBinds({
          bomWorkNo: dto.bomWorkNo,
          itemCode: dto.itemCode,
          organizationId,
        }),
      )) as Array<{ CNT: number }>;
      // PB 가드: 새로 넣을 행이 없으면 반영하지 않는다
      if (Number(newRows?.[0]?.CNT ?? 0) === 0) {
        throw new NotFoundException(
          `작업번호 ${dto.bomWorkNo} / ${dto.itemCode} 에 새 BOM(NEW_BOM_YN='Y') 행이 없습니다.`,
        );
      }

      const before = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM ID_ENG_BOM
          WHERE PARENT_ITEM_CODE = :itemCode AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ itemCode: dto.itemCode, organizationId }),
      )) as Array<{ CNT: number }>;

      const result = (await qr.query(
        `SELECT PKG_DESIGN.BOM_TRANSLATION(:bomWorkNo, :itemCode, :organizationId)
                  AS RESULT
           FROM DUAL`,
        namedBinds({
          bomWorkNo: dto.bomWorkNo,
          itemCode: dto.itemCode,
          organizationId,
        }),
      )) as Array<{ RESULT: number }>;
      const code = Number(result?.[0]?.RESULT ?? -1);
      if (code < 0) {
        throw new ConflictException(
          `BOM 반영에 실패했습니다 (PKG_DESIGN.BOM_TRANSLATION 반환 ${code}).`,
        );
      }

      const after = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM ID_ENG_BOM
          WHERE PARENT_ITEM_CODE = :itemCode AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ itemCode: dto.itemCode, organizationId }),
      )) as Array<{ CNT: number }>;

      return {
        bomWorkNo: dto.bomWorkNo,
        itemCode: dto.itemCode,
        translationResult: code,
        bomRowsBefore: Number(before?.[0]?.CNT ?? 0),
        bomRowsAfter: Number(after?.[0]?.CNT ?? 0),
      };
    });
  }

  /** 작업공간 비우기 — PB cb('Delete All'). 작업번호 단위 전체 삭제. */
  async clear(dto: BomConfirmClearDto, organizationId: number) {
    if (!dto.bomWorkNo) {
      throw new BadRequestException('작업번호를 지정하세요. 전체를 지울 수는 없습니다.');
    }
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DELETE FROM ID_ENG_BOM_WORKSPACE
          WHERE BOM_WORK_NO = :bomWorkNo AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ bomWorkNo: dto.bomWorkNo, organizationId }),
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) {
        throw new NotFoundException(`작업번호 ${dto.bomWorkNo} 에 행이 없습니다.`);
      }
      return { deleted: affected };
    });
  }
}
