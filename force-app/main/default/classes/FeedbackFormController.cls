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
        system.debug('pickListValuesList=='+pickListValuesList);
        
        showForm = true;
        
        
    }
    
    
    
    /* Method to save feedback record */
    public PageReference saveFeedback() {
        system.debug('name=='+qaf.Name);
        system.debug('comment=='+qaf.CC_QAppt__Comments__c);
        system.debug('ratingNumber=='+ratingNumber);
        system.debug('category=='+category);
        if(!string.isEmpty(ratingNumber))
            qaf.CC_QAppt__Rating__c = ratingNumber;
        
        qaf.CC_QAppt__Appointment__c = appointmentId;
        
        if(!string.isEmpty(category))
            qaf.CC_QAppt__Feedback_Category__c = category;
        
        try{
            UPSERT qaf;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Feedback submit successfully')); 
            
            
        }
        catch(Exception e) {
            system.debug(e);
        }
        
        
        system.debug('qafId=='+qaf.Id);
        if(qaf.Id!=null) {
            showForm = false;
            showSuccess = true;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'shivam0611.cloud@gmail.com' };
                message.subject = 'Quick Appointment Feedback Form';
            message.plainTextBody = 'Thanks for Submitting feedback form';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
        return null;
    }
    
}