/**
 * @file src/modules/master/services/label-form.service.ts
 * @description 제품별 라벨양식 관리 — 모델별 BarTender 양식(ISYS_LABEL_FORM)과 V1~V20 값 칸을 관리한다.
 *
 * 초보자 가이드:
 * 1. 한 모델에 양식번호(LABEL_FORM_NO)별로 양식이 여러 개 있다. 키는 모델명 + 양식번호 + 조직이다 (DB 에 PK 는 없다).
 * 2. LABEL_SYNTAX 에 BarTender 양식 파일(.btw), LABEL_IMAGE 에 미리보기 이미지를 BLOB 로 저장한다.
 *    양식 파일을 올리면 LABEL_FORM_NAME 을 그 파일 이름으로 바꾼다 (내려받을 때 파일 이름으로 쓴다).
 * 3. V1~V20 은 BarTender 양식의 값 칸에 넣을 항목이다. 공통코드 LABEL STEP(QTY, BARCODE …)이거나 고정 문자다.
 *    미리보기 값은 DB 함수 F_GEN_LABEL_DATA_4_BARTENDER 의 PREVIEW 모드로 만든다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import * as oracledb from 'oracledb';
import { DataSource, QueryRunner } from 'typeorm';
import { namedBinds } from '../../../common/utils/named-binds.util';
import { CopyLabelFormDto, LABEL_VALUE_KEYS, LabelFormKeyDto, LabelFormQueryDto, SaveLabelFormDto, UpdateLabelFormDto } from '../dto/label-form.dto';

type Row = Record<string, unknown>;

const VALUE_COLUMNS = LABEL_VALUE_KEYS.map((k) => k.toUpperCase());
const MAX_FILE_BYTES = 10 * 1024 * 1024;

@Injectable()
export class LabelFormService {
  constructor(private readonly dataSource: DataSource) {}

  /** 양식 목록 — BLOB 는 크기만 돌려준다 */
  findAll(query: LabelFormQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = { organizationId };
    let where = 'f.ORGANIZATION_ID = :organizationId';
    if (query.modelName?.trim()) { where += ' AND UPPER(f.MODEL_NAME) LIKE :modelName'; binds.modelName = `%${query.modelName.trim().toUpperCase()}%`; }
    return this.query(`
      SELECT f.MODEL_NAME AS "modelName", f.LABEL_FORM_NO AS "labelFormNo", f.LABEL_FORM_NAME AS "labelFormName",
             f.LABEL_FORM_TYPE AS "labelFormType", f.USE_FLAG AS "useFlag", f.COMMENTS AS "comments",
             NVL(DBMS_LOB.GETLENGTH(f.LABEL_SYNTAX), 0) AS "syntaxSize",
             NVL(DBMS_LOB.GETLENGTH(f.LABEL_IMAGE), 0) AS "imageSize",
             f.ENTER_DATE AS "enterDate", f.ENTER_BY AS "enterBy",
             f.LAST_MODIFY_DATE AS "lastModifyDate", f.LAST_MODIFY_BY AS "lastModifyBy"
        FROM ISYS_LABEL_FORM f
       WHERE ${where}
       ORDER BY f.MODEL_NAME, f.LABEL_FORM_NO`, binds);
  }

  /** 한 양식의 V1~V20 값과 미리보기 값 */
  async findValues(key: LabelFormKeyDto, organizationId: number) {
    const rows = await this.query(`
      SELECT f.LABEL_FORM_TYPE AS "labelFormType", f.COMMENTS AS "comments",
             ${VALUE_COLUMNS.map((c) => `f.${c} AS "${c.toLowerCase()}"`).join(', ')}
        FROM ISYS_LABEL_FORM f
       WHERE f.MODEL_NAME = :modelName AND f.LABEL_FORM_NO = :labelFormNo AND f.ORGANIZATION_ID = :organizationId`,
      { modelName: key.modelName, labelFormNo: key.labelFormNo, organizationId });
    const form = rows[0];
    if (!form) throw new NotFoundException('라벨 양식을 찾지 못했습니다.');

    // 값이 있는 칸만 미리보기 값을 만든다 (PB 는 20칸 모두 호출했다)
    const used = LABEL_VALUE_KEYS.filter((k) => form[k] != null && String(form[k]).trim() !== '');
    let preview: Row = {};
    if (used.length > 0) {
      const previewRows = await this.query(`
        SELECT ${used.map((k) => `F_GEN_LABEL_DATA_4_BARTENDER('', :modelName, :labelFormType, '${k.toUpperCase()}', SYSDATE, '1', 'PREVIEW', '') AS "${k}"`).join(', ')}
          FROM DUAL`, { modelName: key.modelName, labelFormType: form.labelFormType });
      preview = previewRows[0] ?? {};
    }
    return {
      comments: form.comments ?? null,
      values: LABEL_VALUE_KEYS.map((k) => ({ key: k, value: (form[k] as string | null) ?? null, preview: (preview[k] as string | null) ?? null })),
    };
  }

  async create(dto: SaveLabelFormDto, organizationId: number, userId?: string) {
    const fields = this.fields(dto);
    await this.assertNotExists(fields.modelName, fields.labelFormNo, organizationId);
    await this.query(`
      INSERT INTO ISYS_LABEL_FORM
        (MODEL_NAME, LABEL_FORM_NO, LABEL_FORM_NAME, LABEL_FORM_TYPE, USE_FLAG, COMMENTS, ${VALUE_COLUMNS.join(', ')},
         ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
      VALUES (:modelName, :labelFormNo, :labelFormName, :labelFormType, :useFlag, :comments, ${LABEL_VALUE_KEYS.map((k) => `:${k}`).join(', ')},
         :organizationId, SYSDATE, :userId, SYSDATE, :userId)`, { ...fields, organizationId, userId: userId ?? null });
    return { modelName: fields.modelName, labelFormNo: fields.labelFormNo };
  }

  async update(dto: UpdateLabelFormDto, organizationId: number, userId?: string) {
    const fields = this.fields(dto);
    const keyChanged = fields.modelName !== dto.originalModelName || fields.labelFormNo !== dto.originalLabelFormNo;
    if (keyChanged) await this.assertNotExists(fields.modelName, fields.labelFormNo, organizationId);
    const affected = await this.execute(async (runner) => this.dml(runner, `
      UPDATE ISYS_LABEL_FORM
         SET MODEL_NAME = :modelName, LABEL_FORM_NO = :labelFormNo, LABEL_FORM_NAME = :labelFormName,
             LABEL_FORM_TYPE = :labelFormType, USE_FLAG = :useFlag, COMMENTS = :comments,
             ${LABEL_VALUE_KEYS.map((k) => `${k.toUpperCase()} = :${k}`).join(', ')},
             LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
       WHERE MODEL_NAME = :originalModelName AND LABEL_FORM_NO = :originalLabelFormNo AND ORGANIZATION_ID = :organizationId`,
      { ...fields, originalModelName: dto.originalModelName, originalLabelFormNo: dto.originalLabelFormNo, organizationId, userId: userId ?? null }));
    if (affected === 0) throw new NotFoundException('수정할 라벨 양식을 찾지 못했습니다. 다시 조회한 뒤 시도하세요.');
    return { modelName: fields.modelName, labelFormNo: fields.labelFormNo };
  }

  async remove(key: LabelFormKeyDto, organizationId: number) {
    const affected = await this.execute((runner) => this.dml(runner,
      `DELETE FROM ISYS_LABEL_FORM WHERE MODEL_NAME = :modelName AND LABEL_FORM_NO = :labelFormNo AND ORGANIZATION_ID = :organizationId`,
      { modelName: key.modelName, labelFormNo: key.labelFormNo, organizationId }));
    if (affected === 0) throw new NotFoundException('삭제할 라벨 양식을 찾지 못했습니다.');
    return { modelName: key.modelName, labelFormNo: key.labelFormNo };
  }

  /** 양식 파일(.btw) 또는 미리보기 이미지를 올린다 */
  async uploadFile(key: LabelFormKeyDto, kind: 'syntax' | 'image', file: { buffer: Buffer; originalname: string }, organizationId: number, userId?: string) {
    if (!file?.buffer?.length) throw new BadRequestException('파일이 비어 있습니다.');
    if (file.buffer.length > MAX_FILE_BYTES) throw new BadRequestException('파일은 10MB 를 넘을 수 없습니다.');
    // multer 는 파일 이름을 latin1 로 넘긴다 — 한글 파일 이름을 되살린다
    const fileName = Buffer.from(file.originalname, 'latin1').toString('utf8');
    if (kind === 'syntax' && !/\.btw$/i.test(fileName)) throw new BadRequestException('BarTender 양식 파일(.btw)만 올릴 수 있습니다.');
    if (kind === 'syntax' && fileName.length > 100) throw new BadRequestException('파일 이름은 100자를 넘을 수 없습니다.');
    const column = kind === 'syntax' ? 'LABEL_SYNTAX' : 'LABEL_IMAGE';
    const affected = await this.execute((runner) => this.dml(runner, `
      UPDATE ISYS_LABEL_FORM
         SET ${column} = :content${kind === 'syntax' ? ', LABEL_FORM_NAME = :fileName' : ''},
             LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
       WHERE MODEL_NAME = :modelName AND LABEL_FORM_NO = :labelFormNo AND ORGANIZATION_ID = :organizationId`,
      {
        content: { val: file.buffer, type: oracledb.DB_TYPE_BLOB },
        ...(kind === 'syntax' ? { fileName } : {}),
        userId: userId ?? null, modelName: key.modelName, labelFormNo: key.labelFormNo, organizationId,
      }));
    if (affected === 0) throw new NotFoundException('라벨 양식을 찾지 못했습니다. 먼저 저장한 뒤 파일을 올리세요.');
    return { size: file.buffer.length, fileName };
  }

  /** 양식 파일 또는 이미지를 내려받는다 */
  async downloadFile(key: LabelFormKeyDto, kind: 'syntax' | 'image', organizationId: number) {
    const column = kind === 'syntax' ? 'LABEL_SYNTAX' : 'LABEL_IMAGE';
    const rows = await this.query(`
      SELECT ${column} AS "content", LABEL_FORM_NAME AS "labelFormName"
        FROM ISYS_LABEL_FORM
       WHERE MODEL_NAME = :modelName AND LABEL_FORM_NO = :labelFormNo AND ORGANIZATION_ID = :organizationId`,
      { modelName: key.modelName, labelFormNo: key.labelFormNo, organizationId });
    const content = rows[0]?.content;
    if (!Buffer.isBuffer(content) || content.length === 0) {
      throw new NotFoundException(kind === 'syntax' ? '저장된 양식 파일이 없습니다.' : '저장된 이미지가 없습니다.');
    }
    const fileName = kind === 'syntax'
      ? String(rows[0].labelFormName || `${key.modelName}_${key.labelFormNo}.btw`)
      : `${key.modelName}_${key.labelFormNo}${this.imageExtension(content)}`;
    return { content, fileName, contentType: kind === 'syntax' ? 'application/octet-stream' : this.imageContentType(content) };
  }

  /**
   * 고른 양식들을 다른 모델로 복사한다 (양식 파일·이미지 포함).
   * 대상 모델에 같은 양식번호가 이미 있으면 아무것도 복사하지 않는다.
   */
  async copy(dto: CopyLabelFormDto, organizationId: number, userId?: string) {
    const target = dto.targetModelName.trim();
    if (dto.sources.some((s) => s.modelName === target)) throw new BadRequestException('원본과 같은 모델로는 복사할 수 없습니다.');
    const formNos = [...new Set(dto.sources.map((s) => Number(s.labelFormNo)))];
    if (formNos.length !== dto.sources.length) throw new BadRequestException('양식번호가 같은 양식을 한 모델로 함께 복사할 수 없습니다.');
    const exists = await this.query(
      `SELECT LABEL_FORM_NO AS "labelFormNo" FROM ISYS_LABEL_FORM
        WHERE MODEL_NAME = :target AND ORGANIZATION_ID = :organizationId AND LABEL_FORM_NO IN (${formNos.map((_, i) => `:n${i}`).join(', ')})`,
      { target, organizationId, ...Object.fromEntries(formNos.map((n, i) => [`n${i}`, n])) });
    if (exists.length > 0) {
      throw new BadRequestException(`대상 모델 ${target} 에 양식번호 ${exists.map((e) => e.labelFormNo).join(', ')} 이(가) 이미 있습니다.`);
    }

    let copied = 0;
    await this.execute(async (runner) => {
      await runner.startTransaction();
      try {
        for (const source of dto.sources) {
          copied += await this.dml(runner, `
            INSERT INTO ISYS_LABEL_FORM
              (MODEL_NAME, LABEL_FORM_NO, LABEL_FORM_NAME, LABEL_FORM_TYPE, USE_FLAG, COMMENTS, ${VALUE_COLUMNS.join(', ')},
               LABEL_SYNTAX, LABEL_IMAGE, ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
            SELECT :target, LABEL_FORM_NO, LABEL_FORM_NAME, LABEL_FORM_TYPE, USE_FLAG, COMMENTS, ${VALUE_COLUMNS.join(', ')},
                   LABEL_SYNTAX, LABEL_IMAGE, ORGANIZATION_ID, SYSDATE, :userId, SYSDATE, :userId
              FROM ISYS_LABEL_FORM
             WHERE MODEL_NAME = :modelName AND LABEL_FORM_NO = :labelFormNo AND ORGANIZATION_ID = :organizationId`,
            { target, userId: userId ?? null, modelName: source.modelName, labelFormNo: source.labelFormNo, organizationId });
        }
        await runner.commitTransaction();
      } catch (error: unknown) {
        await runner.rollbackTransaction();
        throw error;
      }
      return copied;
    });
    return { copied, targetModelName: target };
  }

  private fields(dto: SaveLabelFormDto) {
    const values = dto.values ?? {};
    const unknownKeys = Object.keys(values).filter((k) => !LABEL_VALUE_KEYS.includes(k));
    if (unknownKeys.length > 0) throw new BadRequestException(`알 수 없는 값 칸: ${unknownKeys.join(', ')}`);
    const valueBinds: Record<string, string | null> = {};
    for (const k of LABEL_VALUE_KEYS) {
      const v = values[k];
      const text = v == null ? '' : String(v).trim();
      if (text.length > 50) throw new BadRequestException(`${k.toUpperCase()} 값은 50자를 넘을 수 없습니다.`);
      valueBinds[k] = text || null;
    }
    return {
      modelName: dto.modelName.trim(),
      labelFormNo: Number(dto.labelFormNo),
      labelFormName: dto.labelFormName?.trim() || null,
      labelFormType: dto.labelFormType,
      useFlag: dto.useFlag ?? null,
      comments: dto.comments?.trim() || null,
      ...valueBinds,
    };
  }

  private async assertNotExists(modelName: string, labelFormNo: number, organizationId: number) {
    const rows = await this.query(
      `SELECT COUNT(*) AS "cnt" FROM ISYS_LABEL_FORM WHERE MODEL_NAME = :modelName AND LABEL_FORM_NO = :labelFormNo AND ORGANIZATION_ID = :organizationId`,
      { modelName, labelFormNo, organizationId });
    if (Number(rows[0]?.cnt ?? 0) > 0) throw new BadRequestException(`모델 ${modelName} 에 양식번호 ${labelFormNo} 이(가) 이미 있습니다.`);
  }

  private imageExtension(content: Buffer) {
    if (content.subarray(0, 2).toString('latin1') === 'BM') return '.bmp';
    if (content.subarray(1, 4).toString('latin1') === 'PNG') return '.png';
    if (content[0] === 0xff && content[1] === 0xd8) return '.jpg';
    return '.bin';
  }

  private imageContentType(content: Buffer) {
    return ({ '.bmp': 'image/bmp', '.png': 'image/png', '.jpg': 'image/jpeg' } as Record<string, string>)[this.imageExtension(content)] ?? 'application/octet-stream';
  }

  private async query(sql: string, binds: Record<string, unknown>): Promise<Row[]> {
    try { return await this.dataSource.query(sql, namedBinds(binds)); } catch (error: unknown) { throw this.oracleError(error); }
  }

  private async dml(runner: QueryRunner, sql: string, binds: Record<string, unknown>): Promise<number> {
    const result = await runner.query(sql, namedBinds(binds), true) as { affected?: number };
    return Number(result.affected ?? 0);
  }

  private async execute(work: (runner: QueryRunner) => Promise<number>): Promise<number> {
    const runner = this.dataSource.createQueryRunner();
    try {
      await runner.connect();
      return await work(runner);
    } catch (error: unknown) {
      throw error instanceof BadRequestException || error instanceof NotFoundException ? error : this.oracleError(error);
    } finally {
      await runner.release();
    }
  }

  private oracleError(error: unknown) {
    const driver = typeof error === 'object' && error !== null && 'driverError' in error ? error.driverError : undefined;
    const driverMessage = typeof driver === 'object' && driver !== null && 'message' in driver && typeof driver.message === 'string'
      ? driver.message : undefined;
    return new BadRequestException(driverMessage ?? (error instanceof Error ? error.message : undefined) ?? '라벨 양식 처리 중 오류가 발생했습니다.');
  }
}
