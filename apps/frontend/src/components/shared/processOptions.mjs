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
