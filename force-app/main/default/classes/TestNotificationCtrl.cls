@isTest 
public class TestNotificationCtrl{
    static testMethod void UnitTest() {
        contact newCon = new contact();
        newCon.lastname= 'Jams Smith';
        newCon.Capacity__c = 0;
        newCon.Languages__c = 'English';
        insert newCon;
        
        Notification__c obj = new Notification__c();
        obj.Contact__c = newCon.Id;
        obj.Description__c = 'Appointment Created';
        insert obj;
        NotificationCtrl.getNotificationCount();
        System.assertEquals([select id,name from Notification__c].size(),1);
        NotificationCtrl.getNotification();
        NotificationCtrl.CheckAllNotification();
        
        NotificationCtrl.CheckReadNotification(obj.id);
        NotificationCtrl.ClearAllNotification(newCon.id);
    }
}