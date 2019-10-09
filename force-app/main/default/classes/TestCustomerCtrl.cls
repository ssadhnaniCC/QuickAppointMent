@isTest 
public class TestCustomerCtrl{
    static testMethod void UnitTest() {
        contact con = new contact();
        con.lastname = 'user';
        insert con;
        
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
        
        Location__c Loc1 = new Location__c();
        Loc1.Street__c = 'street1';
        Loc1.State__c = 'state1';
        Loc1.Country__c = 'country1';
        Loc1.City__c  = 'city1';
        Loc1.Postal_Code__c = '00112233';
        Loc1.Active__c = true;
        Loc1.Coordinates__Latitude__s = 77.000000;
        Loc1.Coordinates__Longitude__s = 102.000000;
        insert Loc1;
        
        string strloc = string.valueOf(loc.id);
        string strloc1 = string.valueOf(loc1.id);
        
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
        
        system.assertEquals(ali.Service__c, newService.id);
        system.assertEquals(ali.Location__c, Loc.id);
        
        Appointment__c appObj = new Appointment__c();
        appObj.Start_Date_Time__c = System.now();
        appObj.End_Date_Time__c = system.now().addMinutes(1);
        appObj.Discount__c = 5;
        appObj.Resource_Service_Alignment__c = ali.id;
        insert appObj;
        
        
        CustomerCtrl obj = new CustomerCtrl();
        obj.CustomerId = con.id;
        obj.goToNewEditMode();
        obj.saveCustomer();
        obj.CustomerIdForAppointment = con.id;
        obj.ShowCustomerAppointment();
        obj.search();
        obj.customerAppIdForDelete = appObj.id;
        obj.DeleteCustomerAppointment();
        obj.customerIdForDelete = con.id;
        system.assertEquals(obj.customerIdForDelete, con.id);
        obj.DeleteCustomer();
        system.assertEquals([select name from contact].size(),1);
    }
    
}