public class AppointmentEmailTemplateController {
    
    public String appointmentId{get;set;}
    public String appointmentName{get;set;}
    public string storeServices{get;set;}
    public datetime startDate{get;set;}
    public datetime endDate{get;set;}
    
    
    public List<CC_QAppt__Appointment_Detail__c> appRecord{
        get {
            List<CC_QAppt__Appointment_Detail__c> appDetails = new List<CC_QAppt__Appointment_Detail__c>();
            appRecord =  [SELECT id,CC_QAppt__Service__r.name,CC_QAppt__Service__c, CC_QAppt__Appointment__r.name, CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c, CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c  FROM  CC_QAppt__Appointment_Detail__c where CC_QAppt__Appointment__c=:appointmentId];
            
            appointmentName = appRecord[0].CC_QAppt__Appointment__r.name;
            startDate = appRecord[0].CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c;
            system.debug('startDate=='+startDate);
            endDate = appRecord[0].CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c;
            system.debug('endDate=='+endDate);
            storeServices = appRecord[0].CC_QAppt__Service__r.name;
            
            return appRecord; 
        }
        set;
    }
    
    public AppointmentEmailTemplateController() {
      
    }
    
    
    
}