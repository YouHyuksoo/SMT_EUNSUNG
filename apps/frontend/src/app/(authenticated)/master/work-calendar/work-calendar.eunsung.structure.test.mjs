import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const root = new URL('../../../../../', import.meta.url);
const read = (p) => fs.readFileSync(new URL(p, root), 'utf8');

test('work calendar page is fully registered', () => {
  for (const [p, r] of [
    ['src/config/menuConfig.ts', /MST_WORK_CALENDAR/],
    ['../backend/src/seeds/menu-config.json', /MST_WORK_CALENDAR/],
    ['../backend/src/modules/menu-categories/utils/menu-code-validator.ts', /MST_WORK_CALENDAR/],
    ['../backend/src/modules/menu-categories/utils/default-menu-category-layout.ts', /MST_WORK_CALENDAR/],
  ]) {
    assert.match(read(p), r);
  }
});

test('work calendar uses the IP_ calendar model, not the HANES model', () => {
  const backend = [
    '../backend/src/entities/product-company-calendar.entity.ts',
    '../backend/src/entities/product-line-calendar.entity.ts',
    '../backend/src/entities/shift-time-master.entity.ts',
  ].map(read).join('\n');

  assert.match(backend, /IP_PRODUCT_COMPANY_CALENDAR/);
  assert.match(backend, /IP_PRODUCT_LINE_CALENDAR/);
  assert.match(backend, /IP_SHIFT_TIME_MASTER/);

  // HOLIDAY_YN은 F_GET_DELIVERY_DATE가 읽으므로 유지돼야 한다.
  assert.match(backend, /HOLIDAY_YN/);

  // HANES 모델이 되살아나면 안 된다.
  for (const forbidden of ['WORK_CALENDARS', 'WORK_CALENDAR_DAYS', 'SHIFT_PATTERNS']) {
    assert.ok(!backend.includes(forbidden), `${forbidden}가 다시 등장했습니다`);
  }
});

test('work calendar frontend calls only the approved API paths', () => {
  const front = [
    'src/app/(authenticated)/master/work-calendar/page.tsx',
    'src/app/(authenticated)/master/work-calendar/components/ShiftTimeTab.tsx',
    'src/app/(authenticated)/master/work-calendar/components/DayEditModal.tsx',
    'src/app/(authenticated)/master/work-calendar/types.ts',
  ].map(read).join('\n');

  assert.match(front, /\/master\/work-calendar\/days/);
  assert.match(front, /\/master\/work-calendar\/generate/);
  assert.match(front, /\/master\/work-calendar\/copy-from-company/);
  assert.match(front, /\/master\/shift-times/);

  // 구 API/모델 잔재 금지
  assert.ok(!front.includes('/master/work-calendars'), '구 복수형 API 경로가 남아 있습니다');
  assert.ok(!front.includes('/master/shift-patterns'), '구 교대패턴 API가 남아 있습니다');
  assert.ok(!front.includes('calendarId'), 'HANES 캘린더 헤더 개념이 남아 있습니다');

  // 코드성 값은 공통코드로
  assert.match(front, /WORK_DAY_TYPE/);
  assert.match(front, /DAY_OFF_TYPE/);
});

test('day type / holiday_yn 불변식이 shared에 한 번만 정의된다', () => {
  const rules = read('../../packages/shared/src/work-calendar/work-calendar-rules.ts');
  assert.match(rules, /export function holidayYnOf/);
  assert.match(rules, /export function defaultWorkMinutes/);

  const service = read('../backend/src/modules/master/services/work-calendar.service.ts');
  assert.match(service, /holidayYnOf/);
  assert.match(service, /defaultWorkMinutes/);
  // 서비스가 자체 계산식을 다시 갖고 있으면 안 된다.
  assert.ok(!/dayType === 'OFF' \? 'Y' : 'N'/.test(service), 'HOLIDAY_YN 파생이 서비스에 복붙돼 있습니다');
});
