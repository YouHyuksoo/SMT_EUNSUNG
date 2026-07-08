import { getMetadataArgsStorage } from 'typeorm';
import { DepartmentMaster } from './department-master.entity';
import { IsysOrganization } from './isys-organization.entity';
import { IsysUser } from './isys-user.entity';
import { ComCode } from './com-code.entity';
import { SysConfig } from './sys-config.entity';
import { ItemMaster } from './item-master.entity';

function tableName(target: Function) {
  return getMetadataArgsStorage().tables.find((table) => table.target === target)?.name;
}

function columnName(target: Function, propertyName: string) {
  return getMetadataArgsStorage().columns.find(
    (column) => column.target === target && column.propertyName === propertyName,
  )?.options.name;
}

describe('ISYS master table mappings', () => {
  it('maps /master/company to ISYS_ORGANIZATION', () => {
    expect(tableName(IsysOrganization)).toBe('ISYS_ORGANIZATION');
    expect(columnName(IsysOrganization, 'organizationId')).toBe('ORGANIZATION_ID');
    expect(columnName(IsysOrganization, 'companyCode')).toBe('COMPANY_CODE');
  });

  it('maps /system/department to ISYS_DEPARTMENT', () => {
    expect(tableName(DepartmentMaster)).toBe('ISYS_DEPARTMENT');
    expect(columnName(DepartmentMaster, 'deptCode')).toBe('DEPARTMENT_CODE');
    expect(columnName(DepartmentMaster, 'deptName')).toBe('DEPARTMENT_NAME_KOR');
  });

  it('maps /system/users to ISYS_USERS', () => {
    expect(tableName(IsysUser)).toBe('ISYS_USERS');
    expect(columnName(IsysUser, 'userId')).toBe('USER_ID');
    expect(columnName(IsysUser, 'emailAddress')).toBe('EMAIL_ADDRESS');
  });

  it('maps /master/code to ISYS_BASECODE', () => {
    expect(tableName(ComCode)).toBe('ISYS_BASECODE');
    expect(columnName(ComCode, 'groupCode')).toBe('CODE_TYPE');
    expect(columnName(ComCode, 'detailCode')).toBe('CODE_NAME');
  });

  it('maps /system/config to ISYS_CONFIG', () => {
    expect(tableName(SysConfig)).toBe('ISYS_CONFIG');
    expect(columnName(SysConfig, 'configKey')).toBe('CONFIG_NAME');
    expect(columnName(SysConfig, 'configValue')).toBe('CONFIG_VALUE');
    expect(columnName(SysConfig, 'isActive')).toBe('USE_YN');
  });

  it('maps /master/parts to ID_ITEM', () => {
    expect(tableName(ItemMaster)).toBe('ID_ITEM');
    expect(columnName(ItemMaster, 'itemCode')).toBe('ITEM_CODE');
    expect(columnName(ItemMaster, 'itemName')).toBe('ITEM_NAME');
    expect(columnName(ItemMaster, 'spec')).toBe('ITEM_SPEC');
  });
});
