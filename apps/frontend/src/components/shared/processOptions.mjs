/** @typedef {{ processCode: string, processName: string, processType?: string }} ProcessOptionItem */
/** @typedef {{ codeName: string }} ProcessTypeItem */

/**
 * @template {ProcessOptionItem} T
 * @param {T[]} processes
 * @param {Record<string, ProcessTypeItem>} processTypeMap
 * @param {boolean} showProcessType
 * @returns {{ value: string, label: string }[]}
 */
export function buildProcessOptions(processes, processTypeMap, showProcessType) {
  return processes.map((process) => {
    const defaultLabel = `${process.processCode} - ${process.processName}`;
    if (!showProcessType) {
      return { value: process.processCode, label: defaultLabel };
    }

    const processType = process.processType ?? "";
    const processTypeName = processTypeMap[processType]?.codeName ?? processType;
    const label = [process.processCode, process.processName, processTypeName]
      .filter(Boolean)
      .join(" | ");
    return { value: process.processCode, label };
  });
}

/**
 * 실적·지시 대상 제조공정인가 — SMT 공정(공정그룹 SMT)과 검사공정(공정유형 Q)은 뺀다.
 * @param {{ codeGroup?: string | null, processType?: string | null }} process
 * @returns {boolean}
 */
export function isManufacturingProcess(process) {
  return process.codeGroup !== 'SMT' && process.processType !== 'Q';
}
