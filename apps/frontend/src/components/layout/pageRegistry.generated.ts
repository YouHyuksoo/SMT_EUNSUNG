/**
 * @file src/components/layout/pageRegistry.generated.ts
 * @description 자동 생성 파일 — 직접 수정 금지. `node scripts/gen-page-registry.mjs`로 재생성.
 *              (authenticated) 영역 경로 → 페이지별 lazy dynamic factory.
 *              현재 경로의 작은 registry만 필요 시 import해 dev 서버의 전체 page compile 폭주를 피한다.
 */
import type { ComponentType } from "react";

const pageComponentCache = new Map<string, ComponentType>();
const pageComponentPromiseCache = new Map<string, Promise<ComponentType | null>>();

export async function getPageComponent(path: string): Promise<ComponentType | null> {
  const cached = pageComponentCache.get(path);
  if (cached) return cached;

  const pending = pageComponentPromiseCache.get(path);
  if (pending) return pending;

  const promise = loadPageComponent(path);
  pageComponentPromiseCache.set(path, promise);
  const component = await promise;
  if (component) pageComponentCache.set(path, component);
  pageComponentPromiseCache.delete(path);
  return component;
}

async function loadPageComponent(path: string): Promise<ComponentType | null> {
  let component: ComponentType | null = null;
  switch (path) {
    case "/bom/replace-bom": {
      const mod = await import("./page-registries/bom__replace-bom.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/confirm/bom": {
      const mod = await import("./page-registries/confirm__bom.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/confirm/buy-price": {
      const mod = await import("./page-registries/confirm__buy-price.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/confirm/mold-price": {
      const mod = await import("./page-registries/confirm__mold-price.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/confirm/sale-price": {
      const mod = await import("./page-registries/confirm__sale-price.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/dashboard": {
      const mod = await import("./page-registries/dashboard.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/design/apply-item": {
      const mod = await import("./page-registries/design__apply-item.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/aoi": {
      const mod = await import("./page-registries/equipment__result-query__aoi.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/ict": {
      const mod = await import("./page-registries/equipment__result-query__ict.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/performance": {
      const mod = await import("./page-registries/equipment__result-query__performance.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/reflow": {
      const mod = await import("./page-registries/equipment__result-query__reflow.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/rom-write": {
      const mod = await import("./page-registries/equipment__result-query__rom-write.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/router": {
      const mod = await import("./page-registries/equipment__result-query__router.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/solder": {
      const mod = await import("./page-registries/equipment__result-query__solder.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/sp": {
      const mod = await import("./page-registries/equipment__result-query__sp.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/equipment/result-query/spi": {
      const mod = await import("./page-registries/equipment__result-query__spi.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/feeder/adjust": {
      const mod = await import("./page-registries/feeder__adjust.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/feeder/master": {
      const mod = await import("./page-registries/feeder__master.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/feeder/repair": {
      const mod = await import("./page-registries/feeder__repair.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/help": {
      const mod = await import("./page-registries/help.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/inventory-query/barcode-check": {
      const mod = await import("./page-registries/inventory-query__barcode-check.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/inventory-query/inventory-check": {
      const mod = await import("./page-registries/inventory-query__inventory-check.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/inventory-query/inventory-close": {
      const mod = await import("./page-registries/inventory-query__inventory-close.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/inventory-query/total-inventory": {
      const mod = await import("./page-registries/inventory-query__total-inventory.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/clean-check": {
      const mod = await import("./page-registries/jig__clean-check.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/input-history": {
      const mod = await import("./page-registries/jig__input-history.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/issue": {
      const mod = await import("./page-registries/jig__issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/mask-check": {
      const mod = await import("./page-registries/jig__mask-check.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/master": {
      const mod = await import("./page-registries/jig__master.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/pm": {
      const mod = await import("./page-registries/jig__pm.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/repair": {
      const mod = await import("./page-registries/jig__repair.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/repair-request": {
      const mod = await import("./page-registries/jig__repair-request.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/sample": {
      const mod = await import("./page-registries/jig__sample.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/sample-bcr-history": {
      const mod = await import("./page-registries/jig__sample-bcr-history.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/sample-input-history": {
      const mod = await import("./page-registries/jig__sample-input-history.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/jig/squeeze-check": {
      const mod = await import("./page-registries/jig__squeeze-check.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/bom": {
      const mod = await import("./page-registries/master__bom.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/code": {
      const mod = await import("./page-registries/master__code.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/company": {
      const mod = await import("./page-registries/master__company.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/customer": {
      const mod = await import("./page-registries/master__customer.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/equip": {
      const mod = await import("./page-registries/master__equip.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/item-supplier": {
      const mod = await import("./page-registries/master__item-supplier.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/label": {
      const mod = await import("./page-registries/master__label.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/part": {
      const mod = await import("./page-registries/master__part.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/partner": {
      const mod = await import("./page-registries/master__partner.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/process": {
      const mod = await import("./page-registries/master__process.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/prod-line": {
      const mod = await import("./page-registries/master__prod-line.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/product-model": {
      const mod = await import("./page-registries/master__product-model.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/purchase-price": {
      const mod = await import("./page-registries/master__purchase-price.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/routing": {
      const mod = await import("./page-registries/master__routing.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/sale-price": {
      const mod = await import("./page-registries/master__sale-price.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/warehouse": {
      const mod = await import("./page-registries/master__warehouse.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/work-calendar": {
      const mod = await import("./page-registries/master__work-calendar.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/work-instruction": {
      const mod = await import("./page-registries/master__work-instruction.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/worker": {
      const mod = await import("./page-registries/master__worker.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/material/current-inventory": {
      const mod = await import("./page-registries/material__current-inventory.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/material/receipt-cancel": {
      const mod = await import("./page-registries/material__receipt-cancel.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/material/receipt-issue-ledger": {
      const mod = await import("./page-registries/material__receipt-issue-ledger.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/material/workstage-inventory": {
      const mod = await import("./page-registries/material__workstage-inventory.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/mold/inventory": {
      const mod = await import("./page-registries/mold__inventory.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/mold/issue": {
      const mod = await import("./page-registries/mold__issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/mold/master": {
      const mod = await import("./page-registries/mold__master.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/mold/order": {
      const mod = await import("./page-registries/mold__order.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/mold/price": {
      const mod = await import("./page-registries/mold__price.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/mold/receipt": {
      const mod = await import("./page-registries/mold__receipt.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/mold/repair": {
      const mod = await import("./page-registries/mold__repair.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/mold/repair-request": {
      const mod = await import("./page-registries/mold__repair-request.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/dashboard": {
      const mod = await import("./page-registries/oee__dashboard.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/equip-ops-analysis": {
      const mod = await import("./page-registries/oee__equip-ops-analysis.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/equip-ops-status": {
      const mod = await import("./page-registries/oee__equip-ops-status.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/equip-work-result": {
      const mod = await import("./page-registries/oee__equip-work-result.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/field-ops": {
      const mod = await import("./page-registries/oee__field-ops.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/master/equip-reason-map": {
      const mod = await import("./page-registries/oee__master__equip-reason-map.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/master/idle-reason": {
      const mod = await import("./page-registries/oee__master__idle-reason.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/master/resource": {
      const mod = await import("./page-registries/oee__master__resource.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/master/standard-time": {
      const mod = await import("./page-registries/oee__master__standard-time.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/multi-entry": {
      const mod = await import("./page-registries/oee__multi-entry.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/multi-entry-7in": {
      const mod = await import("./page-registries/oee__multi-entry-7in.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/overall-status": {
      const mod = await import("./page-registries/oee__overall-status.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/process-transaction/magazine-label": {
      const mod = await import("./page-registries/process-transaction__magazine-label.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/process-transaction/magazine-label-history": {
      const mod = await import("./page-registries/process-transaction__magazine-label-history.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/process-transaction/magazine-pid": {
      const mod = await import("./page-registries/process-transaction__magazine-pid.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/process-transaction/magazine-split": {
      const mod = await import("./page-registries/process-transaction__magazine-split.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/process-transaction/workstage-pass": {
      const mod = await import("./page-registries/process-transaction__workstage-pass.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/product/current-inventory": {
      const mod = await import("./page-registries/product__current-inventory.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/product/fg-issue": {
      const mod = await import("./page-registries/product__fg-issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/product/fg-model-issue": {
      const mod = await import("./page-registries/product__fg-model-issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/product/fg-model-receipt": {
      const mod = await import("./page-registries/product__fg-model-receipt.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/product/fg-receipt": {
      const mod = await import("./page-registries/product__fg-receipt.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/product/pack": {
      const mod = await import("./page-registries/product__pack.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/product/pack-history": {
      const mod = await import("./page-registries/product__pack-history.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/production/daily-report": {
      const mod = await import("./page-registries/production__daily-report.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/production/master-plan": {
      const mod = await import("./page-registries/production__master-plan.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/production/pcb-result": {
      const mod = await import("./page-registries/production__pcb-result.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/production/run-card": {
      const mod = await import("./page-registries/production__run-card.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/production/run-card-pid": {
      const mod = await import("./page-registries/production__run-card-pid.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/production/smd-actual": {
      const mod = await import("./page-registries/production__smd-actual.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/production/smd-plan": {
      const mod = await import("./page-registries/production__smd-plan.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/4m": {
      const mod = await import("./page-registries/quality__4m.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/eco-notify": {
      const mod = await import("./page-registries/quality__eco-notify.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/inventory-hold": {
      const mod = await import("./page-registries/quality__inventory-hold.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/iqc": {
      const mod = await import("./page-registries/quality__iqc.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/iqc-history": {
      const mod = await import("./page-registries/quality__iqc-history.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/notify": {
      const mod = await import("./page-registries/quality__notify.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/oqc-lot": {
      const mod = await import("./page-registries/quality__oqc-lot.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/oqc-pid": {
      const mod = await import("./page-registries/quality__oqc-pid.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/pid-holding": {
      const mod = await import("./page-registries/quality__pid-holding.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/pid-issue-scan": {
      const mod = await import("./page-registries/quality__pid-issue-scan.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/product-destroy": {
      const mod = await import("./page-registries/quality__product-destroy.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/repair-history": {
      const mod = await import("./page-registries/quality__repair-history.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/repair-query": {
      const mod = await import("./page-registries/quality__repair-query.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/temperature": {
      const mod = await import("./page-registries/quality__temperature.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/quality/wqc": {
      const mod = await import("./page-registries/quality__wqc.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/feeder-monitor": {
      const mod = await import("./page-registries/query__feeder-monitor.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/marking": {
      const mod = await import("./page-registries/query__marking.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/material-barcode": {
      const mod = await import("./page-registries/query__material-barcode.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/nsnp-history": {
      const mod = await import("./page-registries/query__nsnp-history.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/pcb-input": {
      const mod = await import("./page-registries/query__pcb-input.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/pda-ng": {
      const mod = await import("./page-registries/query__pda-ng.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/pda-scan": {
      const mod = await import("./page-registries/query__pda-scan.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/pid-info": {
      const mod = await import("./page-registries/query__pid-info.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/query/sensor-actual": {
      const mod = await import("./page-registries/query__sensor-actual.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/carrier-barcode": {
      const mod = await import("./page-registries/report__carrier-barcode.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/fg-issue": {
      const mod = await import("./page-registries/report__fg-issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/four-m": {
      const mod = await import("./page-registries/report__four-m.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/item-master": {
      const mod = await import("./page-registries/report__item-master.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/jig": {
      const mod = await import("./page-registries/report__jig.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/line-barcode": {
      const mod = await import("./page-registries/report__line-barcode.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/machine": {
      const mod = await import("./page-registries/report__machine.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/magazine-stock": {
      const mod = await import("./page-registries/report__magazine-stock.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/master-plan": {
      const mod = await import("./page-registries/report__master-plan.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/material-barcode-slip": {
      const mod = await import("./page-registries/report__material-barcode-slip.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/material-inventory": {
      const mod = await import("./page-registries/report__material-inventory.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/material-issue": {
      const mod = await import("./page-registries/report__material-issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/material-issue-sum": {
      const mod = await import("./page-registries/report__material-issue-sum.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/material-long-term": {
      const mod = await import("./page-registries/report__material-long-term.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/material-rack-move": {
      const mod = await import("./page-registries/report__material-rack-move.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/material-receipt": {
      const mod = await import("./page-registries/report__material-receipt.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/material-receipt-sum": {
      const mod = await import("./page-registries/report__material-receipt-sum.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/mold": {
      const mod = await import("./page-registries/report__mold.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/mold-issue": {
      const mod = await import("./page-registries/report__mold-issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/mold-receipt": {
      const mod = await import("./page-registries/report__mold-receipt.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/pickup-rate": {
      const mod = await import("./page-registries/report__pickup-rate.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/run-card": {
      const mod = await import("./page-registries/report__run-card.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/report/workstage-stock": {
      const mod = await import("./page-registries/report__workstage-stock.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/bom": {
      const mod = await import("./page-registries/smt__bom.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/bom-comparison": {
      const mod = await import("./page-registries/smt__bom-comparison.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/bom-replace": {
      const mod = await import("./page-registries/smt__bom-replace.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/bom-report": {
      const mod = await import("./page-registries/smt__bom-report.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/feeder-pickup": {
      const mod = await import("./page-registries/smt__feeder-pickup.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/line": {
      const mod = await import("./page-registries/smt__line.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/location": {
      const mod = await import("./page-registries/smt__location.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/nc-upload": {
      const mod = await import("./page-registries/smt__nc-upload.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/smt/plan": {
      const mod = await import("./page-registries/smt__plan.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/system/config": {
      const mod = await import("./page-registries/system__config.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/system/department": {
      const mod = await import("./page-registries/system__department.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/system/er-view": {
      const mod = await import("./page-registries/system__er-view.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/system/improvement-requests": {
      const mod = await import("./page-registries/system__improvement-requests.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/system/menu-categories": {
      const mod = await import("./page-registries/system__menu-categories.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/system/scheduler": {
      const mod = await import("./page-registries/system__scheduler.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/system/users": {
      const mod = await import("./page-registries/system__users.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/tracking/line-dashboard": {
      const mod = await import("./page-registries/tracking__line-dashboard.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/tracking/lot-all": {
      const mod = await import("./page-registries/tracking__lot-all.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/tracking/material-dynamic": {
      const mod = await import("./page-registries/tracking__material-dynamic.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/tracking/material-lot": {
      const mod = await import("./page-registries/tracking__material-lot.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/tracking/material-usage": {
      const mod = await import("./page-registries/tracking__material-usage.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/tracking/pid": {
      const mod = await import("./page-registries/tracking__pid.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/tracking/run-no": {
      const mod = await import("./page-registries/tracking__run-no.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/baking-scan": {
      const mod = await import("./page-registries/warehouse__baking-scan.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/baking-stock": {
      const mod = await import("./page-registries/warehouse__baking-stock.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/barcode-divide": {
      const mod = await import("./page-registries/warehouse__barcode-divide.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/barcode-issue": {
      const mod = await import("./page-registries/warehouse__barcode-issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/barcode-receipt": {
      const mod = await import("./page-registries/warehouse__barcode-receipt.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/barcode-reprint": {
      const mod = await import("./page-registries/warehouse__barcode-reprint.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/dehumi-stock": {
      const mod = await import("./page-registries/warehouse__dehumi-stock.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/etc-issue": {
      const mod = await import("./page-registries/warehouse__etc-issue.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/etc-receipt": {
      const mod = await import("./page-registries/warehouse__etc-receipt.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/issue-cancel": {
      const mod = await import("./page-registries/warehouse__issue-cancel.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/issue-return": {
      const mod = await import("./page-registries/warehouse__issue-return.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/manual-input": {
      const mod = await import("./page-registries/warehouse__manual-input.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/material-receipt": {
      const mod = await import("./page-registries/warehouse__material-receipt.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/msl-check": {
      const mod = await import("./page-registries/warehouse__msl-check.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/receipt-slip": {
      const mod = await import("./page-registries/warehouse__receipt-slip.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/recycle-check": {
      const mod = await import("./page-registries/warehouse__recycle-check.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/solder": {
      const mod = await import("./page-registries/warehouse__solder.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/solder-input": {
      const mod = await import("./page-registries/warehouse__solder-input.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/solder-label": {
      const mod = await import("./page-registries/warehouse__solder-label.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/warehouse/vacuum-stock": {
      const mod = await import("./page-registries/warehouse__vacuum-stock.generated");
      component = mod.getPageComponent();
      break;
    }
    default:
      return null;
  }
  return component;
}
