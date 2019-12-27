/**
* @author Cloud Certitude
* @date NOVEMBER 2019
* @description This class is used to display working hours
*/
public class WorkingHourController {

    @AuraEnabled
    public static List<wrappedWorkingHour> getWorkingHour(string appId) {
      TimeZone tz = UserInfo.getTimeZone();
      String currentTimeZone =  tz.getID();
      List<wrappedWorkingHour> updatedWorkingHourList = new List<wrappedWorkingHour>();
      List<CC_QAppt__Working_Hour__c> workingHourList = QuickAppointmentSOQLManager.getWorkingHours(appId);
         for(CC_QAppt__Working_Hour__c workingHour : workingHourList){
            wrappedWorkingHour obj = new wrappedWorkingHour();
            obj.Active = workingHour.CC_QAppt__Active__c;
            obj.Id = workingHour.Id;
            obj.StartTime = workingHour.CC_QAppt__Start_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
            obj.EndTime =  workingHour.CC_QAppt__End_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);   
            updatedWorkingHourList.add(obj);     
        } 
        return updatedWorkingHourList;
    }
    
     @AuraEnabled
    public static list<Object> getWorkingHourFieldSet() {
        return QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Working_Hour__c','CC_QAppt__WorkingHourFieldSet');
    }
    
  
   @AuraEnabled
    public  static CC_QAppt__Working_Hour__c getWorkingHourRecord(Id workingHourId ){
        return [SELECT CC_QAppt__Start_Date__c,CC_QAppt__End_Date__c,CC_QAppt__Active__c,CC_QAppt__End_Time__c,CC_QAppt__Start_Time__c FROM CC_QAppt__Working_Hour__c where id =: workingHourId LIMIT 1];
        }     
    
    @AuraEnabled
    public static contact getResourceName(String resId) {
         return [select Id,name from contact where RecordType.Name IN ('Resource', 'Staff') And Id =: resId];
    }
    
    @AuraEnabled
    public static void saveWorkingHour(CC_QAppt__Working_Hour__c cqwh,Boolean mon,Boolean tue,Boolean wed,Boolean thur,Boolean fri,Boolean sat,Boolean isActive,String resId ) {
         system.debug('cqwh=='+cqwh);
        CC_QAppt__Working_Hour__c workingRecord = NEW CC_QAppt__Working_Hour__c();
       // workingRecord.CC_QAppt__Start_Date__c = cqwh.CC_QAppt__Start_Date__c;
      //  workingRecord.CC_QAppt__End_Date__c = cqwh.CC_QAppt__End_Date__c;
        workingRecord.CC_QAppt__Start_Time__c = cqwh.CC_QAppt__Start_Time__c;
        workingRecord.CC_QAppt__End_Time__c = cqwh.CC_QAppt__End_Time__c;
        workingRecord.CC_QAppt__IsAvailableOnMonday__c = mon;
        workingRecord.CC_QAppt__IsAvailableOnTuesday__c = tue;
        workingRecord.CC_QAppt__isAvailableOnWednesday__c = wed;
        workingRecord.CC_QAppt__IsAvailableOnThursday__c = thur;
        workingRecord.CC_QAppt__IsAvailableOnFriday__c = fri;
        workingRecord.CC_QAppt__IsAvailableOnSaturday__c = sat;
        workingRecord.CC_QAppt__Resource__c = resId;
        workingRecord.CC_QAppt__Active__c = isActive;
        
        try{
            INSERT workingRecord;
        }
        catch(Exception e) {
   //         system.debug(e);
        }
        
 //       system.debug('workingRecordId=='+workingRecord.Id);
    }
     public class wrappedWorkingHour{
        @AuraEnabled public boolean  Active;
        @AuraEnabled public String Id;
        @AuraEnabled public String ResourceName; 
        @AuraEnabled public String  StartTime;
        @AuraEnabled public String  EndTime;
    }
    
}