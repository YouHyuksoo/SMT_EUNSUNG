import { Column, Entity, PrimaryColumn } from 'typeorm';
@Entity({name:'ICOM_CUSTOMER'})
export class CustomerMaster {
 @PrimaryColumn({name:'CUSTOMER_CODE',type:'varchar2',length:20}) customerCode:string;
 @PrimaryColumn({name:'ORGANIZATION_ID',type:'number'}) organizationId:number;
 @Column({name:'CUSTOMER_NAME',type:'varchar2',length:100}) customerName:string;
 @Column({name:'CUSTOMER_NAME_ENG',type:'varchar2',length:100}) customerNameEng:string;
 @Column({name:'BUSINESS_NO',type:'varchar2',length:50,nullable:true}) businessNo:string|null;
 @Column({name:'BUSINESS_TAX_NO',type:'varchar2',length:50,nullable:true}) businessTaxNo:string|null;
 @Column({name:'BUSINESS_CATEGORY',type:'varchar2',length:20,nullable:true}) businessCategory:string|null;
 @Column({name:'BUSINESS_STATUS',type:'varchar2',length:1}) businessStatus:string;
 @Column({name:'BUSINESS_TYPE',type:'varchar2',length:1}) businessType:string;
 @Column({name:'PAYMENT_TYPE',type:'varchar2',length:20}) paymentType:string;
 @Column({name:'CREDIT_GRADE',type:'varchar2',length:1}) creditGrade:string;
 @Column({name:'CUSTOMER_CHARGE_NAME',type:'varchar2',length:20,nullable:true}) customerChargeName:string|null;
 @Column({name:'OWNER_NAME',type:'varchar2',length:20,nullable:true}) ownerName:string|null;
 @Column({name:'ADDRESS',type:'varchar2',length:100}) address:string;
 @Column({name:'TEL_NO',type:'varchar2',length:40}) telNo:string;
 @Column({name:'FAX_NO',type:'varchar2',length:40,nullable:true}) faxNo:string|null;
 @Column({name:'DATESET',type:'date'}) dateset:Date;
 @Column({name:'DATEEND',type:'date'}) dateend:Date;
 @Column({name:'HANDPHONE_NO',type:'varchar2',length:40,nullable:true}) handphoneNo:string|null;
 @Column({name:'HOME_PAGE',type:'varchar2',length:100,nullable:true}) homePage:string|null;
 @Column({name:'EMAIL_ADDRESS',type:'varchar2',length:50,nullable:true}) emailAddress:string|null;
 @Column({name:'CREDIT_AMOUNT',type:'number',nullable:true}) creditAmount:number|null;
 @Column({name:'NATION_CODE',type:'varchar2',length:3,nullable:true}) nationCode:string|null;
 @Column({name:'SALE_CHARGE',type:'varchar2',length:20,nullable:true}) saleCharge:string|null;
 @Column({name:'ENTER_DATE',type:'date',nullable:true}) enterDate:Date|null;
 @Column({name:'ENTER_BY',type:'varchar2',length:20,nullable:true}) enterBy:string|null;
 @Column({name:'LAST_MODIFY_DATE',type:'date',nullable:true}) lastModifyDate:Date|null;
 @Column({name:'LAST_MODIFY_BY',type:'varchar2',length:20,nullable:true}) lastModifyBy:string|null;
}
