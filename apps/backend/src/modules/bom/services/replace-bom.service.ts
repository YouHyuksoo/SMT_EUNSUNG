/**
 * @file src/modules/bom/services/replace-bom.service.ts
 * @description 대체BOM관리 — PB w_des_replace_bom_master ("ENG BOM Replace Master") 이식
 *
 * 두 모드:
 * 1. 관리(BOM 전개): PKG_DESIGN.BOM_QUERY 로 SET 품목의 BOM 을 ID_ENG_BOM_TEMP 에 전개하고,
 *    각 구성품에 대체품(ID_ITEM_REPLACE)을 등록/수정/삭제한다.
 * 2. 목록: 등록된 대체품(ID_ITEM_REPLACE)을 조회한다.
 *
 * ID_ENG_BOM_TEMP 는 GTT 가 아니라 일반 테이블이다. BOM_QUERY 가 여기에 행을 INSERT 하므로,
 * 전개 결과를 읽은 뒤 같은 SESSION_ID 행을 DELETE 하고 커밋한다(누수 방지, PB 의 ROLLBACK 대응).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { OracleService } from '../../../common/services/oracle.service';
import { parseDateEnd, parseDateStart } from '../../../shared/date.util';
import { TransactionService } from '../../../shared/transaction.service';
import {
  BomExpandQueryDto,
  ReplaceDeleteDto,
  ReplaceListQueryDto,
  ReplaceUpsertDto,
} from '../dto/replace-bom.dto';

type OracleRow = Record<string, unknown>;
const FAR_FUTURE = new Date(9999, 11, 31);

/** BOM 전개 결과 SELECT — 세션ID(:sid)로 ID_ENG_BOM_TEMP 조회 */
const BOM_EXPAND_SQL = `
  SELECT LPAD(t.BOM_LEVEL, t.BOM_LEVEL, '.') AS "bomLevel",
         t.BOM_LEVEL AS "bomLevelNo",
         t.SORT_ORDER AS "sortOrder",
         t.PARENT_ITEM_CODE AS "parentItemCode",
         a.ITEM_NAME AS "parentItemName",
         t.CHILD_ITEM_CODE AS "childItemCode",
         b.ITEM_NAME AS "childItemName",
         b.ITEM_SPEC AS "childItemSpec",
         b.ITEM_UOM AS "childItemUom",
         b.ITEM_TYPE AS "childItemType",
         t.ITEM_UNIT_QTY AS "itemUnitQty",
         t.ITEM_UNIT_QTY_EXT AS "itemUnitQtyExt",
         t.MODEL_UNIT_QTY AS "modelUnitQty",
         t.WORKSTAGE_CODE AS "workstageCode",
         ws.WORKSTAGE_NAME AS "workstageName",
         t.LOCATION_INFO AS "locationInfo",
         t.ASSY_EXPLOSION_YN AS "assyExplosionYn",
         t.LOSS_RATE AS "lossRate",
         t.SCRAP_RATE AS "scrapRate",
         t.DATESET AS "dateset",
         t.DATEEND AS "dateend"
    FROM ID_ENG_BOM_TEMP t
    -- PB DDDW(vd_workstage_code) 대응. 코드+조직이 유일해 행이 늘지 않는다.
    LEFT JOIN IP_PRODUCT_WORKSTAGE ws ON ws.WORKSTAGE_CODE = t.WORKSTAGE_CODE AND ws.ORGANIZATION_ID = t.ORGANIZATION_ID
    LEFT JOIN ID_ITEM a ON a.ITEM_CODE = t.PARENT_ITEM_CODE AND a.ORGANIZATION_ID = t.ORGANIZATION_ID
    LEFT JOIN ID_ITEM b ON b.ITEM_CODE = t.CHILD_ITEM_CODE AND b.ORGANIZATION_ID = t.ORGANIZATION_ID
   WHERE t.SESSION_ID = :sid AND t.ORGANIZATION_ID = :org
   ORDER BY t.SORT_ORDER`;

