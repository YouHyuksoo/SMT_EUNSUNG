/**
 * @file src/modules/inventory-query/stocktake-book.ts
 * @description 자재 실사 — 실사 중 입출고를 반영한 "비교할 장부"(BOOK_EFF) 계산 SQL
 *
 * 초보자 가이드:
 * 1. **실사 중에도 입출고를 멈추지 않는다.** 실사표의 장부(INVENTORY_QTY)는 실사를 시작한 순간 고정되지만,
 *    그 뒤에도 출고·입고가 일어난다. 고정 장부와 그냥 비교하면 시작 뒤 출고된 롯트는 한 번 더 빠지고,
 *    시작 뒤 입고돼 찍힌 롯트는 한 번 더 더해진다. 그래서 롯트마다 비교할 장부를 따로 잡는다.
 * 2. **찍은 롯트**: 찍을 때의 장부(스캔 기록 IM_ITEM_INVENTORY_CHECK_BCD.INVENTORY_QTY) − 찍기 전에 넣은 조정.
 *    찍은 뒤의 입출고는 실제 움직임이라 비교에서 뺀다.
 * 3. **안 찍힌 롯트**: 최소(지금 재고 − 넣은 조정, 시작 때 고정 장부), 0 아래로는 안 내린다.
 *    시작 뒤 출고된 만큼은 다시 빼지 않고, 시작 뒤 입고된 만큼은 지우지 않는다.
 * 4. **남은 조정 = 실사 − 비교 장부 − 넣은 조정** (부호: 실사 − 장부, 남음 +). 조정을 넣으면 0 이 되어
 *    다시 눌러도 두 번 들어가지 않는다. 넣은 조정 = 그 기간 M009 출고(부호 반전).
 * 5. 바인드: :yyyymm, :organizationId. 결과 열: 실사표 c.* 의 주요 열 + SCANNED_YN · COUNTED · BOOK_EFF · POSTED.
 */
import { periodBoundsSql } from './close-period';

export const materialCheckBookSql = () => `
  SELECT c.CLOSE_YYYYMM, c.ITEM_CODE, c.MATERIAL_MFS, c.LINE_TYPE, c.LOCATION_CODE, c.INVENTORY_HOLD,
         c.INVENTORY_PRICE, c.INVENTORY_AMT, c.INVENTORY_QTY AS FROZEN_QTY, c.COMMENTS, c.ENTER_BY, c.ENTER_DATE,
         c.ORGANIZATION_ID,
         CASE WHEN b.LOT_NO IS NOT NULL THEN 'Y' ELSE 'N' END AS SCANNED_YN,
         NVL(c.CHECK_INVENTORY_QTY, 0) AS COUNTED,
         NVL(pa.POSTED, 0) AS POSTED,
         CASE WHEN b.LOT_NO IS NOT NULL
              THEN NVL(b.BOOK_AT_SCAN, 0) - NVL(pb.POSTED, 0)
              ELSE GREATEST(0, LEAST(NVL(v.CUR, 0) - NVL(pa.POSTED, 0), NVL(c.INVENTORY_QTY, 0)))
         END AS BOOK_EFF
    FROM IM_ITEM_INVENTORY_CHECK c
    LEFT JOIN (SELECT ITEM_CODE, LOT_NO, SUM(NVL(INVENTORY_QTY, 0)) AS BOOK_AT_SCAN, MIN(ENTER_DATE) AS SCANNED_AT
                 FROM IM_ITEM_INVENTORY_CHECK_BCD
                WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
                GROUP BY ITEM_CODE, LOT_NO) b
           ON b.ITEM_CODE = c.ITEM_CODE AND b.LOT_NO = c.MATERIAL_MFS
    LEFT JOIN (SELECT v.ITEM_CODE, v.MATERIAL_MFS, SUM(v.INVENTORY_QTY) AS CUR
                 FROM IM_ITEM_INVENTORY v
                WHERE v.ORGANIZATION_ID = :organizationId
                  AND (v.ITEM_CODE, v.MATERIAL_MFS) IN (SELECT k.ITEM_CODE, k.MATERIAL_MFS FROM IM_ITEM_INVENTORY_CHECK k
                                                         WHERE k.CLOSE_YYYYMM = :yyyymm AND k.ORGANIZATION_ID = :organizationId)
                GROUP BY v.ITEM_CODE, v.MATERIAL_MFS) v
           ON v.ITEM_CODE = c.ITEM_CODE AND v.MATERIAL_MFS = c.MATERIAL_MFS
    LEFT JOIN (SELECT s.ITEM_CODE, s.MATERIAL_MFS, -SUM(s.ISSUE_QTY) AS POSTED
                 FROM IM_ITEM_ISSUE s
                WHERE s.ISSUE_ACCOUNT = 'M009' AND s.ORGANIZATION_ID = :organizationId
                  AND ${periodBoundsSql('s.ISSUE_DATE', ':yyyymm', ':organizationId')}
                GROUP BY s.ITEM_CODE, s.MATERIAL_MFS) pa
           ON pa.ITEM_CODE = c.ITEM_CODE AND pa.MATERIAL_MFS = c.MATERIAL_MFS
    LEFT JOIN (SELECT s.ITEM_CODE, s.MATERIAL_MFS, -SUM(s.ISSUE_QTY) AS POSTED
                 FROM IM_ITEM_ISSUE s
                 JOIN (SELECT ITEM_CODE, LOT_NO, MIN(ENTER_DATE) AS SCANNED_AT FROM IM_ITEM_INVENTORY_CHECK_BCD
                        WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
                        GROUP BY ITEM_CODE, LOT_NO) x
                   ON x.ITEM_CODE = s.ITEM_CODE AND x.LOT_NO = s.MATERIAL_MFS
                WHERE s.ISSUE_ACCOUNT = 'M009' AND s.ORGANIZATION_ID = :organizationId
                  AND ${periodBoundsSql('s.ISSUE_DATE', ':yyyymm', ':organizationId')}
                  AND s.ENTER_DATE < x.SCANNED_AT
                GROUP BY s.ITEM_CODE, s.MATERIAL_MFS) pb
           ON pb.ITEM_CODE = c.ITEM_CODE AND pb.MATERIAL_MFS = c.MATERIAL_MFS
   WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId`;
