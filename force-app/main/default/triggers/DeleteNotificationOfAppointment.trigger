trigger DeleteNotificationOfAppointment on Appointment__c (after delete) {
    
    set<Id> appIds = new set<Id>();
    
    if ( Trigger.isAfter && Trigger.isDelete ) {
        for(Appointment__c app : Trigger.old){
            appIds.add(app.Id);
        }
    }
    if(appIds.size()>0){
        List<Notification__c> noti = [select id,name,Appointment__c from Notification__c where Appointment__c IN : appIds];
        delete noti;
    }
}