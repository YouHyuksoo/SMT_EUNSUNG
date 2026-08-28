import type { OeeResource } from '../../entry/_lib/oee-entry';

export type MultiEntryMode = 'START' | 'END';
export type CommandOutcomeState = 'success' | 'replayed' | 'conflict' | 'error';

export interface ResourceSelectionItem {
  resource: OeeResource;
  resourceKey: string;
}

export interface CommandOutcomeView {
  resourceKey: string;
  resourceCode: string;
  mode: MultiEntryMode;
  requestId: string;
  state: CommandOutcomeState;
  message: string;
}

/** Keeps idempotency state scoped to one operation, one resource, and one payload signature. */
export function commandKey(mode: MultiEntryMode, resourceKey: string, signature: string): string {
  return `${mode}:${resourceKey}:${signature}`;
}

export function isTerminalSuccess(state: CommandOutcomeState | undefined): boolean {
  return state === 'success' || state === 'replayed';
}

export function isRetryableOutcome(state: CommandOutcomeState | undefined): boolean {
  return state === 'conflict' || state === 'error';
}

export function selectRetryableResources<T extends ResourceSelectionItem>(
  selected: T[],
  outcomes: Map<string, CommandOutcomeView>,
): T[] {
  return selected.filter((item) => {
    const outcome = outcomes.get(item.resourceKey);
    return !outcome || isRetryableOutcome(outcome.state);
  });
}
