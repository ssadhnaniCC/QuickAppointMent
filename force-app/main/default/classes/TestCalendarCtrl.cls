@isTest 
public class TestCalendarCtrl{
    static testMethod void UnitTest() {
        Appointment__c appObj = new Appointment__c();
        appObj.Start_Date_Time__c = System.now();
        appObj.End_Date_Time__c = system.now().addMinutes(1);
        insert appObj;
         System.assertEquals([select id,name from Appointment__c].size(),1);
        CalendarCtrl obj = new CalendarCtrl();
        CalendarCtrl.fetchAllAppointmentSlotsJSON( UserInfo.getTimeZone().getID());
        obj.startDate = date.today();
        obj.searchAgenda();
       
    }
}