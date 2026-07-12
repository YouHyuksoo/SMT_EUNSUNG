import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const read = (name) => readFileSync(new URL(name, import.meta.url), 'utf8');

function mappings(source) {
  return [...source.matchAll(/@(PrimaryColumn|Column|CreateDateColumn|UpdateDateColumn)\(\{([^}]*)\}\)\s*(\w+)!?:/g)]
    .map(([, decorator, options, property]) => ({ decorator, options, property }));
}

function assertEntity(source, table, expected) {
  assert.match(source, new RegExp(`@Entity\\(\\{ name: '${table}' \\}\\)`));
  const actual = mappings(source);
  assert.deepEqual(actual.map(({ property }) => property), Object.keys(expected));

  for (const mapping of actual) {
    const spec = expected[mapping.property];
    assert.equal(mapping.decorator, spec.decorator, `${mapping.property} decorator`);
    for (const token of spec.options) {
      assert.match(mapping.options, new RegExp(token), `${mapping.property} missing ${token}`);
    }
  }
}

function indexes(source) {
  return [...source.matchAll(/@Index\(([^\n]+)\)/g)].map(([, definition]) => definition);
}

const audit = {
  createdBy: { decorator: 'Column', options: ["name: 'CREATED_BY'", "type: 'varchar2'", 'length: 50', 'nullable: true'] },
  createdAt: { decorator: 'CreateDateColumn', options: ["name: 'CREATED_AT'", "type: 'timestamp'", 'precision: 6', "default: \\(\\) => 'SYSTIMESTAMP'", 'nullable: false'] },
  updatedBy: { decorator: 'Column', options: ["name: 'UPDATED_BY'", "type: 'varchar2'", 'length: 50', 'nullable: true'] },
  updatedAt: { decorator: 'UpdateDateColumn', options: ["name: 'UPDATED_AT'", "type: 'timestamp'", 'precision: 6', "default: \\(\\) => 'SYSTIMESTAMP'", 'nullable: false'] },
};

test('IP routing entities exactly map the live Oracle schema', () => {
  const group = read('./routing-group.entity.ts');
  assertEntity(group, 'IP_ROUTING_GROUPS', {
    organizationId: { decorator: 'PrimaryColumn', options: ["name: 'ORGANIZATION_ID'", "type: 'number'", 'nullable: false'] },
    routingCode: { decorator: 'PrimaryColumn', options: ["name: 'ROUTING_CODE'", "type: 'varchar2'", 'length: 50', 'nullable: false'] },
    itemCode: { decorator: 'Column', options: ["name: 'ITEM_CODE'", "type: 'varchar2'", 'length: 20', 'nullable: false'] },
    routingName: { decorator: 'Column', options: ["name: 'ROUTING_NAME'", "type: 'varchar2'", 'length: 200', 'nullable: false'] },
    description: { decorator: 'Column', options: ["name: 'DESCRIPTION'", "type: 'varchar2'", 'length: 500', 'nullable: true'] },
    useYn: { decorator: 'Column', options: ["name: 'USE_YN'", "type: 'varchar2'", 'length: 1', "default: 'Y'", 'nullable: false'] },
    ...audit,
  });
  assert.deepEqual(indexes(group), []);

  const process = read('./routing-process.entity.ts');
  assertEntity(process, 'IP_ROUTING_PROCESSES', {
    organizationId: { decorator: 'PrimaryColumn', options: ["name: 'ORGANIZATION_ID'", "type: 'number'", 'nullable: false'] },
    routingCode: { decorator: 'PrimaryColumn', options: ["name: 'ROUTING_CODE'", "type: 'varchar2'", 'length: 50', 'nullable: false'] },
    processSeq: { decorator: 'PrimaryColumn', options: ["name: 'PROCESS_SEQ'", "type: 'number'", 'precision: 10', 'nullable: false'] },
    workstageCode: { decorator: 'Column', options: ["name: 'WORKSTAGE_CODE'", "type: 'varchar2'", 'length: 10', 'nullable: false'] },
    executionType: { decorator: 'Column', options: ["name: 'EXECUTION_TYPE'", "type: 'varchar2'", 'length: 20', "default: 'INTERNAL'", 'nullable: false'] },
    jobOrderYn: { decorator: 'Column', options: ["name: 'JOB_ORDER_YN'", "type: 'varchar2'", 'length: 1', "default: 'Y'", 'nullable: false'] },
    subconSupplierCode: { decorator: 'Column', options: ["name: 'SUBCON_SUPPLIER_CODE'", "type: 'varchar2'", 'length: 20', 'nullable: true'] },
    standardTime: { decorator: 'Column', options: ["name: 'STANDARD_TIME'", "type: 'number'", 'precision: 10', 'scale: 4', 'nullable: true'] },
    setupTime: { decorator: 'Column', options: ["name: 'SETUP_TIME'", "type: 'number'", 'precision: 10', 'scale: 4', 'nullable: true'] },
    useYn: { decorator: 'Column', options: ["name: 'USE_YN'", "type: 'varchar2'", 'length: 1', "default: 'Y'", 'nullable: false'] },
    ...audit,
  });
  assert.deepEqual(indexes(process), []);

  const material = read('./routing-material.entity.ts');
  assertEntity(material, 'IP_ROUTING_MATERIALS', {
    organizationId: { decorator: 'PrimaryColumn', options: ["name: 'ORGANIZATION_ID'", "type: 'number'", 'nullable: false'] },
    routingCode: { decorator: 'PrimaryColumn', options: ["name: 'ROUTING_CODE'", "type: 'varchar2'", 'length: 50', 'nullable: false'] },
    processSeq: { decorator: 'PrimaryColumn', options: ["name: 'PROCESS_SEQ'", "type: 'number'", 'precision: 10', 'nullable: false'] },
    childItemCode: { decorator: 'PrimaryColumn', options: ["name: 'CHILD_ITEM_CODE'", "type: 'varchar2'", 'length: 20', 'nullable: false'] },
    allocQty: { decorator: 'Column', options: ["name: 'ALLOC_QTY'", "type: 'number'", 'precision: 18', 'scale: 6', 'nullable: false'] },
    issueMethod: { decorator: 'Column', options: ["name: 'ISSUE_METHOD'", "type: 'varchar2'", 'length: 20', "default: 'BACKFLUSH'", 'nullable: false'] },
    ...audit,
  });
  assert.deepEqual(indexes(material), ["'UK_IP_RM_CHILD', ['organizationId', 'routingCode', 'childItemCode'], { unique: true }"]);
});

test('retired routing fields stay out of the new entities', () => {
  const source = [read('./routing-process.entity.ts'), read('./routing-material.entity.ts')].join('\n');
  assert.doesNotMatch(source, /PROCESS_NAME|QC_SELF_YN|SAMPLE_INSPECT_YN|ISSUE_LABEL_TYPE|CIRCUIT_ID/);
});
