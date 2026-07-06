# FCT Inspection Monitoring Design

## Decision

Use the selected Visual Companion option `control-room`: a production quality control dashboard for `/display/42`.

## Data Source

- Main table: `IQ_MACHINE_INSPECT_DATA_FCT`
- Product join: `IP_PRODUCT_2D_BARCODE.SERIAL_NO = IQ_MACHINE_INSPECT_DATA_FCT.PID`
- Result field: `IQ_MACHINE_INSPECT_DATA_FCT.INSPECT_RESULT`
- Model field: `IP_PRODUCT_2D_BARCODE.MODEL_NAME`
- Date basis: FCT has no `ACTUAL_DATE`, so the display derives the workday from `INSPECT_DATE` using the factory day boundary `07:30 ~ next day 07:30`. The current workday starts at `TRUNC(SYSDATE - 7.5/24) + 7.5/24`.

## Screen

The page fills the existing display shell with a 2x2 chart grid:

1. Today defect rate by model
2. Recent 7-day FPY trend
3. Today inspection KPI donut
4. Weekly top defect models

The existing menu card for `/display/42` is reused as the FCT entry.

## Error Handling

The API returns empty chart arrays and HTTP 500 on database failure. The client shows the existing display load-error state.

## Verification

- Run TypeScript compile.
- Call `/api/display/42` directly to confirm Oracle SQL and JSON shape.
