@isTest
public class TestDashboardLightningControler {
    @testSetup static void setUp(){
        List<CC_QAppt__Appointment_Category__c> categoryList = TestDataFactory.AppointmentCategoryList(10);
		list<contact> contactList = TestDataFactory.customerList(10);
        List<CC_QAppt__Location__c> locationList = TestDataFactory.locationList(5);
        List<CC_QAppt__Service__c> serviceList = TestDataFactory.serviceList(5);
        list<contact> resourceList = TestDataFactory.resourceList(5);
        List<Id> locationId = new List<Id>();
        List<Id> serviceId = new List<Id>();
        Insert categoryList;
		Insert contactList;
        Insert locationList;
        Insert serviceList;
        Insert resourceList;
        
        for(Integer i=1; i<5;i++){
            locationId.add(locationList[i].Id);
            serviceId.add(serviceList[i].Id);
        }
        
        List<Resource_Service_Alignment__c> resourceAligmentList = TestDataFactory.resourceServiceAlignment(locationId,serviceId,resourceList[0].id);
        Insert resourceAligmentList;
        
        List<CC_QAppt__Appointment__c> appointmentList = TestDataFactory.createAppointment(resourceAligmentList[0].Id,categoryList[0].Id,'Completed');
        insert appointmentList;
		
		List<CC_QAppt__Appointment_Feedback__c> appointmentFeedbactList = TestDataFactory.createAppointmentFeedback(4);
		Insert appointmentFeedbactList;
		
		
		List<CC_QAppt__Participant__c> participantList = TestDataFactory.createAppointmentParticipant(appointmentList[0].Id,contactList[0].Id,5);
		Insert participantList;
    }
    
    /* method to test the monthly chart of dashboardController*/
    @isTest
    static void monthlyRecordChart(){
        Test.startTest();
        Map<String,Integer> monthlyRecordMap = DashboardControler.getBarChartMonthlyAppointment();
        Test.stopTest();
        system.assertEquals(monthlyRecordMap.size(),12,'error while fetching record on component initialization');
    }
    
    /* method to test daily chart of dashboardController*/
    @isTest
    static void dailyRecordChart(){
        Test.startTest();
        Map<String,Integer> dailyRecordMap = DashboardControler.getDailyBarchart();
        Test.stopTest();
        system.assertEquals(dailyRecordMap.size(),24,'error while fetching record on component initialization');
    }
    
	/* method to test rating of the appointment*/
    @isTest
    static void ratingRecordChart(){
        Test.startTest();
        Map<String,Integer> ratingRecordMap = DashboardControler.getRating();
        Test.stopTest();
        system.assertEquals(ratingRecordMap.size(),5,'error while fetching record on component initialization');
    }
    
	/* method to test average of rating*/
    @isTest
    static void ratingAverageRecordChart(){
        Test.startTest();
        List<Double> ratingAverageRecord = DashboardControler.getAverageRating();
        Test.stopTest();
        system.assertEquals(ratingAverageRecord.size(),2,'error while fetching record on component initialization');
    }
	
	/* method to test top category of appointment*/
    @isTest
    static void topCategoryRecord(){
        Test.startTest();
        Map<String,Integer> topCategoryRecordMap = DashboardControler.getTopCategory();
        Test.stopTest();
        system.assertEquals(topCategoryRecordMap.size(),1,'error while fetching record on component initialization');
    }
	
	/* method to test top customer of appointment*/
    @isTest
    static void topCustomerRecord(){
        Test.startTest();
        Map<String,Integer> topCustomerRecordMap = DashboardControler.getTopCustomer();
        Test.stopTest();
        system.assertEquals(topCustomerRecordMap.size(),1,'error while fetching record on component initialization');
    }
	
	/* method to test upcoming appointment*/
    @isTest
    static void upcomingAppointmentRecord(){
        Test.startTest();
        List<DashboardControler.AppointmentWrapper> appointmentwrap= DashboardControler.getUpcomingAppointment();
        Test.stopTest();
        system.assertEquals(appointmentwrap!=null,true,'error while fetching record on component initialization');
    }
	
	/* method to test upcoming appointment customer record*/
    @isTest
    static void upcomingCustomerRecord(){
        Test.startTest();
        List<DashboardControler.AppointmentWrapper> appointmentwrap= DashboardControler.getUpcomingCustomer();
        Test.stopTest();
        system.assertEquals(appointmentwrap!=null,true,'error while fetching record on component initialization');
    }
}