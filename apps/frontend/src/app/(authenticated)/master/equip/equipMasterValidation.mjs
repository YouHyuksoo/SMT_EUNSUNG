/**
 * @param {{ equipCode: string, equipName: string, equipType: string }} form
 * @returns {boolean}
 */
export function hasRequiredEquipMasterFields(form) {
  return Boolean(form.equipCode.trim() && form.equipName.trim() && form.equipType);
}
