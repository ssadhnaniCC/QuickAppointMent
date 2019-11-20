/**
* @author Cloud Certitude
* @date NOVEMBER 2019
* @description This class is test class for WorkingHourController
*/

@isTest
public class TestWorkingHourController {
  @testSetup static void setup() {
        List<contact> resourceList = TestDataFactory.resourceList(10);
        List<CC_QAppt__Location__c> locationList = TestDataFactory.locationList(10);
        List<CC_QAppt__Service__c> serviceList = TestDataFactory.serviceList(10);
        List<CC_QAppt__Working_Hour__c> workHourList = TestDataFactory.workingHourList(10);
        List<Id> locationids = new List<Id>();
        List<Id> serviceids = new List<Id>();
      
        insert resourceList;
        insert locationList;
        insert serviceList;
        
        
        List<CC_QAppt__Location__c> locationRecord =   [select id from CC_QAppt__Location__c limit 1];
        List<CC_QAppt__Service__c> serviceRecord =   [select id from CC_QAppt__Service__c limit 1];
        List<contact> resourceRecord =   [select id from contact limit 1];
        locationids.add(locationRecord[0].Id);
        serviceids.add(serviceRecord[0].Id);
        
        List<CC_QAppt__Location_Service__c> locationService = TestDataFactory.locationServiceAlignment(locationids,serviceRecord[0].Id); 
        insert locationService;
        
        List<CC_QAppt__Resource_Service_Alignment__c> resourceServiceAlignment = TestDataFactory.resourceServiceAlignment(locationids,serviceids,resourceRecord[0].Id); 
        insert resourceServiceAlignment;
    }  
    
    /* method to test if records are showing in the datatable while component initialization*/
    @isTest
    static void testWorkingHourListRecords(){
        Contact resourceRecordId = [select id from contact limit 1];
        Test.startTest();
        List<CC_QAppt__Working_Hour__c> workList = WorkingHourController.getWorkingHour(resourceRecordId.id);
        Test.stopTest();
        system.assertEquals(workList.size(),10,'error while fetching record on component initialization');
    }
    
}