/**
 * @file src/modules/report/carrier-barcode.service.ts
 * @description 341 캐리어바코드 — PB w_product_carrier_barcode 이식
 *
 * 초보자 가이드:
 * 1. **이 화면은 리포트가 아니라 바코드 발행 화면이다.** 리포트 메뉴 아래 있고
 *    라벨 레이아웃(20x8 QR)을 갖고 있어 인쇄물처럼 보이지만, 실제로는
 *    IP_PRODUCT_CARRIER_BARCODE 에 바코드를 **새로 만들어 넣는다**.
 *    라벨 지오메트리만 보고 '인쇄물이니 제외' 하면 쓰기 화면이 조용히 빠진다.
 * 2. **형식은 `접두어 + 3자리 0채움 순번 + 접미어` 다.**
 *    PB: `:barcode || trim(to_char(:i,'000')) || :tail`
 * 3. **PB 는 1000번부터 깨진다.** Oracle `TO_CHAR(1000,'000')` 은 자리수가 넘쳐
 *    '###' 을 돌려준다 — 1000번 이상을 발행하면 바코드가 '###' 이 된다.
 *    LPAD 로 바꿨다: 1~999 는 PB 와 완전히 같고 그 이상은 자연히 자리수가 늘어난다.
 * 4. **PB 는 한 건씩 INSERT 를 돌렸다** (진행바를 띄우고 루프). 여기서는
 *    CONNECT BY 로 번호를 만들어 **한 문장으로 넣는다** — 결과는 같고 1,000장
 *    발행이 왕복 1,000번에서 1번이 된다.
 * 5. **이미 있는 바코드는 건너뛴다.** PB 는 그대로 INSERT 해서 PK 충돌이 나면
 *    루프 중간에 멈췄다 (앞부분만 들어간 상태로). 몇 건을 새로 넣고 몇 건이
 *    이미 있었는지 나눠 돌려준다.
 * 6. **이 표는 현재 0행이다** (실측) — 은성이 아직 캐리어 바코드를 쓰지 않는다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  CarrierBarcodeCreateDto,
  CarrierBarcodeDeleteDto,
  CarrierBarcodeQueryDto,
} from './report.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

/** 한 번에 발행할 수 있는 최대 장수. PB 는 상한이 없어 실수로 10만 장을 만들 수 있었다. */
const MAX_CREATE = 5000;

