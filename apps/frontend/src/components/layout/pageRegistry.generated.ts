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
    case "/dashboard": {
      const mod = await import("./page-registries/dashboard.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/help": {
      const mod = await import("./page-registries/help.generated");
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
    case "/master/equip": {
      const mod = await import("./page-registries/master__equip.generated");
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
    case "/master/process-capa": {
      const mod = await import("./page-registries/master__process-capa.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/prod-line": {
      const mod = await import("./page-registries/master__prod-line.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/master/routing": {
      const mod = await import("./page-registries/master__routing.generated");
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
    case "/oee/dashboard": {
      const mod = await import("./page-registries/oee__dashboard.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/dashboard/drilldown": {
      const mod = await import("./page-registries/oee__dashboard__drilldown.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/dashboard/loss": {
      const mod = await import("./page-registries/oee__dashboard__loss.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/entry": {
      const mod = await import("./page-registries/oee__entry.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/master/reason": {
      const mod = await import("./page-registries/oee__master__reason.generated");
      component = mod.getPageComponent();
      break;
    }
    case "/oee/master/resource": {
      const mod = await import("./page-registries/oee__master__resource.generated");
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
    default:
      return null;
  }
  return component;
}
