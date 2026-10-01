/**
 * @file src/app/components/LandingCompany.tsx
 * @description 랜딩페이지 회사소개 + 제품·생산기술 섹션
 *
 * 초보자 가이드:
 * 1. **내용 출처**: 회사 홈페이지(eunsungele.com) 메인에 게시된 문구만 사용한다.
 *    수치·공정 순서 등 홈페이지에 없는 내용은 추가하지 않는다.
 * 2. **앵커**: #company, #products (헤더 링크 대상, 고정 헤더 높이만큼 scroll-margin)
 */

import { ExternalLink } from "lucide-react";
import LandingSectionTitle from "./LandingSectionTitle";

const COMPANY_FACTS: { label: string; value: string }[] = [
  { label: "설립", value: "2010년" },
  { label: "주요 제품", value: "PCB Ass'y, Brushcard Ass'y" },
  { label: "공급", value: "현대·기아자동차 1차 협력사" },
  { label: "생산 기술", value: "SMT, Soldering, Welding" },
];

const PRODUCTS: { no: string; name: string; tag: string }[] = [
  { no: "01", name: "브러시카드 SUB ASS'Y", tag: "Brushcard" },
  { no: "02", name: "전기차 SUB 부품", tag: "EV" },
  { no: "03", name: "압력센서 SUB ASS'Y", tag: "Sensor" },
];

const TECHNOLOGIES: { name: string; full: string }[] = [
  { name: "SMT", full: "Surface Mounted Technology" },
  { name: "Soldering", full: "솔더링" },
  { name: "Welding", full: "웰딩" },
];

export default function LandingCompany() {
  return (
    <>
      {/* 회사소개 */}
      <section id="company" className="scroll-mt-16 py-20 lg:py-28 border-t border-border">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 grid lg:grid-cols-12 gap-10">
          <div className="lg:col-span-5">
            <LandingSectionTitle ko="회사소개" en="COMPANY" />
            <p className="text-text-muted leading-relaxed mb-6">
              ㈜은성전장은 2010년 설립된 회사로, 국내외 자동차에 적용되는 PCB Ass&apos;y 및
              Brushcard Ass&apos;y 제품을 생산하여 현대·기아자동차 1차 협력사에 공급하고 있습니다.
            </p>
            <a
              href="http://eunsungele.com/"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1.5 text-sm font-medium text-primary hover:underline"
            >
              회사 홈페이지
              <ExternalLink className="w-4 h-4" />
            </a>
          </div>

          <dl className="lg:col-span-6 lg:col-start-7 grid sm:grid-cols-2 border-t border-l border-border">
            {COMPANY_FACTS.map((fact) => (
              <div key={fact.label} className="p-6 border-r border-b border-border">
                <dt className="text-xs text-text-muted mb-2">{fact.label}</dt>
                <dd className="text-lg font-semibold text-text">{fact.value}</dd>
              </div>
            ))}
          </dl>
        </div>
      </section>

      {/* 제품·생산기술 */}
      <section id="products" className="scroll-mt-16 py-20 lg:py-28 bg-surface/50 border-t border-border">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <LandingSectionTitle ko="제품·생산기술" en="PRODUCTS & PRODUCTION LINES" />

          <div className="grid md:grid-cols-3 gap-4 mb-14">
            {PRODUCTS.map((product) => (
              <div key={product.no} className="p-6 rounded-lg bg-card border border-border flex flex-col gap-8">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-mono text-text-muted">{product.no}</span>
                  <span className="text-xs font-medium px-2 py-0.5 rounded bg-primary/10 text-primary">
                    {product.tag}
                  </span>
                </div>
                <h3 className="text-xl font-semibold text-text">{product.name}</h3>
              </div>
            ))}
          </div>

          <div className="grid lg:grid-cols-12 gap-6 items-start">
            <p className="lg:col-span-4 text-text-muted leading-relaxed">
              국내외 자동차 전장부품을 SMT, Soldering, Welding 기술로 생산합니다.
            </p>
            <ul className="lg:col-span-8 grid sm:grid-cols-3 gap-px bg-border border border-border rounded-lg overflow-hidden">
              {TECHNOLOGIES.map((tech) => (
                <li key={tech.name} className="bg-card p-5">
                  <div className="text-lg font-bold text-text">{tech.name}</div>
                  <div className="text-sm text-text-muted mt-1">{tech.full}</div>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </section>
    </>
  );
}
