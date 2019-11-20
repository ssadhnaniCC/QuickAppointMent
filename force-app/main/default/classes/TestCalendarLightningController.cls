@isTest
public class TestCalendarLightningController {
   @testSetup static void setup() {
        List<contact> resourceList = TestDataFactory.resourceList(10);
        List<contact> customerList = TestDataFactory.customerList(10);
        List<CC_QAppt__Location__c> locationList = TestDataFactory.locationList(10);
        List<CC_QAppt__Service__c> serviceList = TestDataFactory.serviceList(10);
        
        List<Id> locationids = new List<Id>();
        List<Id> serviceids = new List<Id>();
        List<Id> appointmentCategoryIds = new List<Id>();
        
        insert resourceList;
        insert locationList;
        insert serviceList;
        
        List<CC_QAppt__Location__c> locationRecord =   [select id from CC_QAppt__Location__c limit 1];
        List<CC_QAppt__Service__c> serviceRecord =   [select id from CC_QAppt__Service__c limit 1];
        List<contact> resourceRecord =   [select id from contact limit 1];
        locationids.add(locationRecord[0].Id);
        serviceids.add(serviceRecord[0].Id);
        
        List<CC_QAppt__Location_Service__c> locationService = TestDataFactory.locationServiceAlignment(locationids,serviceRecord[0].Id); 
        insert locationService;
        
        List<CC_QAppt__Resource_Service_Alignment__c> resourceServiceAlignment = TestDataFactory.resourceServiceAlignment(locationids,serviceids,resourceRecord[0].Id); 
        insert resourceServiceAlignment;
        
        List<CC_QAppt__Appointment_Category__c> appointmentCategoryList = TestDataFactory.createAppointmentCategory(1); 
        insert appointmentCategoryList;
        
        List<CC_QAppt__Appointment__c> appList = TestDataFactory.createAppointment(resourceServiceAlignment[0].Id,appointmentCategoryList[0].Id);
        insert appList;
    }
    
    /* method to test Appointment for Location are fetched */
    @isTest
    static void fetchAppointmentRelatedtoLocation(){
        List<CC_QAppt__Resource_Service_Alignment__c> locationIds = [select CC_QAppt__Location__c,CC_QAppt__Service__c from CC_QAppt__Resource_Service_Alignment__c limit 1];
        Test.startTest();
       List<CalendarLightningController.calendarWrapper> appList = CalendarLightningController.fetchAppointments('Location',locationIds[0].CC_QAppt__Location__c);
        Test.stopTest();
        system.assertEquals(appList.size(),1,'while fetching Appointment');
    }
    
   /* method to test Appointment for Service are fetched */
    @isTest
    static void fetchAppointmentRelatedtoService(){
        List<CC_QAppt__Resource_Service_Alignment__c> locationIds = [select CC_QAppt__Location__c,CC_QAppt__Service__c from CC_QAppt__Resource_Service_Alignment__c limit 1];
        Test.startTest();
       List<CalendarLightningController.calendarWrapper> appList = CalendarLightningController.fetchAppointments('Service',locationIds[0].CC_QAppt__Service__c);
        Test.stopTest();
        system.assertEquals(appList.size(),1,'while fetching Appointment');
    }
    /* method to test Appointment for AppointmentCategory are fetched */
    @isTest
    static void fetchAppointmentRelatedtoAppointmentCategory(){
        List<CC_QAppt__Appointment_Category__c> appCategoryIds = [select id from  CC_QAppt__Appointment_Category__c limit 1];
        Test.startTest();
       List<CalendarLightningController.calendarWrapper> appList = CalendarLightningController.fetchAppointments('AppointmentCategory',appCategoryIds[0].Id);
        Test.stopTest();
        system.assertEquals(appList.size(),1,'while fetching Appointment');
    }
    
}