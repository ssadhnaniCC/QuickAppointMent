@isTest 
public class TestDeleteNotificationOfAppointment{
    static testMethod void UnitTest() {
        contact con = new contact();
        con.lastname = 'provider name';
        insert con;
        
        Appointment__c appObj = new Appointment__c();
        appObj.Start_Date_Time__c = System.now();
        appObj.End_Date_Time__c = system.now().addMinutes(1);
        insert appObj;
        
        Notification__c noti = new Notification__c();
        noti.Contact__c = con.id;
        noti.Appointment__c  = appObj.id;
        
        insert noti;
        delete appObj;
        system.assertEquals([select name from appointment__c].size(),0);
    }
}