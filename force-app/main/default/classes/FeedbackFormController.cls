public class FeedbackFormController {
    public CC_QAppt__Appointment_Feedback__c qaf {get;set;} 
    public string ratingNumber {get;set;}
    public  List<String> pickListValuesList{get;set;}
    public FeedbackFormController() {
        Id appId = ApexPages.currentPage().getParameters().get('id');
        qaf = NEW CC_QAppt__Appointment_Feedback__c();
        pickListValuesList = new List<String>();
        
		Schema.DescribeFieldResult fieldResult = CC_QAppt__Appointment_Feedback__c.CC_QAppt__Feedback_Category__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
        system.debug('pickListValuesList=='+pickListValuesList);
		
    }

    public void getRating() {
         ratingNumber = apexpages.currentPage().getParameters().get('inpval');
        system.debug('ratingNumber=='+ratingNumber);
    }
    
    public void saveFeedback() {
      system.debug('ratingNumber=='+ratingNumber);
        qaf.CC_QAppt__Rating__c = ratingNumber;
        insert qaf;
        system.debug('qafId=='+qaf.Id);
    }
    
}