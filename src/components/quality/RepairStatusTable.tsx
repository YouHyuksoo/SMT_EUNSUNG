/**
 * @file src/components/quality/RepairStatusTable.tsx
 * @description Shared repair status table.
 */

"use client";

import { useTranslations } from "next-intl";
import type { RepairStatusRow } from "@/types/repair-status";

interface Props {
  rows: RepairStatusRow[];
}

export default function RepairStatusTable({ rows }: Props) {
  const t = useTranslations("ctq");

  return (
    <div className="overflow-auto h-full">
      <table className="w-full text-xs border-separate border-spacing-0">
        <thead className="sticky top-0 z-20" style={{ boxShadow: "0 2px 0 0 #1f2937" }}>
          <tr className="bg-gray-800">
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("table.time")}
            </th>
            <th className="text-left px-2 py-1 border border-gray-700 bg-gray-800 sticky left-0 z-30">
              PID
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("common.line")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("table.model")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("pages.repairStatus.workstage")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("pages.repairStatus.repairWorkstage")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("pages.repairStatus.qcResult")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("table.repairLabel")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("table.receipt")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("table.location")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("table.defectPart")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("table.badReason")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("pages.repairStatus.badReasonName")}
            </th>
            <th className="text-center px-2 py-1 border border-gray-700 bg-gray-800">
              {t("table.handling")}
            </th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row, idx) => {
            const isNewGroup = idx === 0 || rows[idx - 1].workstageName !== row.workstageName;
            return (
            <tr key={idx} className={`hover:bg-gray-800/30 ${isNewGroup ? "border-t-2 border-t-blue-600" : "border-t border-gray-800"}`}>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300 whitespace-nowrap">
                {row.qcDate}
              </td>
              <td className="px-2 py-0.5 font-mono text-gray-200 whitespace-nowrap border border-gray-800 sticky left-0 bg-gray-950 z-10">
                {row.pid}
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300 whitespace-nowrap">
                {row.lineName}
                <span className="ml-1 text-xs text-gray-500">({row.lineCode})</span>
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300 whitespace-nowrap">
                {row.modelName}
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300 whitespace-nowrap">
                {row.workstageName}
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300 whitespace-nowrap">
                {row.repairWorkstageName}
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 whitespace-nowrap">
                <span className={row.qcResultName === "-" ? "text-gray-500" : "text-yellow-400 font-bold"}>
                  {row.qcResultName}
                </span>
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 whitespace-nowrap">
                <span className={
                  row.repairResultName === "수리완료" ? "text-green-400 font-bold"
                  : row.repairResultName === "대기"     ? "text-yellow-400 font-bold"
                  : row.repairResultName === "불합격"   ? "text-red-400 font-bold"
                  : "text-gray-500"
                }>
                  {row.repairResultName}
                </span>
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 whitespace-nowrap">
                <span className={
                  row.receiptName === "1입고" ? "text-cyan-400 font-bold"
                  : row.receiptName === "2반품" ? "text-orange-400 font-bold"
                  : "text-gray-400"
                }>
                  {row.receiptName}
                </span>
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300">
                {row.locationCode}
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300 whitespace-nowrap">
                {row.defectItemCode}
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-400 whitespace-nowrap">
                {row.badReasonCode}
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300 whitespace-nowrap">
                {row.badReasonName}
              </td>
              <td className="px-2 py-0.5 text-center border border-gray-800 text-gray-300 whitespace-nowrap">
                {row.handlingName}
              </td>
            </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
