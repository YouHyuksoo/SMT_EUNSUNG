import { getMetadataArgsStorage } from 'typeorm';
import { AqlAcceptanceRule } from './aql-acceptance-rule.entity';
import { AqlCodeLetterRule } from './aql-code-letter-rule.entity';
import { AqlCodeLetterSample } from './aql-code-letter-sample.entity';
import { AqlStandard } from './aql-standard.entity';

function primaryColumnNames(target: Function) {
  return getMetadataArgsStorage()
    .columns
    .filter((column) => column.target === target && column.options.primary)
    .map((column) => column.options.name);
}

describe('AQL standard entity keys', () => {
  it('uses tenant and code columns in the standard primary key', () => {
    expect(primaryColumnNames(AqlStandard)).toEqual(['ORGANIZATION_ID', 'AQL_CODE']);
  });

  it('uses inspection level and lot range start in the code-letter rule primary key', () => {
    expect(primaryColumnNames(AqlCodeLetterRule)).toEqual(['ORGANIZATION_ID', 'INSPECTION_LEVEL', 'LOT_QTY_FROM']);
  });

  it('uses code letter in the sample-size primary key', () => {
    expect(primaryColumnNames(AqlCodeLetterSample)).toEqual(['ORGANIZATION_ID', 'CODE_LETTER']);
  });

  it('uses inspection mode, code letter, and AQL value in the acceptance rule primary key', () => {
    expect(primaryColumnNames(AqlAcceptanceRule)).toEqual(['ORGANIZATION_ID', 'INSPECTION_MODE', 'CODE_LETTER', 'AQL_VALUE']);
  });
});
