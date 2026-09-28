/**
 * @file src/modules/product/services/product-pack.service.ts
 * @description 299 제품포장관리(PID) · 311 제품패킹이력 — PB
 *   `w_prd_product_packing_create_master` · `w_prd_product_packing_history` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **완성된 기판(PID)을 박스에 담는 화면이다.** 먼저 박스 바코드를 하나 만들고,
 *    그 박스에 넣을 기판의 PID 를 하나씩 찍는다. 다 담으면 "포장완료"를 누른다.
 * 2. **현장이 매일 쓴다** (실측): `IP_PRODUCT_PACK_MASTER` 593,617건(최근 1년 108,050),
 *    `IP_PRODUCT_PACK_SERIAL` 950만건, 마지막 입력이 오늘이다.
 * 3. **박스 바코드는 DB 가 만든다.** `F_GET_CREATE_CELLBIZ_BARCODE` 를 그대로 부른다.
 *    이 함수 안의 `P_CREATE_CELL_BIZ_BARCODE` 는 **`PRAGMA AUTONOMOUS_TRANSACTION`** 이라
 *    박스 행을 만들고 **즉시 확정한다** — 뒤에서 오류가 나도 되돌지 않는다. PB 도 같다.
 *    빈 박스가 남을 수 있다는 뜻이고, 그래서 목록에서 지울 수 있게 뒀다.
 * 4. **한 PID 는 한 박스에만 들어간다.** 이미 담긴 PID 를 다시 찍으면 거절한다.
 *    담을 때 `IP_PRODUCT_2D_BARCODE.BOX_NO` 에 박스 바코드를 적고, 빼면 NULL 로 되돌린다.
 *    이 두 가지가 어긋나면 제품 추적이 끊긴다 — 그래서 한 트랜잭션에서 같이 움직인다.
 * 5. **라벨 인쇄는 옮기지 않았다.** PB 는 DataWindow 와 BarTender 로 찍는다.
 *    재출력 횟수(`REPRINT`)만 올려 둘 수 있게 남겼다.
 * 6. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 * 7. **목록은 기간을 좁혀 본다.** 이 표들은 기간 컬럼에 인덱스가 없어 한 달을 보면
 *    9,000행에 **8.7초**가 걸린다 (실측). 7일이면 1,583행 **2.4초**다 — 그래서 화면
 *    기본값을 7일로 뒀다. 인덱스 추가는 스키마 변경이라 손대지 않았다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../../shared/row-limit';
import { TransactionService } from '../../../shared/transaction.service';
import {
  PackCompleteDto,
  PackCreateDto,
  PackHistoryQueryDto,
  PackQueryDto,
  PackScanDto,
  PackSerialQueryDto,
} from '../dto/product-pack.dto';

type Row = Record<string, unknown>;

/**
 * PB `ddlb_pack_type` 은 `'C'`(Cell/Biz 박스포장)와 `'M'`(매거진)을 갖지만,
 * 실측은 전 기간 593,618건이 전부 `'C'` 다 — `'M'` 은 0건이라 매거진 포장 화면
 * (`w_prd_product_packing_4_magazine_create_master`)은 옮기지 않았다.
 * 조회 조건으로는 그대로 받는다.
 */

