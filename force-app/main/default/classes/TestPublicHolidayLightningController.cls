@isTest
public class TestPublicHolidayLightningController {
     static list<CC_QAppt__Public_Holidays__c> publicHolidayList;
    
    /*method to prepare dummy public holiday records*/
@testSetup
    static void prepareRecords(){
       list<CC_QAppt__Location__c> locationlist=TestdataFactory.locationList(20);
        publicHolidayList=new list<CC_QAppt__Public_Holidays__c>();
       publicHolidayList=TestdataFactory.publicHolidayList(20);
        insert locationlist;
        insert publicHolidayList;
    }
    
    /*method to test if records are availabel for editing*/
    @isTest
    static void getPublicHolidayRecordsForEditing(){
        CC_QAppt__Location__c Locationobj=[select id from CC_QAppt__Location__c limit 1 ];
        test.startTest();
        PublicHolidayLightningController.getFields();
        PublicHolidayLightningController.getPublicHolidays(Locationobj.Id);
        test.stopTest();
    }
    
    /* method to test save functionality while clicking on save button*/
     @isTest
    static void savePublicHolidays(){
         list<CC_QAppt__Public_Holidays__c> pbHolidayList=TestdataFactory.publicHolidayList(20);
    boolean result=PublicHolidayLightningController.savePublicHolidays(pbHolidayList);
        system.assert(result,'error while saving public holiday records');
    }
    
    /*method to test deletion of records*/
     @isTest
    static void deletePublicHolidays(){	
        list<Id> pbholidayList=new list<Id>();
        for(CC_QAppt__Public_Holidays__c obj:[select Id from  CC_QAppt__Public_Holidays__c limit 10]){
            pbholidayList.add(obj.id);
        }
    boolean result=PublicHolidayLightningController.deletePublicHoliday(pbholidayList);
        system.assert(result,'error while deleting public holiday records');
    }
    
}