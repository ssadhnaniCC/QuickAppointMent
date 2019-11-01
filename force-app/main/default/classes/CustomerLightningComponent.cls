/**
* @author Enrollment Rx
* @date OCTOBER 2019
* @description This class is used to display, edit & delete Contact records where RecordType is 'USER'. 
*/
public with sharing class CustomerLightningComponent{
    /*******************************************************************************************************
    * @description This method is used to get fields from CustomerListFieldSet .
    * @returns list of object.
    */
    @AuraEnabled
    public static list<Object> getFields(){
       return QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Contact','CC_QAppt__CustomerListFieldset');
    }
    /*******************************************************************************************************
    * @description This method is used to get Customer data from contact where RecordType is 'USER'.
    * @returns list of contact.
    */
    @AuraEnabled
    public  static List<contact> getCustomers(){
            return QuickAppointmentSOQLManager.getCustomers();
        } 
     @AuraEnabled
    public  static void saveCustomer(contact customerRecord){
        system.debug('in save Customer');
            Contact conObj=new Contact(Id=customerRecord.Id,FirstName=customerRecord.FirstName,LastName=customerRecord.LastName,Email=customerRecord.Email,Phone=customerRecord.Phone,MailingStreet=customerRecord.MailingStreet,MailingCity=customerRecord.MailingCity,MailingState=customerRecord.MailingState,MailingPostalCode=customerRecord.MailingPostalCode,MailingCountry=customerRecord.MailingCountry,Description=customerRecord.Description);
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('User').getRecordTypeId();
        conObj.RecordtypeId=recordTypeId;
        upsert conObj;
        } 
    @AuraEnabled
    public  static void deleteCustomer(Id customerId ){
        Database.delete(customerId,false);
        } 
}