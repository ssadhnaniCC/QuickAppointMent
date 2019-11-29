@isTest
public class TestLocationLightningController {
    @testSetup static void setup() {
     List<CC_QAppt__Location__c> locationList = TestDataFactory.locationList(10);
     insert locationList;
    }
   
    /* method to test if records are showing in the datatable while component initialization*/
    @isTest
    static void fetchLocationListRecords(){
        Test.startTest();
        list<CC_QAppt__Location__c> loclist = LocationLightningControler.getLocation();
        Test.stopTest();
        system.assertEquals(loclist.size(),10,'error while fetching record on component initialization');
    }
   /* method to fetch Field Set data to set dynamic colums of table*/
    @isTest
    static void fetchLocationFieldSet(){
      Test.startTest();
        List<Object> fieldSet = LocationLightningControler.getLocationFieldSet();
        Test.stopTest(); 
    }
    
   
   /* test method for Deleting record for Location */
    @isTest
    static void deleteLocationRecord(){
        List<CC_QAppt__Location__c> locationRecord = [select id from CC_QAppt__Location__c limit 1];   
         Test.startTest();
         LocationLightningControler.deleteLocation(locationRecord[0].Id);
         Test.stopTest();
         List<CC_QAppt__Location__c>   locList   = [select id from CC_QAppt__Location__c];
         system.assertEquals(locList.size(),9,'Location Record Is Not Saved');
    }
     /* test method for Save record for Location */
    @isTest
    static void saveLocationRecord(){
        List<CC_QAppt__Location__c> locationRecord = [select name,CC_QAppt__City__c,CC_QAppt__Country__c,CC_QAppt__Postal_Code__c,CC_QAppt__State__c,CC_QAppt__Street__c from CC_QAppt__Location__c limit 1];   
         Test.startTest();
         LocationLightningControler.saveLocation(locationRecord[0]);
         Test.stopTest();
         List<CC_QAppt__Location__c>   locList   = [select id from CC_QAppt__Location__c];
        system.debug('locListSize'+locList.size());
         system.assertEquals(locList.size(),10,'Location Record Is Not Saved');
    }
    


    
}