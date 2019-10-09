@isTest 
public class TestDeleteRelatedRecords{
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
        
        Service__c  newService = new Service__c ();
        newService.Name = 'My service';
        newService.Description__c = 'Service Description';
        newService.Duration__c = 5;
        
        newService.Price__c = 1200;
        insert newService;
        
        contact newCon = new contact();
        newCon.lastname= 'Jams Smith';       
        insert newCon;
        
        Location_Service__c LocSer = new Location_Service__c();
        LocSer.Location__c = Loc.Id;
        LocSer.Service__c =  newService.Id;
        insert LocSer;
        
        Resource_Service_Alignment__c alignment = new Resource_Service_Alignment__c();
        alignment.location__c = loc.id;
        alignment.service__c = newService.id;
        alignment.Resource_Staff__c = newCon.id;
        insert alignment;
        
        Appointment__c app = new Appointment__c();
        app.Resource_Service_Alignment__c = alignment.id;
        app.Name = 'app';
        insert app;
        
        delete loc;
        delete newService;
        delete newCon;
    }
}