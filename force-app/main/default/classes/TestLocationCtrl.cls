@isTest 
public class TestLocationCtrl{
    static testMethod void UnitTest() {
        Location__c Loc = new Location__c();
        Loc.Street__c = 'street';
        Loc.State__c = 'state';
        Loc.Country__c = 'country';
        Loc.City__c  = 'city';
        Loc.Postal_Code__c = '00112233';
        Loc.Active__c = true;
        Loc.Coordinates__Latitude__s = 77.000000;
        LOc.Coordinates__Longitude__s = 102.000000;
        try{
           insert Loc;    
        }catch(Exception e){
            system.assertEquals(e.getMessage().contains('Please Enter Valid Address Details'),false);
        }
        
        LocationCtrl objLocation = new LocationCtrl();
        objLocation.locationId = Loc.Id;
        objLocation.goToNewEditMode();
        objLocation.cancelNewEditMode();
        objLocation.saveLocation();
        objLocation.locationIdForDelete = Loc.Id;
        objLocation.DeleteLocation();
        objLocation.Search();
    }
    
    static testMethod void UnitTest1() {
        Location__c Loc = new Location__c();
        Loc.Street__c = 'street';
        Loc.State__c = 'state';
        Loc.Country__c = 'country';
        Loc.City__c  = 'city';
        Loc.Postal_Code__c = '00112233';
        Loc.Active__c = true;
        try{
           insert Loc;    
        }catch(Exception e){
            system.assertEquals(e.getMessage().contains('Please Enter Valid Address Details'),true);
        }
        LocationCtrl objLocation = new LocationCtrl();
        objLocation.locationId = Loc.Id;
        objLocation.goToNewEditMode();
        objLocation.cancelNewEditMode();
        objLocation.saveLocation();
        objLocation.locationIdForDelete = Loc.Id;
        objLocation.Search();
        objLocation.DeleteLocation();
    }
}