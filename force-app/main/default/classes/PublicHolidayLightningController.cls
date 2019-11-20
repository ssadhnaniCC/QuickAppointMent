public class PublicHolidayLightningController {
/*******************************************************************************************************
    * @description This method is used to get fields from CustomerListFieldSet .
    * @returns list of object.
    */
    @AuraEnabled
    public static list<Object> getFields(){
       return QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Public_Holidays__c','CC_QAppt__PublicHolidayFieldset');
    }
    
     @AuraEnabled
    public  static void savePublicHolidays(list<CC_QAppt__Public_Holidays__c> reclist){      
            //CC_QAppt__Public_Holidays__c Obj=new CC_QAppt__Public_Holidays__c(Name=rec.Name,CC_QAppt__Description__c=rec.CC_QAppt__Description__c,CC_QAppt__Holiday_Date__c=rec.CC_QAppt__Holiday_Date__c,CC_QAppt__Location__c=rec.CC_QAppt__Location__c);      
        upsert reclist;       
        } 
     @AuraEnabled
    public  static list<CC_QAppt__Public_Holidays__c> getPublicHolidays(Id locationId){      
            return [select Name,CC_QAppt__Description__c,CC_QAppt__Holiday_Date__c  from CC_QAppt__Public_Holidays__c where CC_QAppt__Location__c=:locationId];      
              
        } 
    @AuraEnabled
    public  static void deletePublicHoliday(list<id> recList){
        Database.delete(recList,false);
        } 
    
    public class publicHolidayWrapper{
        @AuraEnabled   public String name;
        @AuraEnabled   public String location;
        @AuraEnabled   public date holidayDate;
    }
    
}