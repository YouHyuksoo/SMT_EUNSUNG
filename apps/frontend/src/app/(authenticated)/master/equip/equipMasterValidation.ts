interface EquipMasterRequiredFields {
  equipCode: string;
  equipName: string;
  equipType: string;
}

export function hasRequiredEquipMasterFields(form: EquipMasterRequiredFields): boolean {
  return Boolean(form.equipCode.trim() && form.equipName.trim() && form.equipType);
}
