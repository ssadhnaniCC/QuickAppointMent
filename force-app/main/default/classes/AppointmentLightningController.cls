/**
* @author Cloud Certitude
* @date NOVEMBER 2019
* @description This class is used to fetchRelatedAppointments from ResourceStaff And Customer'
*/
public class AppointmentLightningController {
    
   /*******************************************************************************************************
    * @description This is the method which returns related appointments for ResourceStaff/Customer.
   * @returns Returns List of Contact resources on PageLoad.
   */
    @AuraEnabled
    public static List<AppointmentWrapper> relatedAppointment(String recordId){
        List<AppointmentWrapper> appWrapp = new List<AppointmentWrapper>();
        List<CC_QAppt__Appointment__c> relatedAppointments = new List<CC_QAppt__Appointment__c>();
        List<contact> customerList = new List<contact>();  
        //Get User Time Zone
        TimeZone tz = UserInfo.getTimeZone();
        String currentTimeZone =  tz.getID();
        
         // Get Recordtype name for knowing whether record is of resourcestaff or customer
        List<contact> con = [SELECT RecordType.Name,RecordType.DeveloperName FROM contact where Id =: recordId];
        String recordTypeName = con[0].RecordType.Name;
  
        if(recordTypeName == 'Resource'){
            relatedAppointments = QuickAppointmentSOQLManager.getPreviousAppointments('contact',recordId);
        }
        if(recordTypeName == 'User'){
            customerList = QuickAppointmentSOQLManager.getCustomers(recordId);
            relatedAppointments = QuickAppointmentSOQLManager.getPreviousAppointmentsForCustomers(recordId);
        }
        for(CC_QAppt__Appointment__c applist : relatedAppointments){
            AppointmentWrapper obj = new AppointmentWrapper();
            obj.Name = applist.Name;
            obj.Location = applist.CC_QAppt__Resource_Service_Alignment__r.CC_QAppt__Location__r.CC_QAppt__Street__c;
            obj.Service = applist.CC_QAppt__Resource_Service_Alignment__r.CC_QAppt__Service__r.Name;
            if(recordTypeName == 'Resource'){
            obj.ResourceStaffOrCustomer =  applist.CC_QAppt__Resource_Service_Alignment__r.CC_QAppt__Resource_Staff__r.Name ;
            }
            if(recordTypeName == 'User'){
            obj.ResourceStaffOrCustomer = customerList[0].Name;
            }
            obj.ResourceStaff =  applist.CC_QAppt__Resource_Service_Alignment__r.CC_QAppt__Resource_Staff__r.Name ;   
            obj.StartDate =  applist.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy HH:mm:ss',currentTimeZone);
            obj.EndDate =  applist.CC_QAppt__End_Date_Time__c.format('MM/dd/yyyy HH:mm:ss',currentTimeZone);
            obj.Status = applist.CC_QAppt__Status__c;
            appWrapp.add(obj);
        }
        return appWrapp;
    }
    public class AppointmentWrapper{
        @AuraEnabled   public String Name;
        @AuraEnabled   public String Location;
        @AuraEnabled   public String Service;
        @AuraEnabled   public String ResourceStaff;
        @AuraEnabled   public String ResourceStaffOrCustomer;
        @AuraEnabled   public String StartDate;
        @AuraEnabled   public String EndDate;
        @AuraEnabled   public String Status;
        
    }
    
}