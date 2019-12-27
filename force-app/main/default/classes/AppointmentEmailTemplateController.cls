public class AppointmentEmailTemplateController {
    
    public String appointmentId{get;set;}
    public String appointmentName{get;set;}
    public string storeServices{get;set;}
    public string location{get;set;}
    public datetime startDate{get;set;}
    public datetime endDate{get;set;}
    
    
    public List<CC_QAppt__Appointment_Detail__c> appRecord{
        get {
            List<CC_QAppt__Appointment_Detail__c> appDetails = new List<CC_QAppt__Appointment_Detail__c>();
            appRecord =  [SELECT id, CC_QAppt__Appointment__r.name,CC_QAppt__LocationService__r.CC_QAppt__Service__r.Name,CC_QAppt__LocationService__r.CC_QAppt__location__r.CC_QAppt__Street__c,CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c, CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c  FROM  CC_QAppt__Appointment_Detail__c where CC_QAppt__Appointment__c=:appointmentId];
            appointmentName = appRecord[0].CC_QAppt__Appointment__r.name;
            startDate = appRecord[0].CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c;
            endDate = appRecord[0].CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c;
            storeServices = appRecord[0].CC_QAppt__LocationService__r.CC_QAppt__Service__r.Name;
            location = appRecord[0].CC_QAppt__LocationService__r.CC_QAppt__location__r.CC_QAppt__Street__c;
            return appRecord; 
        }
        set;
    }
    
    public AppointmentEmailTemplateController() {
      //  system.debug('###@@@'+appRecord);
    }
    
    
    
}