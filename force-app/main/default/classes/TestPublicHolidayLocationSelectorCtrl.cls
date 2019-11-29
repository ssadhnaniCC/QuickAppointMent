@istest
public class TestPublicHolidayLocationSelectorCtrl {
@testSetup
    static void prepareRecords(){
       list< CC_QAppt__Location__c>  LocationList=TestdataFactory.LocationList(20);
        insert LocationList;
    }
    @isTest
    static void getLocationRecords(){
       list<CC_QAppt__Location__c> locationsList= PublicHolidayLocationSelectorController.getLocations();
        system.assertEquals(locationsList.size(),20,'error while fetching location records');
    }
}