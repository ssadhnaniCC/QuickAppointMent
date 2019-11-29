@isTest 
public class TestAppointmentCtrl{
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
        newCon.location__c = strloc  +';'+strloc1+';'; 
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
        
        Participant__c parObj = new Participant__c ();
        parObj.Appointment__c = appObj.id;
        parObj.Participant_Name__c = newCon.id;
        insert parObj;
        
        Appointment__c appObj1 = new Appointment__c();
        appObj1.Start_Date_Time__c = System.now();
        appObj1.End_Date_Time__c = system.now().addMinutes(1);
        insert appObj1;
        
        ApexPages.currentPage().getParameters().put('id', appObj.id+','+appObj1.id);
        AppointmentCtrl obj = new AppointmentCtrl();
        obj.SelectedApppointmentId = appObj.id;
        obj.SelectedAppointment();
        obj.selectedLocation = Loc.id;        
        obj.fetchServiceBasedOnLocation();
        obj.selectedService = newService.id;
        obj.fetchProviderBasedOnService();
        obj.getLocationList();
        obj.getServiceList();
        obj.getServiceDuration();
        obj.getProviderList();
        obj.selectedProvider = newCon.id;
        obj.getPriceBasedOnService();
        obj.getTotalPrice();
        obj.startTime = '10:00:AM';
        obj.startDate = '2015-10-07';
        obj.saveAppointment();
        obj.fetchParticipant();
        obj.addParticipant();
        obj.search();
        obj.removeParticipant();
        
        obj.cloneExistingRecord(); 
        obj.saveCustomer();     
    }
    
    
    static testMethod void TestSaveAppointment() {
        
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
           
        AppointmentCtrl app = new AppointmentCtrl();
        app.selectedLocation = Loc.Id;
        
        app.saveAppointment();
        
    }
    
    static testMethod void TestSaveAppointmentForNoLocation() {
        
        Service__c  newService = new Service__c ();
        newService.Name = 'My service';
        newService.Description__c = 'Service Description';
         
        newService.Duration__c = 5;
        newService.Padding_Time__c = 10;
        newService.Price__c = 1200;
        newService.Active__c = true;
        newService.Chargable__c = true;
        
        insert newService;
           
        AppointmentCtrl app = new AppointmentCtrl();
        app.selectedService = newService.Id;
        
        app.saveAppointment();
        
    }
    
     static testMethod void TestSaveAppointmentForNoProvider() {
        
        Service__c  newService = new Service__c ();
        newService.Name = 'My service';
        newService.Description__c = 'Service Description';
         
        newService.Duration__c = 5;
        newService.Padding_Time__c = 10;
        newService.Price__c = 1200;
        newService.Active__c = true;
        newService.Chargable__c = true;
        
        insert newService;
         
         
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
           
        AppointmentCtrl app = new AppointmentCtrl();
        app.selectedService = newService.Id;
        app.selectedLocation = Loc.Id;
        app.saveAppointment();
        
    }
    
    static testMethod void TestSaveAppointmentForNoStartTime() {
        
        Service__c  newService = new Service__c ();
        newService.Name = 'My service';
        newService.Description__c = 'Service Description';
         
        newService.Duration__c = 5;
        newService.Padding_Time__c = 10;
        newService.Price__c = 1200;
        newService.Active__c = true;
        newService.Chargable__c = true;
        
        insert newService;
         
         
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
           
        AppointmentCtrl app = new AppointmentCtrl();
        app.selectedService = newService.Id;
        app.selectedLocation = Loc.Id;
        app.selectedProvider = newCon.Id;
        app.saveAppointment();
        
    }
    
    static testMethod void TestSaveAppointmentForNoEndTime() {
        
        Service__c  newService = new Service__c ();
        newService.Name = 'My service';
        newService.Description__c = 'Service Description';
         
        newService.Duration__c = 5;
        newService.Padding_Time__c = 10;
        newService.Price__c = 1200;
        newService.Active__c = true;
        newService.Chargable__c = true;
        
        insert newService;
         
         
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
           
        AppointmentCtrl app = new AppointmentCtrl();
        app.selectedService = newService.Id;
        app.selectedLocation = Loc.Id;
        app.selectedProvider = newCon.Id;
        app.startDate = '2015-10-07';
        app.fromCloneButton = true;
        app.checkDobuleBooking = false;
        app.saveAppointment();
        
    }
    
    
    
}