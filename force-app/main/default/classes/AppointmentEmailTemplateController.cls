public class AppointmentEmailTemplateController {
    
    public String appointmentId{get;set;}
    public String appointmentName{get;set;}
    public string storeServices{get;set;}
    public datetime startDate{get;set;}
    public datetime endDate{get;set;}
    public String serviceValues{get;set;}
    public String resourceValues{get;set;}
    public set<id> serviceIds{get;set;}
    public set<id> resourceIds{get;set;}
    public List<string> serviceNameList{get;set;}
    public List<string> resourceNameList{get;set;}
    
    
    
    public List<CC_QAppt__Appointment_Detail__c> appRecord{
        get {
            List<CC_QAppt__Appointment_Detail__c> appDetails = new List<CC_QAppt__Appointment_Detail__c>();
          appRecord =  [SELECT id,CC_QAppt__Service__r.name, CC_QAppt__Appointment__r.name, CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c, CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c  FROM  CC_QAppt__Appointment_Detail__c where CC_QAppt__Appointment__c='a026D0000024fg3QAA'];
            
            appointmentName = appRecord[0].CC_QAppt__Appointment__r.name;
            startDate = appRecord[0].CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c;
            endDate = appRecord[0].CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c;
            
            return appRecord; 
        }
        set;
    }
    
    public AppointmentEmailTemplateController() {
        
       
    }
    
    public pagereference submitFeedback() {
        PageReference myVFPage = new PageReference('/apex/QuickAppointmentFeedbackForm');
        myVFPage.setRedirect(true);
        myVFPage.getParameters().put('appointmentId', appointmentId);
        return myVFPage;
    }
    
    public class AppointmentWrapper {
        public CC_QAppt__Appointment__c cqat{get;set;}
        public List<string> serviceList{get;set;}
        public List<string> resourceList{get;set;}
        
    }
    
}