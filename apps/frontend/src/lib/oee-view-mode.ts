export const OEE_MULTI_ENTRY_PATH = "/oee/multi-entry";
export const OEE_MULTI_ENTRY_7IN_PATH = "/oee/multi-entry-7in";

export type OeeViewMode = "normal" | "full";

/** Resolve the OEE entry view without changing the route that owns its state. */
export function resolveOeeViewMode(
  pathname: string | null | undefined,
  view: string | null | undefined,
): OeeViewMode {
  if (view === "full") return "full";
  if (view === "normal") return "normal";
  return pathname === OEE_MULTI_ENTRY_7IN_PATH ? "full" : "normal";
}

export function isOeeMultiEntryPath(pathname: string | null | undefined): boolean {
  return pathname === OEE_MULTI_ENTRY_PATH || pathname === OEE_MULTI_ENTRY_7IN_PATH;
}

export function resolveOeeMenuPath(pathname: string): string {
  return pathname === OEE_MULTI_ENTRY_7IN_PATH ? OEE_MULTI_ENTRY_PATH : pathname;
}