@Injectable()
export class ProductPackService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /** 박스 목록 (PB `d_prd_cell_biz_pack_master`). 분할된 박스는 PB 와 같이 뺀다. */
  async findPacks(query: PackQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.PACK_BARCODE      AS "packBarcode",
              m.PACK_TYPE         AS "packType",
              m.MODEL_NAME        AS "modelName",
              m.MODEL_SUFFIX      AS "modelSuffix",
              m.PART_NO           AS "partNo",
              m.LINE_CODE         AS "lineCode",
              ln.LINE_NAME        AS "lineName",
              m.WORKSTAGE_CODE    AS "workstageCode",
              m.PACKING_PCS_QTY   AS "packingPcsQty",
              m.PACK_QTY          AS "packQty",
              NVL(m.COMPLETE_FLAG, 'N') AS "completeFlag",
              NVL(m.PRINT_FLAG, 'N')    AS "printFlag",
              NVL(m.RECEIPT_FLAG, 'N')  AS "receiptFlag",
              NVL(m.SHIP_FLAG, 'N')     AS "shipFlag",
              NVL(m.REPRINT, 0)   AS "reprint",
              m.RECEIPT_NO        AS "receiptNo",
              m.SHIP_NO           AS "shipNo",
              m.CUSTOMER_CODE     AS "customerCode",
              m.RUN_NO            AS "runNo",
              m.ATTR1             AS "attr1",
              m.ATTR2             AS "attr2",
              m.ATTR3             AS "attr3",
              m.ATTR4             AS "attr4",
              m.ENTER_BY          AS "enterBy",
              TO_CHAR(m.PACK_DATE, 'YYYY-MM-DD')                 AS "packDate",
              TO_CHAR(m.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "receiptDate",
              TO_CHAR(m.SHIP_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "shipDate",
              TO_CHAR(m.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate"
         FROM IP_PRODUCT_PACK_MASTER m
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = m.LINE_CODE
               AND ln.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.PACK_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND m.PACK_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND m.PACK_BARCODE LIKE :packBarcode
          AND m.MODEL_NAME LIKE :modelName
          AND m.PACK_TYPE LIKE :packType
          -- PB 고정조건: 분할된 박스는 목록에 안 나온다.
          AND NVL(m.DIVIDE_FLAG, 'N') = 'N'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.PACK_DATE DESC, m.PACK_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        packBarcode: this.like(query.packBarcode),
        modelName: this.like(query.modelName),
        packType: this.like(query.packType),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 박스 하나에 담긴 PID 목록 (오른쪽 패널). */
  async findSerials(query: PackSerialQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT s.BARCODE            AS "serialNo",
              s.PACK_BARCODE       AS "packBarcode",
              s.MASTER_BARCODE     AS "masterBarcode",
              s.RUN_NO             AS "runNo",
              s.LINE_CODE          AS "lineCode",
              s.WORKSTAGE_CODE     AS "workstageCode",
              s.FINAL_INSPECT_FLAG AS "finalInspectFlag",
              s.BARCODE_QTY        AS "barcodeQty",
              s.ENTER_BY           AS "enterBy",
              TO_CHAR(s.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')          AS "scanDate",
              TO_CHAR(s.FINAL_INSPECT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "finalInspectDate"
         FROM IP_PRODUCT_PACK_SERIAL s
        WHERE s.PACK_BARCODE = :packBarcode
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.SCAN_DATE, s.BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { packBarcode: query.packBarcode, organizationId } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 311 제품패킹이력 — 어느 PID 가 어느 박스에 들어갔는지 되짚는다.
   *
   * 950만 행이라 **PID 나 박스 바코드 중 하나는 반드시 받는다.**
   *
   * **조건을 `(:바인드 IS NULL OR 컬럼 = :바인드)` 로 쓰면 안 된다.** 그렇게 쓰면
   * 옵티마이저가 인덱스를 못 타서 같은 조회가 **8.17초**가 됐다 (실측). 조건을
   * 문장에서 **빼고** 넣는 쪽만 남기면 `PK(BARCODE)` · `IX(PACK_BARCODE)` 를 타
   * **0.48초**다.
   */
  async findPackHistory(query: PackHistoryQueryDto, organizationId: number) {
    const serialNo = (query.serialNo ?? '').trim();
    const packBarcode = (query.packBarcode ?? '').trim();
    if (!serialNo && !packBarcode) {
      throw new BadRequestException(
        'PID 나 박스 바코드 중 하나는 넣으세요 (패킹이력이 950만 건입니다).',
      );
    }
    const rows = (await this.dataSource.query(
      `SELECT s.BARCODE            AS "serialNo",
              s.PACK_BARCODE       AS "packBarcode",
              s.MASTER_BARCODE     AS "masterBarcode",
              s.RUN_NO             AS "runNo",
              s.LINE_CODE          AS "lineCode",
              ln.LINE_NAME         AS "lineName",
              s.WORKSTAGE_CODE     AS "workstageCode",
              s.FINAL_INSPECT_FLAG AS "finalInspectFlag",
              s.BARCODE_QTY        AS "barcodeQty",
              m.MODEL_NAME         AS "modelName",
              m.MODEL_SUFFIX       AS "modelSuffix",
              m.PART_NO            AS "partNo",
              NVL(m.COMPLETE_FLAG, 'N') AS "completeFlag",
              NVL(m.RECEIPT_FLAG, 'N')  AS "receiptFlag",
              NVL(m.SHIP_FLAG, 'N')     AS "shipFlag",
              m.SHIP_NO            AS "shipNo",
              s.ENTER_BY           AS "enterBy",
              TO_CHAR(s.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "scanDate",
              TO_CHAR(m.PACK_DATE, 'YYYY-MM-DD')             AS "packDate",
              TO_CHAR(m.SHIP_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "shipDate"
         FROM IP_PRODUCT_PACK_SERIAL s
         LEFT JOIN IP_PRODUCT_PACK_MASTER m
                ON m.PACK_BARCODE = s.PACK_BARCODE
               AND m.ORGANIZATION_ID = s.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = s.LINE_CODE
               AND ln.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ORGANIZATION_ID = :organizationId
          ${serialNo ? 'AND s.BARCODE = :serialNo' : ''}
          ${packBarcode ? 'AND s.PACK_BARCODE = :packBarcode' : ''}
        ORDER BY s.SCAN_DATE DESC, s.BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        ...(serialNo ? { serialNo } : {}),
        ...(packBarcode ? { packBarcode } : {}),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 박스 만들기 (쓰기)

  /**
   * 박스 바코드를 만든다 (**쓰기**).
   *
   * 번호 규칙과 박스 행 생성은 **DB 가 한다** — `F_GET_CREATE_CELLBIZ_BARCODE` 를
   * 그대로 부른다. TypeScript 로 다시 만들면 PB 와 번호가 갈린다.
   *
   * **주의**: 그 안의 프로시저가 `AUTONOMOUS_TRANSACTION` + `COMMIT` 이라
   * **여기서 만든 박스는 즉시 확정된다.** 뒤 단계가 실패해도 남는다 (PB 와 같다).
   */
  async createPack(dto: PackCreateDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT F_GET_CREATE_CELLBIZ_BARCODE(
                :modelName, :modelSuffix, :itemCode, TRUNC(SYSDATE),
                :lineCode, :workstageCode, :packUnitQty) AS "packBarcode"
         FROM DUAL`,
      {
        modelName: dto.modelName,
        modelSuffix: dto.modelSuffix ?? '*',
        itemCode: dto.itemCode,
        lineCode: dto.lineCode,
        workstageCode: dto.workstageCode,
        packUnitQty: dto.packUnitQty,
      } as unknown as unknown[],
    )) as Row[];

    const packBarcode = String(rows[0]?.packBarcode ?? '');
    if (!packBarcode || packBarcode === 'ERROR') {
      throw new BadRequestException('박스 바코드를 만들지 못했습니다.');
    }
    return { packBarcode, organizationId };
  }

  // ───────────────────────────────── PID 담기·빼기 (쓰기)

  /**
   * PID 한 건을 박스에 담는다 (**쓰기**).
   *
   *   ① 2D바코드에서 런카드번호를 읽는다 (없으면 `'*'`)
   *   ② 박스가 있는지, 그 PID 가 이미 담겼는지 본다
   *   ③ `IP_PRODUCT_2D_BARCODE.BOX_NO` 에 박스를 적는다
   *   ④ `IP_PRODUCT_PACK_SERIAL` 한 행을 넣는다
   *   ⑤ 박스 수량을 1 올린다
   *
   * ②의 중복 검사는 **INSERT 문 안에서 다시** 한다. 검사와 INSERT 사이에 다른
   * 자리에서 같은 PID 를 찍으면 검사만으로는 못 막는다.
   */
  async scanPid(dto: PackScanDto, organizationId: number, userId: string) {
    const serialNo = dto.serialNo.trim();
    const packBarcode = dto.packBarcode.trim();
    if (!serialNo || !packBarcode) {
      throw new BadRequestException('박스 바코드와 PID 를 모두 넣으세요.');
    }

    const checks = ((await this.dataSource.query(
      `SELECT (SELECT COUNT(*) FROM IP_PRODUCT_PACK_MASTER m
                WHERE m.PACK_BARCODE = :packBarcode
                  AND m.ORGANIZATION_ID = :organizationId)  AS "packCount",
              (SELECT COUNT(*) FROM IP_PRODUCT_PACK_SERIAL s
                WHERE s.BARCODE = :serialNo
                  AND s.ORGANIZATION_ID = :organizationId)  AS "serialCount",
              (SELECT MAX(b.RUN_NO) FROM IP_PRODUCT_2D_BARCODE b
                WHERE b.SERIAL_NO = :serialNo
                  AND b.ORGANIZATION_ID = :organizationId)  AS "runNo"
         FROM DUAL`,
      { packBarcode, serialNo, organizationId } as unknown as unknown[],
    )) as Row[])[0] ?? {};

    if (Number(checks.packCount ?? 0) === 0) {
      throw new BadRequestException(`박스를 찾을 수 없습니다: ${packBarcode}`);
    }
    if (Number(checks.serialCount ?? 0) > 0) {
      throw new BadRequestException(`이미 담긴 PID 입니다: ${serialNo}`);
    }
    // PB 와 같이 2D 바코드가 없어도 막지 않는다 — 런카드번호만 '*' 가 된다.
    const runNo = (checks.runNo as string) ?? '*';

    return this.tx.run(async (qr) => {
      await qr.query(
        `UPDATE IP_PRODUCT_2D_BARCODE
            SET BOX_NO = :packBarcode,
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE SERIAL_NO = :serialNo
            AND ORGANIZATION_ID = :organizationId`,
        { packBarcode, serialNo, userId, organizationId } as unknown as unknown[],
      );

      const inserted = await qr.query(
        `INSERT INTO IP_PRODUCT_PACK_SERIAL
           (PACK_BARCODE, BARCODE, LINE_CODE, WORKSTAGE_CODE,
            FINAL_INSPECT_FLAG, FINAL_INSPECT_DATE,
            ATTR1, ATTR2, ATTR3, ATTR4, ATTR5,
            SCAN_DATE, ORGANIZATION_ID, ENTER_DATE, ENTER_BY,
            LAST_MODIFY_DATE, LAST_MODIFY_BY, RUN_NO, BARCODE_QTY, MASTER_BARCODE)
         SELECT :packBarcode, :serialNo, :lineCode, :workstageCode,
                -- PB 주석 그대로: P_INTERLOCK_CHECK 를 통과한 것만 찍히므로 'OK' 고정.
                'OK', SYSDATE,
                SUBSTR(:serialNo, 1, 5), SUBSTR(:serialNo, 6, 1),
                SUBSTR(:serialNo, 7, 1), SUBSTR(:serialNo, 8, 2),
                SUBSTR(:serialNo, 10, 5),
                SYSDATE, :organizationId, SYSDATE, :userId,
                SYSDATE, :userId, :runNo, 1, :masterBarcode
           FROM DUAL
          WHERE NOT EXISTS (
                  SELECT 1 FROM IP_PRODUCT_PACK_SERIAL x
                   WHERE x.BARCODE = :serialNo
                     AND x.ORGANIZATION_ID = :organizationId)`,
        {
          packBarcode,
          serialNo,
          lineCode: dto.lineCode,
          workstageCode: dto.workstageCode,
          organizationId,
          userId,
          runNo,
          masterBarcode: dto.masterBarcode ?? null,
        } as unknown as unknown[],
      );
      const affected = Number(
        (inserted as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(`이미 담긴 PID 입니다: ${serialNo}`);
      }

      await qr.query(
        `UPDATE IP_PRODUCT_PACK_MASTER
            SET PACK_QTY = NVL(PACK_QTY, 0) + 1,
                ATTR7 = NVL(:packCharger, ATTR7),
                ATTR8 = NVL(:qcCharger, ATTR8),
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE PACK_BARCODE = :packBarcode
            AND ORGANIZATION_ID = :organizationId`,
        {
          packCharger: dto.packCharger ?? null,
          qcCharger: dto.qcCharger ?? null,
          userId,
          packBarcode,
          organizationId,
        } as unknown as unknown[],
      );

      return { packBarcode, serialNo, runNo };
    });
  }

  /**
   * 잘못 담은 PID 를 뺀다 (**쓰기**). PB `언팩` 그대로 — 담을 때의 세 가지를 되돌린다.
   *
   * **포장완료된 박스는 건드리지 않는다.** PB 는 막지 않았지만, 완료 뒤에 빼면
   * 박스 수량과 실제 내용이 어긋난 채 입고로 넘어간다.
   */
  async unpackPid(dto: PackScanDto, organizationId: number, userId: string) {
    const serialNo = dto.serialNo.trim();
    const packBarcode = dto.packBarcode.trim();

    return this.tx.run(async (qr) => {
      const deleted = await qr.query(
        `DELETE FROM IP_PRODUCT_PACK_SERIAL s
          WHERE s.PACK_BARCODE = :packBarcode
            AND s.BARCODE = :serialNo
            AND s.ORGANIZATION_ID = :organizationId
            AND EXISTS (
                  SELECT 1 FROM IP_PRODUCT_PACK_MASTER m
                   WHERE m.PACK_BARCODE = s.PACK_BARCODE
                     AND m.ORGANIZATION_ID = s.ORGANIZATION_ID
                     AND NVL(m.COMPLETE_FLAG, 'N') <> 'Y'
                     AND NVL(m.RECEIPT_FLAG, 'N') <> 'Y')`,
        { packBarcode, serialNo, organizationId } as unknown as unknown[],
      );
      const affected = Number(
        (deleted as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          `뺄 수 없는 PID 입니다 (박스에 없거나 이미 포장완료·입고된 박스입니다): ${serialNo}`,
        );
      }

      await qr.query(
        `UPDATE IP_PRODUCT_2D_BARCODE
            SET BOX_NO = NULL,
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE SERIAL_NO = :serialNo
            AND ORGANIZATION_ID = :organizationId`,
        { serialNo, userId, organizationId } as unknown as unknown[],
      );

      await qr.query(
        `UPDATE IP_PRODUCT_PACK_MASTER
            SET PACK_QTY = GREATEST(NVL(PACK_QTY, 0) - 1, 0),
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE PACK_BARCODE = :packBarcode
            AND ORGANIZATION_ID = :organizationId`,
        { packBarcode, userId, organizationId } as unknown as unknown[],
      );

      return { packBarcode, serialNo, deletedRows: affected };
    });
  }

  // ───────────────────────────────── 포장완료 (쓰기)

  /**
   * 포장을 끝낸다 (**쓰기**). PB 그대로 — 수량을 **실제 담긴 개수로 다시 세어** 넣는다.
   * 중간에 담기·빼기가 어긋났어도 완료 시점에 맞춰진다.
   */
  async completePack(dto: PackCompleteDto, organizationId: number, userId: string) {
    const packBarcode = dto.packBarcode.trim();
    return this.tx.run(async (qr) => {
      const updated = await qr.query(
        `UPDATE IP_PRODUCT_PACK_MASTER x
            SET x.COMPLETE_FLAG = 'Y',
                x.PRINT_FLAG = 'Y',
                x.PACK_QTY = (SELECT COUNT(*) FROM IP_PRODUCT_PACK_SERIAL y
                               WHERE y.PACK_BARCODE = x.PACK_BARCODE
                                 AND y.ORGANIZATION_ID = x.ORGANIZATION_ID),
                x.LAST_MODIFY_DATE = SYSDATE,
                x.LAST_MODIFY_BY = :userId
          WHERE x.PACK_BARCODE = :packBarcode
            AND x.ORGANIZATION_ID = :organizationId
            -- 이미 입고된 박스는 다시 완료하지 않는다.
            AND NVL(x.RECEIPT_FLAG, 'N') <> 'Y'`,
        { packBarcode, userId, organizationId } as unknown as unknown[],
      );
      const affected = Number(
        (updated as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          `완료할 수 없는 박스입니다 (없거나 이미 입고됐습니다): ${packBarcode}`,
        );
      }
      const rows = (await qr.query(
        `SELECT PACK_QTY AS "packQty", PACKING_PCS_QTY AS "packingPcsQty"
           FROM IP_PRODUCT_PACK_MASTER
          WHERE PACK_BARCODE = :packBarcode AND ORGANIZATION_ID = :organizationId`,
        { packBarcode, organizationId } as unknown as unknown[],
      )) as Row[];
      return { packBarcode, ...(rows[0] ?? {}) };
    });
  }

  /** 재출력 횟수를 올린다 (**쓰기**). 인쇄 자체는 옮기지 않았다. */
  async markReprint(dto: PackCompleteDto, organizationId: number, userId: string) {
    const packBarcode = dto.packBarcode.trim();
    return this.tx.run(async (qr) => {
      const updated = await qr.query(
        `UPDATE IP_PRODUCT_PACK_MASTER
            SET REPRINT = NVL(REPRINT, 0) + 1,
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE PACK_BARCODE = :packBarcode
            AND ORGANIZATION_ID = :organizationId`,
        { packBarcode, userId, organizationId } as unknown as unknown[],
      );
      const affected = Number(
        (updated as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(`박스를 찾을 수 없습니다: ${packBarcode}`);
      }
      return { packBarcode, reprinted: true };
    });
  }

  /**
   * 빈 박스를 지운다 (**쓰기**).
   *
   * 박스 바코드는 `AUTONOMOUS_TRANSACTION` 으로 즉시 확정되므로, 만들고 아무것도
   * 담지 않으면 빈 박스가 남는다. **담긴 PID 가 하나라도 있으면 지우지 않는다.**
   */
  async deleteEmptyPack(dto: PackCompleteDto, organizationId: number) {
    const packBarcode = dto.packBarcode.trim();
    return this.tx.run(async (qr) => {
      const deleted = await qr.query(
        `DELETE FROM IP_PRODUCT_PACK_MASTER m
          WHERE m.PACK_BARCODE = :packBarcode
            AND m.ORGANIZATION_ID = :organizationId
            AND NVL(m.COMPLETE_FLAG, 'N') <> 'Y'
            AND NVL(m.RECEIPT_FLAG, 'N') <> 'Y'
            AND NOT EXISTS (
                  SELECT 1 FROM IP_PRODUCT_PACK_SERIAL s
                   WHERE s.PACK_BARCODE = m.PACK_BARCODE
                     AND s.ORGANIZATION_ID = m.ORGANIZATION_ID)`,
        { packBarcode, organizationId } as unknown as unknown[],
      );
      const affected = Number(
        (deleted as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          `지울 수 없는 박스입니다 (담긴 PID 가 있거나 이미 완료·입고됐습니다): ${packBarcode}`,
        );
      }
      return { packBarcode, deletedRows: affected };
    });
  }

  /** PB 가 `'%' + 값 + '%'` 로 넘기던 것을 같은 뜻으로 만든다. */
  private like(value?: string) {
    const trimmed = (value ?? '').trim();
    return trimmed ? `%${trimmed}%` : '%';
  }
}
