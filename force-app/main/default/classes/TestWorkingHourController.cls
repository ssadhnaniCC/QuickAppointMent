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
        insert workHourList;
        
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
        system.debug('resourceRecordId'+resourceRecordId);
        Test.startTest();
        WorkingHourController.getWorkingHourFieldSet();
        List<WorkingHourController.wrappedWorkingHour> workList = WorkingHourController.getWorkingHour(resourceRecordId.id);
        Test.stopTest();
        system.assertEquals(workList.size(),10,'error while fetching record on component initialization');
    }
    
    @isTest
    static void testGetWorkingHourRecord(){
        
        CC_QAppt__Working_Hour__c cqas = [select id from CC_QAppt__Working_Hour__c Limit 1];
        
        Test.startTest();
       CC_QAppt__Working_Hour__c cqw =  WorkingHourController.getWorkingHourRecord(cqas.id);
                Test.stopTest();
        
        system.assert(!string.isEmpty(cqw.id));
    }
    
    @isTest
    static void testGetResourceName(){
        
        Contact resourceRecordId = [select id from contact limit 1];
        Test.startTest();
       contact con =  WorkingHourController.getResourceName(resourceRecordId.id);
                Test.stopTest();
        
        system.assert(!string.isEmpty(con.id));
        
    }
    
    @isTest
    static void testSaveWorkingHourRecord(){
        
        Contact resourceRecordId = [select id from contact limit 1];
        CC_QAppt__Working_Hour__c cqas = [select id,CC_QAppt__Start_Date__c,CC_QAppt__End_Date__c,CC_QAppt__Active__c,CC_QAppt__End_Time__c,CC_QAppt__Start_Time__c from CC_QAppt__Working_Hour__c Limit 1];
        cqas.CC_QAppt__Start_Date__c = Date.newInstance(2019, 9, 9);
        cqas.CC_QAppt__End_Date__c = Date.newInstance(2019, 10, 9);
        cqas.CC_QAppt__Start_Time__c = datetime.newInstance(2019, 9, 9);
        cqas.CC_QAppt__End_Time__c = datetime.newInstance(2019, 10, 9);
        
        Boolean monday = false;
        Boolean tuesday = false;
        Boolean wednesday = false;
        Boolean thursday = false;
        Boolean friday = true;
        Boolean saturday = false;
        Boolean isActive = true;
        
        Test.startTest();
        WorkingHourController.saveWorkingHour(cqas, monday,tuesday, wednesday,thursday, friday, saturday,isActive, resourceRecordId.Id);
                Test.stopTest();
        
         
        
    }
    
    
    
}