/**
* @author Cloud Certitude
* @date NOVEMBER 2019
* @description This class is for getting feedback from user
*/

public class FeedbackFormController {
    
    public CC_QAppt__Appointment_Feedback__c qaf {get;set;} 
    public string ratingNumber {get;set;}
    public string category {get;set;}
   
    public boolean showForm {get;set;}
    public boolean showSuccess {get;set;}
    
    public Id appointmentId {get;set;}
    public List<String> pickListValuesList{get;set;}
    
    /*Initialise method (Constructor) */
    public FeedbackFormController() {
        
        appointmentId = ApexPages.currentPage().getParameters().get('id');
        qaf = NEW CC_QAppt__Appointment_Feedback__c();
        pickListValuesList = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = CC_QAppt__Appointment_Feedback__c.CC_QAppt__Feedback_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        
        
        showForm = true;
        
        
    }
    
    
    
    /* Method to save feedback record */
    public PageReference saveFeedback() {
       
       
       
        if(!string.isEmpty(ratingNumber))
            qaf.CC_QAppt__Rating__c = ratingNumber;
        
        qaf.CC_QAppt__Appointment__c = appointmentId;
        
        if(!string.isEmpty(category))
            qaf.CC_QAppt__Feedback_Category__c = category;
        
        try{
            INSERT qaf;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Feedback submit successfully')); 
            
            
        }
        catch(Exception e) {
            system.debug(e);
        }
        
        List<CC_QAppt__Participant__c> fetchContactEMail = [select id, CC_QAppt__Participant_Name__r.email from CC_QAppt__Participant__c WHERE CC_QAppt__Appointment__c=:appointmentId Limit 1];
        
        if(qaf.Id!=null) {
            showForm = false;
            showSuccess = true;
            if(fetchContactEMail.size()>0 && fetchContactEMail[0].CC_QAppt__Participant_Name__r.email!=null) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { fetchContactEMail[0].CC_QAppt__Participant_Name__r.email };
                message.subject = 'Quick Appointment Feedback Form';
            message.plainTextBody = 'Thanks for Submitting feedback form';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } 
            else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        } 
        }
            
        return null;
            
    }
    
}