@Injectable()
export class CarrierBarcodeService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 발행된 캐리어 바코드 목록. 라벨 인쇄는 CSV 로 내보내 라벨 소프트웨어가 찍는다. */
  async find(query: CarrierBarcodeQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.SERIAL_NO                               AS "serialNo",
              c.LABEL_TEXT                              AS "labelText",
              c.ENTER_BY                                AS "enterBy",
              TO_CHAR(c.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              c.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(c.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IP_PRODUCT_CARRIER_BARCODE c
        WHERE c.SERIAL_NO LIKE :barcode ESCAPE '\\'
          AND c.ORGANIZATION_ID = :organizationId
        ORDER BY c.SERIAL_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        barcode: likePrefix(query.barcode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 범위 발행 (PB '2D Barcode Create' — **쓰기**).
   *
   * 번호를 CONNECT BY 로 만들고 이미 있는 것만 빼고 한 번에 넣는다.
   * 발행 전후 건수를 세어 '새로 넣은 것 / 이미 있던 것' 을 나눠 돌려준다 —
   * 하나로 뭉치면 "1,000장 발행" 이라고 말하면서 실제로는 0장일 수 있다.
   */
  async create(dto: CarrierBarcodeCreateDto, organizationId: number, userId: string) {
    if (dto.endSerial < dto.startSerial) {
      throw new BadRequestException('끝 순번이 시작 순번보다 작습니다.');
    }
    const count = dto.endSerial - dto.startSerial + 1;
    if (count > MAX_CREATE) {
      throw new BadRequestException(
        `한 번에 ${MAX_CREATE}장까지 발행할 수 있습니다 (요청 ${count.toLocaleString()}장).`,
      );
    }

    return this.tx.run(async (qr) => {
      // Oracle 은 문장에 없는 바인드를 넘기면 거부한다 (ORA-01036 실측).
      // 카운트 쿼리에는 :userId 가 없으므로 바인드 묶음을 따로 만든다.
      const numberBinds = {
        prefix: dto.prefix,
        suffix: dto.suffix ?? '',
        startSerial: dto.startSerial,
        endSerial: dto.endSerial,
        organizationId,
      };
      const insertBinds = { ...numberBinds, userId };
      // PB 의 to_char(i,'000') 은 1000 이상에서 '###' 이 된다. LPAD 는 1~999 에서
      // PB 와 같고 그 이상은 자리수가 늘어난다.
      const serialExpr =
        `:prefix || LPAD(TO_CHAR(LEVEL + :startSerial - 1), 3, '0') || :suffix`;
      const numbers =
        `SELECT ${serialExpr} AS SERIAL_NO
           FROM DUAL
        CONNECT BY LEVEL <= :endSerial - :startSerial + 1`;

      const existing = (await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM (${numbers}) n
          WHERE EXISTS ( SELECT 1 FROM IP_PRODUCT_CARRIER_BARCODE c
                          WHERE c.SERIAL_NO = n.SERIAL_NO
                            AND c.ORGANIZATION_ID = :organizationId )`,
        numberBinds as unknown as unknown[],
      )) as Row[];

      const result = await qr.query(
        `INSERT INTO IP_PRODUCT_CARRIER_BARCODE
           (SERIAL_NO, LABEL_TEXT, ORGANIZATION_ID, ENTER_DATE, ENTER_BY)
         SELECT n.SERIAL_NO, n.SERIAL_NO, :organizationId, SYSDATE, :userId
           FROM (${numbers}) n
          WHERE NOT EXISTS ( SELECT 1 FROM IP_PRODUCT_CARRIER_BARCODE c
                              WHERE c.SERIAL_NO = n.SERIAL_NO
                                AND c.ORGANIZATION_ID = :organizationId )`,
        insertBinds as unknown as unknown[],
      );

      return {
        requested: count,
        created: Number(affectedRows(result) ?? 0),
        alreadyExisted: Number(existing[0]?.cnt ?? 0),
        firstSerial: `${dto.prefix}${String(dto.startSerial).padStart(3, '0')}${dto.suffix ?? ''}`,
        lastSerial: `${dto.prefix}${String(dto.endSerial).padStart(3, '0')}${dto.suffix ?? ''}`,
      };
    });
  }

  /**
   * 발행 취소 (PB '2D Barcode Delete' — **쓰기**).
   *
   * 앞부분 일치로 지운다 (PB 와 같다). 되돌릴 수 없으니 지운 건수를 돌려주고,
   * 화면은 확인 모달에 대상 건수를 먼저 보여준다.
   */
  async remove(dto: CarrierBarcodeDeleteDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const binds = {
        barcode: likePrefix(dto.barcode),
        organizationId,
      };
      const before = (await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_CARRIER_BARCODE
          WHERE SERIAL_NO LIKE :barcode ESCAPE '\\'
            AND ORGANIZATION_ID = :organizationId`,
        binds as unknown as unknown[],
      )) as Row[];
      const result = await qr.query(
        `DELETE FROM IP_PRODUCT_CARRIER_BARCODE
          WHERE SERIAL_NO LIKE :barcode ESCAPE '\\'
            AND ORGANIZATION_ID = :organizationId`,
        binds as unknown as unknown[],
      );
      return {
        matched: Number(before[0]?.cnt ?? 0),
        deleted: Number(affectedRows(result) ?? 0),
      };
    });
  }

  /** 삭제 전에 화면이 대상 건수를 먼저 보여줄 수 있어야 한다. */
  async count(query: CarrierBarcodeQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_CARRIER_BARCODE
        WHERE SERIAL_NO LIKE :barcode ESCAPE '\\'
          AND ORGANIZATION_ID = :organizationId`,
      {
        barcode: likePrefix(query.barcode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return { rows: Number(rows[0]?.cnt ?? 0) };
  }
}
