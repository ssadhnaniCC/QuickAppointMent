/**
* @author Cloud Certitude
* @date NOVEMBER 2019
* @description This class is test class for ServiceLightningController
*/

@isTest
public class TestServiceLightningController {

    @testSetup static void setup() {
        
        List<CC_QAppt__Service__c> serviceList = TestDataFactory.serviceList(10);
        List<CC_QAppt__Location__c> locationList = TestDataFactory.locationList(10);
        List<Id> locationids = new List<Id>();
        
        insert serviceList;
        insert locationList;
        
        List<CC_QAppt__Location__c> locationRecord =   [select id from CC_QAppt__Location__c limit 1];
        locationids.add(locationRecord[0].Id);
        List<CC_QAppt__Service__c> serviceRecord =   [select id from CC_QAppt__Service__c limit 1];
        
        List<CC_QAppt__Location_Service__c> locationService = TestDataFactory.locationServiceAlignment(locationids,serviceRecord[0].Id); 
        insert locationService;
        
    }  
    
     /* method to test if records are showing in the datatable while component initialization*/
    @isTest
    static void fetchServiceListRecords(){
        Test.startTest();
        ServiceLightningController.ServiceWrapperData resList = ServiceLightningController.getAllServices();
        Test.stopTest();
        system.assertEquals(resList.listOfServices.size(),10,'error while fetching record on component initialization');
    }
    
    @isTest
    static void testDeleteServiceFunction(){
        
        Service__c cqas = [select id from Service__c Limit 1];
        
        Test.startTest();
        ServiceLightningController.deleteService(cqas);
        list<Service__c> resList = [select id from Service__c];
        Test.stopTest();
        
        system.assertEquals(resList.size(),9,'Record Is Not Deleted');
    }
    
    @isTest
    static void testfetchAllLocation() {
        Test.startTest();
        List<location__c> resList = ServiceLightningController.getAllLocation();
        Test.stopTest();
        system.assertEquals(resList.size(),10,'error while fetching record on component initialization');
    }
    
    @istest
    static void testSaveLocationService() {
        Service__c serviceRecord = [select id,name,CC_QAppt__Description__c,CC_QAppt__Duration__c,CC_QAppt__Price__c from Service__c limit 1];
         List<Id> locationIds = new List<Id>();
         
         List<CC_QAppt__Location_Service__c> locationserviceRecord =  [select CC_QAppt__Location__c,CC_QAppt__Service__c from CC_QAppt__Location_Service__c limit 1];
         locationids.add(locationserviceRecord[0].CC_QAppt__Location__c);
         
         Test.startTest();
         ServiceLightningController.saveServiceRecords(serviceRecord, locationIds);
         Test.stopTest();
         List<Service__c>   resList   = [select id from Service__c];
         system.assertEquals(resList.size(),10,'Resource Record Is Not Saved');
    }
    
    @istest
    static void testSelectedLocations() {
        Service__c serviceRecord = [select id from Service__c limit 1];
         
         
         Test.startTest();
       ServiceLightningController.ServiceWrapperData swd =  ServiceLightningController.getSelectedLocations(serviceRecord.id);
         Test.stopTest();
         
         
    }
    
}