@isTest 
public class TestServiceCtrl{
    static testMethod void UnitTest() {
        Service__c  newService = new Service__c ();
        newService.Name = 'My service';
        newService.Description__c = 'Service Description';
        newService.Duration__c = 5;
        newService.Padding_Time__c = 10;
        newService.Price__c = 1200;
        newService.Active__c = true;
        newService.Chargable__c = true;
        try{
            insert newService;
        }catch(Exception e){
            system.assertEquals(e.getMessage().contains('Please Enter Price'),false);
        }
        
        ServiceCtrl objService = new ServiceCtrl();
        objService.BussinessId = newService.id;
        objService.goToNewEditMode();
        objService.saveBussiness();
        objService.ServiceIdForDelete = newService.id;
        objService.DeleteBussiness();
        objService.search();
    }
    static testMethod void UnitTest1() {
        Location__c Loc = new Location__c();
        Loc.Street__c = 'street';
        Loc.State__c = 'state';
        Loc.Country__c = 'country';
        Loc.City__c  = 'city';
        Loc.Postal_Code__c = '00112233';
        Loc.Active__c = true;
        Loc.Coordinates__Latitude__s = 77.000000;
        Loc.Coordinates__Longitude__s = 102.000000;
        insert Loc;
        
        
        Service__c  newService = new Service__c ();
        newService.Name = 'My service';
        newService.Description__c = 'Service Description';
        newService.Duration__c = 5;
        newService.Padding_Time__c = 10;
        newService.Active__c = true;
        newService.Price__c = 0.00;
        newService.Chargable__c = true;
        
        
        try{
            insert newService;
        }catch(Exception e){
            system.assertEquals(e.getMessage().contains('Please Enter Price'),true);
        }
        
        ServiceCtrl objService = new ServiceCtrl();
        objService.BussinessId = newService.id;
        objService.goToNewEditMode();
        objService.saveBussiness();
        objService.ServiceIdForDelete = newService.id;
        objService.DeleteBussiness();
        objService.search();
    }
}