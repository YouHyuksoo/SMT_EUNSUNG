import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";

const componentPath = path.resolve("apps/frontend/src/components/shared/BarcodeScanInput.tsx");

test("BarcodeScanInput centralizes scanner input behavior", () => {
  assert.ok(fs.existsSync(componentPath), "BarcodeScanInput.tsx should exist");

  const source = fs.readFileSync(componentPath, "utf8");

  assert.match(source, /forwardRef<HTMLInputElement/);
  assert.match(source, /useScanInputFocus/);
  assert.match(source, /useSerialStore/);
  assert.match(source, /onScan:\s*\(value:\s*string\)\s*=>\s*(?:void|Promise<void>)/);
  assert.match(source, /replace\(\s*\/\\r\?\\n\|\\r\/g/);
  assert.match(source, /event\.key === ["']Enter["']/);
  assert.match(source, /autoClear/);
  assert.match(source, /serialEnabled/);
  assert.match(source, /refocusAfterScan\?:\s*boolean/);
  assert.match(source, /refocusAfterScan = true/);
});

test("BarcodeScanInput shows a visible blinking scan cue by default", () => {
  const source = fs.readFileSync(componentPath, "utf8");

  assert.match(source, /blinkIndicator\?:\s*boolean/);
  assert.match(source, /blinkIndicator = true/);
  assert.match(source, /animate-pulse/);
  assert.match(source, /ring-primary\/20/);
  assert.match(source, /text-primary/);
});

test("BarcodeScanInput accepts both manual key-in Enter and connected serial scans", () => {
  const source = fs.readFileSync(componentPath, "utf8");

  assert.match(source, /onChange=\{handleChange\}/);
  assert.match(source, /onKeyDown=\{handleKeyDown\}/);
  assert.match(source, /submitValue\(event\.currentTarget\.value\)/);
  assert.match(source, /subscribeSerialScan\(\(rawValue\) =>/);
  assert.match(source, /submitValue\(rawValue\)/);
});

test("known scanner inputs use BarcodeScanInput instead of local Enter handlers", () => {
  const scannerFiles = [
    "apps/frontend/src/app/(authenticated)/material/issue/components/IssueScanPanel.tsx",
    "apps/frontend/src/app/(authenticated)/material/lot-merge/page.tsx",
    "apps/frontend/src/app/(authenticated)/product/receive/components/ReceivablePanel.tsx",
    "apps/frontend/src/app/(authenticated)/shipping/pack/page.tsx",
    "apps/frontend/src/app/(authenticated)/shipping/pallet-ship/page.tsx",
    "apps/frontend/src/app/(authenticated)/shipping/pallet/page.tsx",
    "apps/frontend/src/components/consumables/BarcodeScanPanel.tsx",
    "apps/frontend/src/components/consumables/IssueScanPanel.tsx",
    "apps/frontend/src/components/material/BarcodeScanTab.tsx",
    "apps/frontend/src/components/material/IqcModal.tsx",
    "apps/frontend/src/components/shipping/BoxScanShipModal.tsx",
    "apps/frontend/src/components/shipping/ShipmentScanModal.tsx",
    "apps/frontend/src/components/worker/WorkerSelectModal.tsx",
    "apps/frontend/src/components/worker/WorkerSelector.tsx",
  ];

  for (const file of scannerFiles) {
    const source = fs.readFileSync(path.resolve(file), "utf8");
    assert.match(source, /<BarcodeScanInput\b/, `${file} should render BarcodeScanInput`);
    assert.doesNotMatch(source, /leftIcon=\{<Scan(?:Line|Barcode|\b)/, `${file} should not wire scan icons through raw Input`);
    assert.doesNotMatch(source, /onKeyDown=\{[^}]*Enter/, `${file} should not keep local Enter scan handlers`);
  }
});
