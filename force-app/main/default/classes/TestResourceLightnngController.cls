@isTest
public class TestResourceLightnngController {
    @testSetup static void setup() {
        List<contact> resourceList = TestDataFactory.resourceList(10);
        List<CC_QAppt__Location__c> locationList = TestDataFactory.locationList(10);
        List<CC_QAppt__Service__c> serviceList = TestDataFactory.serviceList(10);
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
    static void fetchResourceListRecords(){
        Test.startTest();
        list<contact> resList = ResourceLightningController.getAllResources();
        Test.stopTest();
        system.assertEquals(resList.size(),10,'error while fetching record on component initialization');
    }
    
    /* method to test if delete of resource record is working properly */
    @isTest
    static void deleteResourceRecord(){
        Contact resourceRecord = [select id from contact limit 1];
        Test.startTest();
        ResourceLightningController.deleteResourceStaff(resourceRecord.Id);
        list<contact> resList = [select id,lastname from contact];
        Test.stopTest();
        system.assertEquals(resList.size(),9,'Record Is Not Deleted');
    }
    
    /* method to test If Resource Record is saved successfully*/
    @isTest
    static void saveResourceRecord(){
         Contact resourceRecord = [select id,name,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,description from contact limit 1];
         List<Id> locationIds = new List<Id>();
         List<Id> serviceIds = new List<Id>();
         List<CC_QAppt__Location_Service__c> locationserviceRecord =  [select CC_QAppt__Location__c,CC_QAppt__Service__c from CC_QAppt__Location_Service__c limit 1];
         locationids.add(locationserviceRecord[0].CC_QAppt__Location__c);
         serviceIds.add(locationserviceRecord[0].CC_QAppt__Service__c);
         Test.startTest();
         ResourceLightningController.saveNewResources(resourceRecord, locationIds, serviceIds);
         Test.stopTest();
         List<contact>   resList   = [select id from contact];
         system.assertEquals(resList.size(),10,'Resource Record Is Not Saved');
    }
    
    /* method to fetch Resource Record for Editing*/
    @isTest
    static void editResourceRecord(){
      List<contact>   resourceRecord   = [select id from contact limit 1];
      Test.startTest();
      ResourceLightningController.ResourceServiceWrapper wrapperResource = ResourceLightningController.getResourcesOnEdit(resourceRecord[0].Id);
      Test.stopTest(); 
    }
    
    /* method to fetch Available Location List*/
    @isTest
    static void fetchAvailableLocationList(){
      Test.startTest();
        List<CC_QAppt__Location__c> locationList = ResourceLightningController.getAllAvailableLocation();
        Test.stopTest(); 
        System.assertEquals(locationList.size(),10 ,'Unable to fetch Location');
    }
    /* method to fetch Field Set data to set dynamic colums of table*/
    @isTest
    static void fetchResourceFieldSet(){
      Test.startTest();
        List<Object> fieldSet = ResourceLightningController.getResourceFieldSet();
        Test.stopTest(); 
       // System.assertEquals(locationList.size(),10 ,'Unable to fetch Location');
    }

}