import { readFileSync } from 'node:fs';

const root = new URL('../docs/presentations/', import.meta.url);
const screens = {
  '2026-08-11-dashboard-screen-design.html': '/dashboard',
  '2026-08-11-help-screen-design.html': '/help',
  '2026-08-11-master-bom-screen-design.html': '/master/bom',
  '2026-08-11-master-code-screen-design.html': '/master/code',
  '2026-08-11-master-company-screen-design.html': '/master/company',
  '2026-08-11-master-customer-screen-design.html': '/master/customer',
  '2026-08-11-master-equip-screen-design.html': '/master/equip',
  '2026-08-11-master-item-supplier-screen-design.html': '/master/item-supplier',
  '2026-08-11-master-label-screen-design.html': '/master/label',
  '2026-08-11-master-part-screen-design.html': '/master/part',
  '2026-08-11-master-partner-screen-design.html': '/master/partner',
  '2026-08-11-master-process-screen-design.html': '/master/process',
  '2026-08-11-master-prod-line-screen-design.html': '/master/prod-line',
  '2026-08-11-master-purchase-price-screen-design.html': '/master/purchase-price',
  '2026-08-11-master-routing-screen-design.html': '/master/routing',
  '2026-08-11-master-sale-price-screen-design.html': '/master/sale-price',
  '2026-08-11-master-warehouse-screen-design.html': '/master/warehouse',
  '2026-08-11-master-work-calendar-screen-design.html': '/master/work-calendar',
  '2026-08-11-master-work-instruction-screen-design.html': '/master/work-instruction',
  '2026-08-11-master-worker-screen-design.html': '/master/worker',
  '2026-08-11-oee-dashboard-drilldown-screen-design.html': '/oee/dashboard/drilldown',
  '2026-08-11-oee-dashboard-screen-design.html': '/oee/dashboard',
  '2026-08-11-oee-entry-screen-design.html': '/oee/entry',
  '2026-08-11-oee-equip-downtime-mobile-screen-design.html': '/oee/equip-downtime-mobile',
  '2026-08-11-oee-equip-ops-analysis-screen-design.html': '/oee/equip-ops-analysis',
  '2026-08-11-oee-equip-work-result-screen-design.html': '/oee/equip-work-result',
  '2026-08-11-oee-master-equip-reason-map-screen-design.html': '/oee/master/equip-reason-map',
  '2026-08-11-oee-master-idle-reason-screen-design.html': '/oee/master/idle-reason',
  '2026-08-11-oee-master-standard-time-screen-design.html': '/oee/master/standard-time',
  '2026-08-11-system-config-screen-design.html': '/system/config',
  '2026-08-11-system-department-screen-design.html': '/system/department',
  '2026-08-11-system-er-view-screen-design.html': '/system/er-view',
  '2026-08-11-system-improvement-requests-screen-design.html': '/system/improvement-requests',
  '2026-08-11-system-menu-categories-screen-design.html': '/system/menu-categories',
  '2026-08-11-system-scheduler-screen-design.html': '/system/scheduler',
  '2026-08-11-system-users-screen-design.html': '/system/users',
};

const count = (text, pattern) => (text.match(pattern) ?? []).length;
const failures = [];

for (const [file, route] of Object.entries(screens)) {
  let html;
  try {
    html = readFileSync(new URL(file, root), 'utf8');
  } catch (error) {
    failures.push(`${file}: file missing (${error.message})`);
    continue;
  }

  const checks = [
    [html.startsWith('<!doctype html>'), 'doctype'],
    [/<meta\s+charset=["']utf-8["']\s*\/?\s*>/i.test(html), 'UTF-8 charset'],
    [html.includes(route), `route ${route}`],
    [count(html, /<section class="sheet"/g) === 3, 'exactly three sheets'],
    [count(html, /id="page-[123]"/g) === 3, 'three page IDs'],
    [count(html, /Page [123] \/ 3/g) === 3, 'three page footers'],
    [/@page\s*\{[^}]*size\s*:\s*594mm\s+420mm/is.test(html), 'explicit A2 landscape print CSS'],
    [/\.sheet\s*\{[^}]*height\s*:\s*404mm[^}]*min-height\s*:\s*404mm/is.test(html), 'A2 sheet height'],
    [html.includes('요구사항'), 'requirements section'],
    [/(와이어프레임|화면 구성|UI)/i.test(html), 'UI section'],
    [/(API|인터페이스)/i.test(html), 'API/interface section'],
    [/(소스|근거|evidence)/i.test(html), 'source evidence'],
    [/<\/body>\s*<\/html>\s*$/i.test(html), 'closing body/html'],
    [!/<link\b[^>]*rel=["']?stylesheet/i.test(html), 'no external stylesheet'],
    [!/<script\b[^>]*\bsrc=/i.test(html), 'no external script'],
  ];

  for (const [passed, name] of checks) {
    if (!passed) failures.push(`${file}: ${name}`);
  }

  for (const tag of ['section', 'article', 'table', 'tr', 'div']) {
    const opens = count(html, new RegExp(`<${tag}(?:\\s|>)`, 'gi'));
    const closes = count(html, new RegExp(`</${tag}>`, 'gi'));
    if (opens !== closes) failures.push(`${file}: unbalanced <${tag}> (${opens}/${closes})`);
  }
}

if (failures.length > 0) {
  console.error(`Screen-design validation failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}

console.log(`Validated ${Object.keys(screens).length} screen-design documents.`);
