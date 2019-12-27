@isTest
public class TestNewEditAppointmentController {
   @testSetup static void setup() {
       List<CC_QAppt__Appointment_Category__c> appointmentCategoryList = TestDataFactory.AppointmentCategoryList(1);
       List<contact> resourceList = TestDataFactory.resourceList(10);
       List<contact> customerList = TestDataFactory.customerList(10);
       List<CC_QAppt__Location__c> locationList = TestDataFactory.locationList(10);
       List<CC_QAppt__Service__c> serviceList = TestDataFactory.serviceList(10); 
       List<CC_QAppt__Asset__c> assetsList = TestDataFactory.createAssets(10);
       List<Id> locationids = new List<Id>();
       List<Id> serviceids = new List<Id>();   
       
       insert resourceList;
       insert appointmentCategoryList;
       insert locationList;
       insert serviceList;
       insert customerList;
       insert assetsList;
       
       List<CC_QAppt__Location__c> locationRecord =   [select id from CC_QAppt__Location__c limit 1];
       List<CC_QAppt__Service__c> serviceRecord =   [select id from CC_QAppt__Service__c limit 1];
       List<contact> resourceRecord =   [select id from contact limit 1];
       locationids.add(locationRecord[0].Id);
       serviceids.add(serviceRecord[0].Id);
       
       List<CC_QAppt__Location_Service__c> locationService = TestDataFactory.locationServiceAlignment(locationids,serviceRecord[0].Id); 
       insert locationService;
       
       List<CC_QAppt__Resource_Service_Alignment__c> resourceServiceAlignment = TestDataFactory.resourceServiceAlignment(locationids,serviceids,resourceRecord[0].Id); 
       insert resourceServiceAlignment;
       
       List<CC_QAppt__Appointment__c> upcomingAppointments = TestDataFactory.createAppointment(resourceServiceAlignment[0].Id,appointmentCategoryList[0].Id,'Upcoming');
       insert upcomingAppointments;
       List<CC_QAppt__Participant__c> participantList = TestDataFactory.createAppointmentParticipant(upcomingAppointments[0].Id,customerList[0].Id,1);
       insert participantList;
       CC_QAppt__Appointment_Detail__c appdetails = TestDataFactory.createAppointmentDetails(upcomingAppointments[0].Id,locationService[0].Id,resourceList[0].Id);
       CC_QAppt__Appointment_Detail__c appdetailsWithoutResource = TestDataFactory.createAppointmentDetails(upcomingAppointments[0].Id,locationService[0].Id,null);
      
       List<CC_QAppt__Working_Hour__c> workingHour = TestDataFactory.workingHourList(1);
       insert workingHour;
       List<CC_QAppt__Public_Holidays__c> pubholiday = TestDataFactory.publicHolidayList(1);
       insert pubholiday;
       
       insert appdetails;
       insert appdetailsWithoutResource;  
   }
    /* method to test AppointmentCategories are fetched properly */
    @isTest
    static void fetchAppointmentCategories(){
      Test.startTest();
      List<CC_QAppt__Appointment_Category__c> appcategories   = NewEditAppointmentController.getAppointmentCategory(false);
      Test.stopTest();
      system.assertEquals(appcategories.size(), 1, 'error fetching appointmentcategories');  
    }
    
    /* method to test dependent service based on location are fetched properly */
    @isTest
    static void fetchDependentServices(){
      List<CC_QAppt__Location_Service__c>  locationservice = [select id,CC_QAppt__location__c from CC_QAppt__Location_Service__c limit 1];
      List<Id> locationids = new List<Id>();  
      locationids.add(locationservice[0].CC_QAppt__location__c);   
      Test.startTest();
      List<CC_QAppt__Location_Service__c> locationservices = NewEditAppointmentController.getDependentServices(locationids);
      Test.stopTest();
      system.assertEquals(locationservices.size(), 1, 'error fetching services');  
    }
 
    /* method to test location are fetched properly */
    @isTest
    static void fetchlocations(){
      Test.startTest();
      List<CC_QAppt__Location__c> locations = NewEditAppointmentController.getLocations();
      Test.stopTest();
      system.assertEquals(locations.size(), 10, 'error fetching locations');  
    }
    
    /* method to test services are fetched properly */
    @isTest
    static void fetchServices(){
      Test.startTest();
      List<CC_QAppt__Service__c> services = NewEditAppointmentController.getServices();
      Test.stopTest();
      system.assertEquals(services.size(), 10, 'error fetching services');  
    }

    /* method to test resourceservices are fetched properly */
    @isTest
    static void fetchResources(){
      Test.startTest();
      Map<Id,CC_QAppt__Resource_Service_Alignment__c> resourceservices = NewEditAppointmentController.getResources();
      Test.stopTest();
  //    system.assertEquals(resourceservices.size(), 1, 'error fetching services');  
    }
    
   /* method to test resourceservices are fetched based on services properly */
    @isTest
    static void fetchdependentResourcesBasedOnServices(){
        List<CC_QAppt__Resource_Service_Alignment__c> resourceService = [select CC_QAppt__Service__c from CC_QAppt__Resource_Service_Alignment__c limit 1];
        List<Id> serviceIds = new List<Id>();
        serviceIds.add(resourceService[0].CC_QAppt__Service__c);
        Test.startTest();
        Map<Id,CC_QAppt__Resource_Service_Alignment__c> resourceservices = NewEditAppointmentController.getResourceBasedOnService(serviceIds); 
        Test.stopTest();
        //system.assertEquals(resourceservices.size(), 1, 'error fetching services');  
    }
    
