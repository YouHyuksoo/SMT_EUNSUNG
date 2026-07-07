"use strict";
/**
 * @file packages/shared/src/types/index.ts
 * @description 공유 타입 정의 모음
 *
 * 초보자 가이드:
 * 1. **사용법**: import { JobOrder, MatLot } from '@smt/shared/types'
 * 2. **구조**: 도메인별로 파일 분리 (master, production, material 등)
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __exportStar = (this && this.__exportStar) || function(m, exports) {
    for (var p in m) if (p !== "default" && !Object.prototype.hasOwnProperty.call(exports, p)) __createBinding(exports, m, p);
};
Object.defineProperty(exports, "__esModule", { value: true });
// API 관련 타입
__exportStar(require("./api"), exports);
// Enum 타입
__exportStar(require("./enums"), exports);
// 공통코드 타입
__exportStar(require("./com-code"), exports);
// 추적성 타입
__exportStar(require("./traceability"), exports);
// 기준정보 타입
__exportStar(require("./master"), exports);
// 생산 관련 타입
__exportStar(require("./production"), exports);
// 자재/재고 관련 타입
__exportStar(require("./material"), exports);
// 품질 관련 타입
__exportStar(require("./quality"), exports);
// 출하 관련 타입
__exportStar(require("./shipping"), exports);
