export interface ComCodeOptionItem {
  detailCode: string;
  codeName: string;
}

export type ComCodeOptionMap = Record<string, ComCodeOptionItem[]>;

export function normalizeComCodeType(value: string): string {
  return value.toUpperCase().replace(/[^A-Z0-9]+/g, "");
}

export function resolveComCodeGroup<T extends ComCodeOptionItem>(
  groups: Record<string, T[]> | undefined,
  requestedType: string,
): { groupCode: string; codes: T[] } {
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

export function buildComCodeOptions<T extends ComCodeOptionItem>(
  groups: Record<string, T[]> | undefined,
  requestedType: string,
  getName: (groupCode: string, detailCode: string, fallback: string) => string,
  includeAll: boolean,
  showCode: boolean,
  allLabel: string,
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
