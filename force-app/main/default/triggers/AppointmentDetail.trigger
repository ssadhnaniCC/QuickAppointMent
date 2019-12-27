trigger AppointmentDetail on CC_QAppt__Appointment_Detail__c (before insert , before update,after insert) {
    
    if(Trigger.isbefore){
        if(Trigger.isinsert){
            List<CC_QAppt__Appointment_Detail__c> filteredAppDetails = new List<CC_QAppt__Appointment_Detail__c>();
            for(CC_QAppt__Appointment_Detail__c appdetails : Trigger.new){
                if(appdetails.CC_QAppt__Resource__c!=null){
                    filteredAppDetails.add(appdetails);
                }
            }
           AppointmentDetailHandler.validateResourceWorkingHour(filteredAppDetails);
        }
    }
    //Send Email on Appointment Detail
    if(Trigger.isafter){
        if(Trigger.isinsert){
            List<CC_QAppt__Appointment_Detail__c> filteredAppDetails = new List<CC_QAppt__Appointment_Detail__c>();
            Set<Id> appids = new Set<Id>();
            for(CC_QAppt__Appointment_Detail__c appdetails : Trigger.new){
                if(appdetails.CC_QAppt__Resource__c!=null){
                    filteredAppDetails.add(appdetails);
                    appids.add(appdetails.CC_QAppt__Appointment__c);
                }
                //AppointmentDetailHandler.validateResourceWorkingHour(filteredAppDetails);
            }
           AppointmentDetailHandler.sendEmailOnAppointmentBook(appids,'Scheduled');
        }
    }
}