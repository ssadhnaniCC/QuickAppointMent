@isTest 
public class TestResourceStaffUsersCtrl{
    static testMethod void UnitTest() {
    
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
        
        contact newCon = new contact();
        newCon.lastname= 'Jams Smith';
        newCon.Capacity__c = 0;
        newCon.Languages__c = 'English';
        newCon.Location__c = Loc.id;
        newCon.Capacity__c = 10;
        insert newCon;
        
        Service__c  newService = new Service__c ();
        newService.Name = 'My service';
        newService.Description__c = 'Service Description';
        newService.Duration__c = 5;
        newService.Padding_Time__c = 10;
        newService.Price__c = 1200;
        newService.Active__c = true;
        newService.Chargable__c = true;
        
        insert newService;
        
        Location_Service__c newLocSer = new Location_Service__c();
        newLocSer.service__c = newService.id;
        newLocSer.location__c = Loc.id;
        insert newLocSer;
        
        Resource_Service_Alignment__c ali = new Resource_Service_Alignment__c();
        ali.Resource_Staff__c = newCon.id;
        ali.Service__c = newService.id;
        ali.Location__c = Loc.Id;
        insert ali;
        system.assertEquals(ali.Service__c, newService.id);
        system.assertEquals(ali.Location__c, Loc.id);
        ResourceStaffUsersCtrl objRSU = new ResourceStaffUsersCtrl();
        objRSU.contactId = newCon.id;
        objRSU.goToNewEditMode();
        objRSU.deletedId = ali.id;
        //objRSU.getType();
        objRSU.ResourceStaffUsers();
        objRSU.ConIdForAlignemnt = newCon.id;
        objRSU.ShowAlignemtn();
        objRSU.alignmentId = ali.id;
        //objRSU.AddNewAlignment();
        objRSU.getActiveLocation();
        objRSU.getActiveService();
        objRSU.getServiceBasedOnLocation();
        objRSU.contactIdForDelete  = newCon.id;
        objRSU.DeleteResourceStaffUsers();
        objRSU.search();
    }
}