@Injectable()
export class ReplaceBomService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
    private readonly oracle: OracleService,
  ) {}

  /**
   * 관리 모드 — SET 품목 BOM 전개.
   * PKG_DESIGN.BOM_QUERY 가 ID_ENG_BOM_TEMP 에 전개(INSERT)하고 세션ID를 반환하면,
   * 그 세션ID로 조회한다. autoCommit=false 라 커넥션 반납 시 temp INSERT 는 롤백된다(누수 없음).
   */
  async expandBom(query: BomExpandQueryDto, organizationId: number) {
    const setItemCode = query.setItemCode.trim();
    if (!setItemCode || setItemCode === '%') {
      throw new BadRequestException('SET 품목코드를 입력하세요.');
    }
    const dateset = parseDateStart(query.dateset) ?? new Date();

    const { rows, sessionId } = await this.oracle.callFunctionReturningCursor<OracleRow>(
      'PKG_DESIGN.BOM_QUERY(:parent, :dateset, :org)',
      BOM_EXPAND_SQL,
      { parent: setItemCode, dateset, org: organizationId },
    );
    if (!sessionId || sessionId <= 0) {
      throw new BadRequestException(`BOM 전개에 실패했습니다: ${setItemCode}`);
    }
    return { data: rows, sessionId, total: rows.length };
  }

  /** 목록 모드 — PB d_des_item_replace_lst */
  async findReplaceList(query: ReplaceListQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = {
      organizationId,
      setItemCode: this.like(query.setItemCode),
      childItemCode: this.like(query.childItemCode),
      replaceItemCode: this.like(query.replaceItemCode),
    };
    const from = `
      FROM ID_ITEM_REPLACE r
      LEFT JOIN IP_PRODUCT_WORKSTAGE ws ON ws.WORKSTAGE_CODE = r.WORKSTAGE_CODE AND ws.ORGANIZATION_ID = r.ORGANIZATION_ID
      LEFT JOIN ID_ITEM i ON i.ITEM_CODE = r.REPLACE_ITEM_CODE AND i.ORGANIZATION_ID = r.ORGANIZATION_ID
      WHERE r.ORGANIZATION_ID = :organizationId
        AND r.PARENT_ITEM_CODE LIKE :setItemCode
        AND r.CHILD_ITEM_CODE LIKE :childItemCode
        AND r.REPLACE_ITEM_CODE LIKE :replaceItemCode`;
    const select = `
      SELECT r.PARENT_ITEM_CODE AS "parentItemCode",
             r.CHILD_ITEM_CODE AS "childItemCode",
             r.REPLACE_ITEM_CODE AS "replaceItemCode",
             i.ITEM_NAME AS "replaceItemName",
             i.ITEM_SPEC AS "replaceItemSpec",
             i.ITEM_UOM AS "replaceItemUom",
             r.REPLACE_SEQUENCE AS "replaceSequence",
             r.ITEM_UNIT_QTY AS "itemUnitQty",
             r.ITEM_UNIT_QTY_EXT AS "itemUnitQtyExt",
             r.WORKSTAGE_CODE AS "workstageCode",
             ws.WORKSTAGE_NAME AS "workstageName",
             r.BOM_LOCATION_CODE AS "bomLocationCode",
             r.DATESET AS "dateset",
             r.DATEEND AS "dateend",
             r.ENTER_BY AS "enterBy",
             r.ENTER_DATE AS "enterDate",
             r.LAST_MODIFY_BY AS "lastModifyBy",
             r.LAST_MODIFY_DATE AS "lastModifyDate",
             r.ORGANIZATION_ID AS "organizationId"
      ${from}
      ORDER BY r.PARENT_ITEM_CODE, r.CHILD_ITEM_CODE, r.REPLACE_SEQUENCE
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`;
    const offset = (query.page - 1) * query.limit;
    const rows = await this.dataSource.query(
      select, { ...binds, offset, limit: query.limit } as unknown as unknown[],
    ) as OracleRow[];
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" ${from}`, binds as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page: query.page, limit: query.limit };
  }

  /** 대체품 등록/수정 — PK 존재하면 UPDATE, 없으면 INSERT */
  async upsertReplace(dto: ReplaceUpsertDto, organizationId: number, userId: string) {
    const key = {
      parentItemCode: dto.parentItemCode, childItemCode: dto.childItemCode,
      replaceItemCode: dto.replaceItemCode, organizationId,
    };
    const dateset = parseDateStart(dto.dateset) ?? new Date();
    const dateend = parseDateEnd(dto.dateend) ?? FAR_FUTURE;

    return this.tx.run(async (qr) => {
      const existing = await qr.query(
        `SELECT REPLACE_SEQUENCE AS "seq" FROM ID_ITEM_REPLACE
          WHERE PARENT_ITEM_CODE = :parentItemCode AND CHILD_ITEM_CODE = :childItemCode
            AND REPLACE_ITEM_CODE = :replaceItemCode AND ORGANIZATION_ID = :organizationId`,
        key as unknown as unknown[],
      ) as OracleRow[];

      if (existing.length > 0) {
        await qr.query(
          `UPDATE ID_ITEM_REPLACE
              SET ITEM_UNIT_QTY = :itemUnitQty, ITEM_UNIT_QTY_EXT = :itemUnitQtyExt,
                  WORKSTAGE_CODE = :workstageCode, BOM_LOCATION_CODE = :bomLocationCode,
                  DATESET = :dateset, DATEEND = :dateend,
                  LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
            WHERE PARENT_ITEM_CODE = :parentItemCode AND CHILD_ITEM_CODE = :childItemCode
              AND REPLACE_ITEM_CODE = :replaceItemCode AND ORGANIZATION_ID = :organizationId`,
          {
            ...key, itemUnitQty: dto.itemUnitQty, itemUnitQtyExt: dto.itemUnitQtyExt ?? null,
            workstageCode: dto.workstageCode, bomLocationCode: dto.bomLocationCode ?? null,
            dateset, dateend, userId,
          } as unknown as unknown[],
        );
        return { mode: 'update' as const, ...key };
      }

      // REPLACE_SEQUENCE: 같은 (부모, 자식) 안에서 MAX+1 (동시성 대비 트랜잭션 내 산출)
      const seqRow = await qr.query(
        `SELECT NVL(MAX(REPLACE_SEQUENCE), 0) + 1 AS "seq" FROM ID_ITEM_REPLACE
          WHERE PARENT_ITEM_CODE = :parentItemCode AND CHILD_ITEM_CODE = :childItemCode
            AND ORGANIZATION_ID = :organizationId`,
        { parentItemCode: dto.parentItemCode, childItemCode: dto.childItemCode, organizationId } as unknown as unknown[],
      ) as OracleRow[];
      const replaceSequence = Number(seqRow[0]?.seq ?? 1);

      await qr.query(
        `INSERT INTO ID_ITEM_REPLACE (
           PARENT_ITEM_CODE, CHILD_ITEM_CODE, REPLACE_ITEM_CODE, ORGANIZATION_ID,
           REPLACE_SEQUENCE, ITEM_UNIT_QTY, ITEM_UNIT_QTY_EXT, WORKSTAGE_CODE, BOM_LOCATION_CODE,
           DATESET, DATEEND, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
         ) VALUES (
           :parentItemCode, :childItemCode, :replaceItemCode, :organizationId,
           :replaceSequence, :itemUnitQty, :itemUnitQtyExt, :workstageCode, :bomLocationCode,
           :dateset, :dateend, :userId, SYSDATE, :userId, SYSDATE
         )`,
        {
          ...key, replaceSequence, itemUnitQty: dto.itemUnitQty,
          itemUnitQtyExt: dto.itemUnitQtyExt ?? null, workstageCode: dto.workstageCode,
          bomLocationCode: dto.bomLocationCode ?? null, dateset, dateend, userId,
        } as unknown as unknown[],
      );
      return { mode: 'insert' as const, replaceSequence, ...key };
    });
  }

  /** 대체품 삭제 */
  async deleteReplace(dto: ReplaceDeleteDto, organizationId: number) {
    const result = await this.dataSource.query(
      `DELETE FROM ID_ITEM_REPLACE
        WHERE PARENT_ITEM_CODE = :parentItemCode AND CHILD_ITEM_CODE = :childItemCode
          AND REPLACE_ITEM_CODE = :replaceItemCode AND ORGANIZATION_ID = :organizationId`,
      {
        parentItemCode: dto.parentItemCode, childItemCode: dto.childItemCode,
        replaceItemCode: dto.replaceItemCode, organizationId,
      } as unknown as unknown[],
    ) as unknown;
    void result;
    return { deleted: true, ...dto };
  }


  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }
}
