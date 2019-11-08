/**
* @author Cloud Certitude
* @date NOVEMBER 2019
* @description This class is for getting feedback from user
*/

public class FeedbackFormController {
    
    public CC_QAppt__Appointment_Feedback__c qaf {get;set;} 
    public string ratingNumber {get;set;}
    public string category {get;set;}
    public Id appointmentId {get;set;}
    public  List<String> pickListValuesList{get;set;}
    
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
        
    }
    
    
    /* Method for getting rating from UI */
    public void getRating() {
        
        ratingNumber = apexpages.currentPage().getParameters().get('inpval');
        system.debug('ratingNumber=='+ratingNumber);
        
    }
    
    /* Method for getting category from UI */
    public void getCategory() {
        
        category = apexpages.currentPage().getParameters().get('categoryValue');
        system.debug('category=='+category);
        
    }
    
    /* Method to save feedback record */
    public PageReference saveFeedback() {
        
        system.debug('ratingNumber=='+ratingNumber);
        
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
       return null;
    }
    
}