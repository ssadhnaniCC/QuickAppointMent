public class AppointmentCategoryLightningController {
/*******************************************************************************************************
    * @description This method is used to get fields from CustomerListFieldSet .
    * @returns list of object.
    */
    @AuraEnabled
    public static list<Object> getFields(){
       return QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Appointment_Category__c','CC_QAppt__category_Fieldset');
    }
    /*******************************************************************************************************
    * @description This method is used to get Customer data from contact where RecordType is 'USER'.
    * @returns list of contact.
    */
    @AuraEnabled
    public  static List<CC_QAppt__Appointment_Category__c> getAppointmentCategories(Id appointmentId){
            return QuickAppointmentSOQLManager.getAppointmentCategories(appointmentId);
        } 
     @AuraEnabled
    public  static void saveCategory(CC_QAppt__Appointment_Category__c rec){      
            CC_QAppt__Appointment_Category__c Obj=new CC_QAppt__Appointment_Category__c(Name=rec.Name,Id=rec.Id,CC_QAppt__IsAssetMandatory__c=rec.CC_QAppt__IsAssetMandatory__c,	CC_QAppt__IsAttendeeMandatory__c=rec.CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsAvaliablePublically__c=rec.CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsLocationMandatory__c=rec.CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsMultipleAsset__c=rec.CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsMultipleAttendee__c=rec.CC_QAppt__IsMultipleAttendee__c,CC_QAppt__IsMultipleLocation__c=rec.CC_QAppt__IsMultipleLocation__c,	CC_QAppt__IsMultipleResource__c=rec.CC_QAppt__IsMultipleResource__c,	CC_QAppt__IsMultipleService__c=rec.CC_QAppt__IsMultipleService__c,CC_QAppt__IsPricingApplicable__c=rec.CC_QAppt__IsPricingApplicable__c,CC_QAppt__IsResourceMandatory__c=rec.CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsServiceMandatory__c=rec.CC_QAppt__IsServiceMandatory__c);      
        upsert Obj;       
        } 
    @AuraEnabled
    public  static void deleteCustomer(Id Id ){
        Database.delete(Id,false);
        } 
}