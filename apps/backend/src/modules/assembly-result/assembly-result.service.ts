/**
 * @file src/modules/assembly-result/assembly-result.service.ts
 * @description 조립실적(IP_ASSEMBLY_RESULT) — 생산실적 원천. 수기 작업실적·보정을 넣고 목록을 본다.
 *
 * 초보자 가이드:
 * 1. 생산실적은 2026-10-17부터 센서실적이 아니라 조립실적이다. AOI 양품은 DB 트리거가 실시간으로 넣고
 *    (ENTER_BY = 'AOI_JOB'), 수기 작업실적(WORK_RESULT)과 보정(ASSY_ADJUST)은 이 서비스가 넣는다.
 *    설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md
 * 2. 넣는 일은 전부 DB 프로시저 P_ASSY_RESULT_ADD 가 한다 — 생산 품목(모델 마스터 T/B면 품목) 결정, 시간대(A~J),
 *    전환 시각 이후면 공정재고(반제품 공정입고 + 직속 자품목 공정출고)까지 같은 규칙으로 움직인다.
 *    TypeScript 로 다시 쓰면 AOI 실시간 처리와 규칙이 갈린다.
 * 3. 고치는 방법은 보정 행 추가뿐이다. 행을 바꾸거나 지우지 않는다 — 수정은 차이만큼, 삭제는 음수 보정이다.
 * 4. 목록·집계는 IP_ASSEMBLY_RESULT_SENSOR_V (센서 시간대 테이블과 같은 모양의 뷰)를 읽는다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { OracleService } from '../../common/services/oracle.service';
import { namedBinds } from '../../common/utils/named-binds.util';
import { AssemblyAdjustDto, AssemblyResultQueryDto } from './assembly-result.dto';

export type AssemblySource = 'MANUAL' | 'ADJUST';

export interface AssemblyAddInput {
  runNo: string;
  lineCode?: string | null;
  /** 실적 시각 — 작업일·시간대·공정재고 반영 여부가 이 시각으로 정해진다 */
  time: Date;
  /** 수량 (보정·취소는 음수) */
  qty: number;
  source: AssemblySource;
  remark?: string | null;
  user: string;
}

const like = (v?: string) => (v?.trim() ? `${v.trim()}%` : '%');