    /* method to test resourceservices are fetched based on location properly */
       @isTest
     static void fetchdependentResourcesBasedOnlocation(){
        List<CC_QAppt__Resource_Service_Alignment__c> resourceService = [select CC_QAppt__location__c from CC_QAppt__Resource_Service_Alignment__c limit 1];
        List<Id> locationIds = new List<Id>();
        locationIds.add(resourceService[0].CC_QAppt__location__c);
        Test.startTest();
        Map<Id,CC_QAppt__Resource_Service_Alignment__c> resourceservices = NewEditAppointmentController.getResourceBasedOnLocation(locationIds); 
        Test.stopTest();
        system.assertEquals(resourceservices!=null, true, 'error fetching resourceservices');  
    }
    
     /* method to test customers are fetched properly */
       @isTest
      static void fetchCustomers(){
        Test.startTest();
        List<Contact> customerList = NewEditAppointmentController.getCustomers(); 
        Test.stopTest();
        system.assertEquals(customerList.size(), 10, 'error fetching customers');  
    }
    
    /* method to test Assets are fetched properly */
    @isTest
      static void fetchAssets(){
        Test.startTest();
        List<CC_QAppt__Asset__c> assetList = NewEditAppointmentController.getAsset(); 
        Test.stopTest();
        system.assertEquals(assetList.size(), 10, 'error fetching assets');  
    }
   
    /* method to test Customer are searched properly */
    @isTest
      static void searchCustomer(){
        Test.startTest();
        List<contact> customer = NewEditAppointmentController.searchCustomer('first0'); 
        Test.stopTest();
        system.assertEquals(customer.size(), 1 ,'error fetching assets');  
    }
    
    /*method to test Edit Appointment Form data is loaded currectly*/
       @isTest
    static void checkEditAppointment(){
       List<CC_QAppt__Appointment__c> appointment = [select Id from CC_QAppt__Appointment__c];
       Test.startTest();
       NewEditAppointmentController.WrappAppointmentEditForm wrappEdit = NewEditAppointmentController.editAppointment(appointment[0].Id);
       Test.stopTest();
       system.assertEquals(wrappEdit!=null, true ,'no wrapper obejct');  
    }
    
    /*method to test appointment is booked correctly*/
    @isTest
    static void checkCreateAppointment(){
       Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Resource').getRecordTypeId();
       List<contact> conList =  [select id from contact where RecordtypeId =:recordTypeId limit 1];
       
       Id recordTypeIdCustomer = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('User').getRecordTypeId();
       List<contact> customerList =  [select id from contact where RecordtypeId =:recordTypeIdCustomer limit 1];
        
       List<CC_QAppt__Appointment__c> appointment = [select id from CC_QAppt__Appointment__c limit 1];
        
       List<CC_QAppt__Asset__c> assetList = [select id from CC_QAppt__Asset__c limit 1];
       List<CC_QAppt__Location_Service__c> locService = [select id from CC_QAppt__Location_Service__c limit 1]; 
       List<CC_QAppt__Location__c> location = [select id from CC_QAppt__Location__c limit 1]; 
       List<CC_QAppt__Service__c> service = [select id from CC_QAppt__Service__c limit 1]; 
       List<CC_QAppt__Appointment_Category__c> appointment_category = [select id from CC_QAppt__Appointment_Category__c limit 1]; 
       
        List<String> ResourceIds = new List<String>();
        List<String> assetIds = new List<String>();
        List<String> locationIds = new List<String>(); 
        List<String> serviceIds = new List<String>(); 
        String locationService = locService[0].Id; 
        String startDate = Datetime.now().format('yyyy-MM-dd');
        DateTime dt=System.now();
        String dtStr=dt.format('HH:mm'); 
        
       Id appcategory = appointment_category[0].Id; 
       assetIds.add(assetList[0].Id); 
       ResourceIds.add(conList[0].Id);
       locationIds.add(location[0].Id);
       serviceIds.add(service[0].Id); 
       
       List<NewEditAppointmentController.wrappedPriceList> wrapplist = new List<NewEditAppointmentController.wrappedPriceList>();  
       NewEditAppointmentController.wrappedPriceList wrappobj = new NewEditAppointmentController.wrappedPriceList(); 
       wrappobj.ListType = 'Asset';
       wrappobj.Name = 'Asset2';
       wrappobj.Price=566;
       wrappobj.TotalPrice=1600 ;
       wrapplist.add(wrappobj);

       Test.startTest();
        
      NewEditAppointmentController.createAppointment(appointment[0].Id,'AppName',ResourceIds,assetIds,locationService,
                                                     locationIds,serviceIds,'Upcoming',startDate,
                                                     dtStr,60,'Description',566,appcategory,customerList,wrapplist);
       Test.stopTest();
     List<CC_QAppt__Appointment__c> appobj    =  [select id,name from CC_QAppt__Appointment__c where id=:appointment[0].Id];
      system.assertEquals(appobj[0].Name,'AppName','no wrapper obejct');  
    }
    
   /*method to test fields are fetched properly*/
    @isTest
    static void checkfieldSetFetchedProperly(){
        Test.startTest();
        list<Object> fieldsfetch = NewEditAppointmentController.getFields();
        Test.stopTest();
        system.assertEquals(fieldsfetch.size()!=0,true,'Unable to fetch Fields');
    }
    /*method to test appointment status  are fetched properly*/
    @isTest
    static void checkAppointmentStatusFetchedProperly(){
        Test.startTest();
       List<String> statusOfAppointment = NewEditAppointmentController.fetchStatusOfAppointment();
        Test.stopTest();
        system.assertEquals(statusOfAppointment.size()!=0,true,'Unable to fetch status');
    } 
    
    
    
}