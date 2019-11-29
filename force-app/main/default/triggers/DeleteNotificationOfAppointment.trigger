trigger DeleteNotificationOfAppointment on Appointment__c (before insert,after insert,after update,after delete,after undelete) {
    
    set<Id> appIds = new set<Id>();
    
    if ( Trigger.isAfter){
        if (Trigger.isInsert){
           if(Trigger.New != Null)
            AppointmentTriggerHelper.insertAppointmentDetail(Trigger.New);
        }
        if (Trigger.isUpdate){
            AppointmentTriggerHelper.updateAppointmentDetail(Trigger.New,Trigger.oldmap);
        }
        if (Trigger.isDelete ) {
            AppointmentTriggerHelper.deleteAppointmentDetail(Trigger.old);
            for(Appointment__c app : Trigger.old){
                appIds.add(app.Id);
            }
            if(appIds.size()>0){
                List<Notification__c> noti = [select id,name,Appointment__c from Notification__c where Appointment__c IN : appIds];
                delete noti;
            }
        }
        if (Trigger.isUndelete){
            AppointmentTriggerHelper.insertAppointmentDetail(Trigger.New);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            AppointmentTriggerHelper.checkHoliday(Trigger.new);
        }
    }
}