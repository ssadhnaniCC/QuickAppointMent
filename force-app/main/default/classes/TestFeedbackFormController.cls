/**
* @author Cloud Certitude
* @date NOVEMBER 2019
* @description This class is test class for WorkingHourController
*/

@isTest
public class TestFeedbackFormController {

    @isTest
    static void testSaveFeedbackForm(){
        contact newCon = new contact();
        newCon.lastname= 'Jams Smith';
        newCon.Email = 'Test@gmail.com';
        insert newCon;
        
        Appointment__c appObj = new Appointment__c();
        appObj.name = 'test';
        insert appObj;
        
        CC_QAppt__Participant__c cqp = New CC_QAppt__Participant__c();
        cqp.CC_QAppt__Appointment__c = appObj.id;
        cqp.CC_QAppt__Participant_Name__c = newCon.Id;
        Insert cqp;
        
        Id appId = ApexPages.currentPage().getParameters().put('id',appObj.Id);
        
        CC_QAppt__Appointment_Feedback__c cqaf = New CC_QAppt__Appointment_Feedback__c();
        cqaf.Name = 'TestFeedack';
        cqaf.CC_QAppt__Comments__c = 'TestComments';
        cqaf.CC_QAppt__Appointment__c = appObj.Id;
        
        FeedbackFormController feeForm = new FeedbackFormController();
       
        feeForm.ratingNumber = '2';
        feeForm.category = 'Suggestion';
        feeForm.saveFeedback();
        system.assert(!string.isEmpty(appObj.Id));
    }
}