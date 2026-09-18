export const OEE_MULTI_ENTRY_PATH = "/oee/multi-entry";

export type OeeViewMode = "normal" | "full";

/** Resolve the OEE entry view without changing the route that owns its state. */
export function resolveOeeViewMode(
  view: string | null | undefined,
): OeeViewMode {
  if (view === "full") return "full";
  return "normal";
}

export function isOeeMultiEntryPath(pathname: string | null | undefined): boolean {
  return pathname === OEE_MULTI_ENTRY_PATH;
}
