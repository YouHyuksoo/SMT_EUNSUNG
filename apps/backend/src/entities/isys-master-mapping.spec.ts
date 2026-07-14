import { getMetadataArgsStorage } from 'typeorm';
import { DepartmentMaster } from './department-master.entity';
import { IsysOrganization } from './isys-organization.entity';
import { IsysUser } from './isys-user.entity';
import { ComCode } from './com-code.entity';
import { SysConfig } from './sys-config.entity';
import { ItemMaster } from './item-master.entity';
import { SchedulerJob } from './scheduler-job.entity';
import { SchedulerLog } from './scheduler-log.entity';
import { SchedulerNotification } from './scheduler-notification.entity';
import { EquipMaster } from './equip-master.entity';
import { ItemSupplier } from './item-supplier.entity';
import { CustomerMaster } from './customer-master.entity';

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

  it('maps /master/item-suppliers to IM_ITEM_MASTER', () => {
    expect(tableName(ItemSupplier)).toBe('IM_ITEM_MASTER');
    expect(columnName(ItemSupplier, 'supplierCode')).toBe('SUPPLIER_CODE');
    expect(columnName(ItemSupplier, 'itemCode')).toBe('ITEM_CODE');
    expect(columnName(ItemSupplier, 'orderType')).toBe('ORDER_TYPE');
    expect(columnName(ItemSupplier, 'inspectRule')).toBe('INSPECT_RULE');
  });

  it('maps /master/customer to ICOM_CUSTOMER', () => {
    expect(tableName(CustomerMaster)).toBe('ICOM_CUSTOMER');
    expect(columnName(CustomerMaster, 'customerCode')).toBe('CUSTOMER_CODE');
    expect(columnName(CustomerMaster, 'businessStatus')).toBe('BUSINESS_STATUS');
    expect(columnName(CustomerMaster, 'paymentType')).toBe('PAYMENT_TYPE');
  });

  it('maps /master/equip to IMCN_MACHINE', () => {
    expect(tableName(EquipMaster)).toBe('IMCN_MACHINE');
    expect(columnName(EquipMaster, 'equipCode')).toBe('MACHINE_CODE');
    expect(columnName(EquipMaster, 'equipName')).toBe('MACHINE_NAME');
    expect(columnName(EquipMaster, 'equipType')).toBe('MACHINE_TYPE');
    expect(columnName(EquipMaster, 'lineCode')).toBe('LINE_CODE');
    expect(columnName(EquipMaster, 'processCode')).toBe('WORKSTAGE_CODE');
    expect(columnName(EquipMaster, 'port')).toBe('PORT_NO');
  });

  it('maps /system/scheduler to ISYS scheduler tables', () => {
    expect(tableName(SchedulerJob)).toBe('ISYS_SCHEDULER_JOBS');
    expect(tableName(SchedulerLog)).toBe('ISYS_SCHEDULER_LOGS');
    expect(tableName(SchedulerNotification)).toBe('ISYS_SCHEDULER_NOTIFICATIONS');
    expect(columnName(SchedulerJob, 'organizationId')).toBe('ORGANIZATION_ID');
    expect(columnName(SchedulerJob, 'jobCode')).toBe('JOB_CODE');
    expect(columnName(SchedulerLog, 'logId')).toBe('LOG_ID');
    expect(columnName(SchedulerNotification, 'notiId')).toBe('NOTI_ID');
  });
});
