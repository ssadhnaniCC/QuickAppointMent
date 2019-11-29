@isTest 
public class TestResourceStaffTimeAllocation{
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
        
        Resource_Service_Alignment__c ali = new Resource_Service_Alignment__c();
        ali.Resource_Staff__c = newCon.id;
        ali.Service__c = newService.id;
        ali.Location__c = Loc.Id;
        insert ali;
        ApexPages.currentPage().getParameters().put('id',ali.id);
        
        ResourceStaffTimeAllocation RSTAObj = new ResourceStaffTimeAllocation();
        system.assertEquals(RSTAObj.AlignmentId, ali.id);
        RSTAObj.AllocationId  = '';
        RSTAObj.goToNewEditMode();
        RSTAObj.saveAllocation();
        
         Resource_Staff_Time__c Obj = new Resource_Staff_Time__c();
         insert Obj;
        
        ResourceStaffTimeAllocation resourceTimeObj = new ResourceStaffTimeAllocation();
        resourceTimeObj.AllocationId = Obj.Id;
        resourceTimeObj.goToNewEditMode();
        resourceTimeObj.saveAllocation();

    }
 
      
}