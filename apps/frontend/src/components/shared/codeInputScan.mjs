/**
 * 구조 테스트용 — 소스에서 바인딩 이름이 패턴에 맞는 텍스트 <Input>/<input> 을 찾는다.
 *
 * 판정은 placeholder 글자가 아니라 value 에 묶인 필드 이름으로 한다.
 * 조건 없는 readOnly/disabled 칸은 조회 결과를 보여주는 표시 전용이라 뺀다.
 */
import { createRequire } from "node:module";

const ts = createRequire(import.meta.url)("typescript");

export function findInputsByBinding(src, pattern, fileName = "x.tsx") {
  const sf = ts.createSourceFile(fileName, src, ts.ScriptTarget.Latest, true, ts.ScriptKind.TSX);
  const out = [];
  const visit = (n) => {
    if ((ts.isJsxSelfClosingElement(n) || ts.isJsxOpeningElement(n)) && /^(Input|input)$/.test(n.tagName.getText())) {
      const attrs = {};
      for (const a of n.attributes.properties) if (ts.isJsxAttribute(a)) attrs[a.name.getText()] = a;
      const type = attrs.type?.initializer && ts.isStringLiteral(attrs.type.initializer) ? attrs.type.initializer.text : "text";
      const valueText = attrs.value?.initializer ? attrs.value.initializer.getText().replace(/^\{|\}$/g, "") : "";
      const bind = valueText.match(/([A-Za-z_$][\w$]*)\s*(\?\?\s*(''|""))?\s*$/)?.[1] ?? "";
      const displayOnly = ["readOnly", "disabled"].some((k) => k in attrs && (!attrs[k].initializer || attrs[k].initializer.getText() === "{true}"));
      if (/^(text|search)$/.test(type) && pattern.test(bind) && !displayOnly) {
        out.push({ bind, line: sf.getLineAndCharacterOfPosition(n.getStart()).line + 1 });
      }
    }
    ts.forEachChild(n, visit);
  };
  visit(sf);
  return out;
}