@Injectable()
export class AssemblyResultService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly oracle: OracleService,
  ) {}

  /** 조립실적 한 건 (수기·보정). 넣지 못하면 프로시저가 알려 준 이유로 400 을 낸다. */
  async add(input: AssemblyAddInput): Promise<{ itemCode: string; productDate: Date; productSeq: number }> {
    if (!input.qty) throw new BadRequestException('수량이 0 입니다.');
    let lineCode = input.lineCode ?? null;
    if (!lineCode) {
      const rows = (await this.dataSource.query(
        `SELECT LINE_CODE AS "lineCode" FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO = :runNo AND ORGANIZATION_ID = 1`,
        namedBinds({ runNo: input.runNo }),
      )) as { lineCode: string | null }[];
      lineCode = rows[0]?.lineCode ?? null;
    }
    // 바인드 순서 = 프로시저 파라미터 순서 (callProcScalar 는 이름이 아니라 자리로 넘긴다)
    const out = await this.oracle.callProcScalar(
      'P_ASSY_RESULT_ADD',
      [
        { name: 'P_ITEM_CODE', type: 'STRING', maxSize: 30 },
        { name: 'P_PRODUCT_DATE', type: 'DATE' },
        { name: 'P_PRODUCT_SEQ', type: 'NUMBER' },
        { name: 'P_RESULT', type: 'STRING', maxSize: 200 },
      ],
      {
        P_RUN_NO: input.runNo,
        P_LINE_CODE: lineCode,
        P_TIME: input.time,
        P_QTY: input.qty,
        P_SOURCE: input.source,
        P_REMARK: input.remark ?? null,
        P_USER: input.user,
      },
      { autoCommit: true },
    );
    const result = String(out.P_RESULT ?? '');
    if (result !== 'OK') throw new BadRequestException(`조립실적을 넣지 못했습니다: ${result || '응답 없음'}`);
    return {
      itemCode: String(out.P_ITEM_CODE),
      productDate: out.P_PRODUCT_DATE as Date,
      productSeq: Number(out.P_PRODUCT_SEQ),
    };
  }

  /** 목록 — 작업일 기간. 자동(AOI)·수기·보정을 함께 본다. */
  async find(query: AssemblyResultQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(a.RECEIPT_DATE, 'YYYY-MM-DD') AS "workDate",
              TO_CHAR(a.RECEIPT_DATE, 'YYYYMMDDHH24MISS') AS "receiptDateKey",
              a.RECEIPT_SEQUENCE AS "receiptSequence",
              a.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              a.RUN_NO AS "runNo", a.MODEL_NAME AS "modelName", a.PCB_ITEM AS "pcbItem",
              a.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
              a.TIME_DIVISION AS "timeDivision",
              a.PRODUCT_ACTUAL_QTY AS "qty",
              a.ACTUAL_SOURCE AS "source", a.REMARK AS "remark",
              a.WORKSTAGE_ISSUE_YN AS "wipApplied",
              TO_CHAR(a.LAST_RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "actualTime",
              a.LAST_MODIFY_BY AS "lastModifyBy"
         FROM IP_ASSEMBLY_RESULT_SENSOR_V a
         LEFT JOIN IP_PRODUCT_LINE pl ON pl.LINE_CODE = a.LINE_CODE AND pl.ORGANIZATION_ID = a.ORGANIZATION_ID
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = a.ITEM_CODE AND i.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE a.ORGANIZATION_ID = :organizationId
          AND a.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(a.LINE_CODE, '*') LIKE :lineCode
          AND NVL(a.MODEL_NAME, '*') LIKE :modelName
          AND NVL(a.RUN_NO, '*') LIKE :runNo
          AND a.ACTUAL_SOURCE LIKE :source
        ORDER BY a.LAST_RECEIPT_DATE DESC, a.RECEIPT_SEQUENCE DESC`,
      namedBinds({
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: like(query.lineCode),
        modelName: like(query.modelName),
        runNo: like(query.runNo),
        source: query.source?.trim() || '%',
      }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /** 보정 등록 — 사유는 필수. 실적 시각의 작업일·시간대에 들어간다. */
  async adjust(dto: AssemblyAdjustDto, user: string) {
    const time = new Date(`${dto.actualTime.replace(' ', 'T')}:00+09:00`);
    if (Number.isNaN(time.getTime())) throw new BadRequestException('실적 시각 형식이 올바르지 않습니다.');
    return this.add({
      runNo: dto.runNo.trim(), lineCode: dto.lineCode ?? null, time, qty: dto.qty,
      source: 'ADJUST', remark: dto.reason.trim(), user,
    });
  }

  /**
   * 기존 행 기준 보정 — 같은 런·라인·실적 시각으로 delta 만큼 보정 행을 넣는다.
   * 행 키는 작업일(YYYYMMDDHH24MISS) + 순번이다 (조립실적 PK).
   */
  async adjustRow(
    key: { receiptDateKey: string; receiptSequence: number },
    delta: (currentQty: number) => number,
    reason: string,
    user: string,
  ) {
    const rows = (await this.dataSource.query(
      `SELECT a.RUN_NO AS "runNo", a.LINE_CODE AS "lineCode", a.PRODUCT_ACTUAL_QTY AS "qty",
              a.LAST_RECEIPT_DATE AS "time"
         FROM IP_ASSEMBLY_RESULT_SENSOR_V a
        WHERE TO_CHAR(a.RECEIPT_DATE, 'YYYYMMDDHH24MISS') = :receiptDateKey
          AND a.RECEIPT_SEQUENCE = :receiptSequence AND a.ORGANIZATION_ID = 1`,
      namedBinds({ receiptDateKey: key.receiptDateKey, receiptSequence: key.receiptSequence }),
    )) as { runNo: string; lineCode: string | null; qty: number | null; time: Date }[];
    const row = rows[0];
    if (!row) throw new NotFoundException('조립실적을 찾을 수 없습니다.');
    const qty = delta(Number(row.qty ?? 0));
    if (!qty) return { changed: 0 };
    await this.add({ runNo: row.runNo, lineCode: row.lineCode, time: row.time, qty, source: 'ADJUST', remark: reason, user });
    return { changed: 1, adjustQty: qty };
  }
}
