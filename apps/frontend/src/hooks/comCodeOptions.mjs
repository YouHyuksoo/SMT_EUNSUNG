/** @typedef {{ detailCode: string, codeName: string }} ComCodeOptionItem */

/**
 * @param {string} value
 * @returns {string}
 */
export function normalizeComCodeType(value) {
  return value.toUpperCase().replace(/[^A-Z0-9]+/g, "");
}

/**
 * @template {ComCodeOptionItem} T
 * @param {Record<string, T[]> | undefined} groups
 * @param {string} requestedType
 * @returns {{ groupCode: string, codes: T[] }}
 */
export function resolveComCodeGroup(groups, requestedType) {
  if (!groups) return { groupCode: requestedType, codes: [] };
  if (groups[requestedType]) return { groupCode: requestedType, codes: groups[requestedType] };

  const normalized = normalizeComCodeType(requestedType);
  const groupCode = Object.keys(groups).find(
    (candidate) => normalizeComCodeType(candidate) === normalized,
  );
  return groupCode
    ? { groupCode, codes: groups[groupCode] }
    : { groupCode: requestedType, codes: [] };
}

/**
 * @template {ComCodeOptionItem} T
 * @param {Record<string, T[]> | undefined} groups
 * @param {string} requestedType
 * @param {(groupCode: string, detailCode: string, fallback: string) => string} getName
 * @param {boolean} includeAll
 * @param {boolean} showCode
 * @param {string} allLabel
 */
export function buildComCodeOptions(
  groups,
  requestedType,
  getName,
  includeAll,
  showCode,
  allLabel,
) {
  const resolved = resolveComCodeGroup(groups, requestedType);
  const options = resolved.codes.map((code) => {
    const name = getName(resolved.groupCode, code.detailCode, code.codeName);
    return {
      value: code.detailCode,
      label: showCode && name !== code.detailCode ? `${code.detailCode} - ${name}` : name,
    };
  });
  return includeAll ? [{ value: "", label: allLabel }, ...options] : options;
}
