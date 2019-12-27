public class AppointmentDetailHandler {
    public static void validateResourceWorkingHour(List<CC_QAppt__Appointment_Detail__c> appDetails){
        Set<Id> resourceIds = new Set<Id>();
        Set<Id> appointmentIds = new Set<Id>();
        Map<Id,CC_QAppt__Appointment__c> mapofAppointment = new Map<Id,CC_QAppt__Appointment__c>();
        Map<String, List<CC_QAppt__Working_Hour__c>> resourceWorkingHourMap = new Map<String, List<CC_QAppt__Working_Hour__c>>();
        
        for(CC_QAppt__Appointment_Detail__c details : appDetails){
            resourceIds.add(details.CC_QAppt__Resource__c);
            appointmentIds.add(details.CC_QAppt__Appointment__c);
        }
        
        for(CC_QAppt__Appointment__c app : [select id,CC_QAppt__Start_Date_Time__c,CC_QAppt__End_Date_Time__c from CC_QAppt__Appointment__c where id in : appointmentIds]){
            mapofAppointment.put(app.id,app);  
        }
        
        for(CC_QAppt__Working_Hour__c workinghour : [select CC_QAppt__Active__c,CC_QAppt__Resource__r.name,CC_QAppt__End_Date__c,
                                                     CC_QAppt__End_Time__c,CC_QAppt__Start_Date__c,CC_QAppt__Start_Time__c,CC_QAppt__IsAvailableOnSunday__c,
                                                     CC_QAppt__IsAvailableOnThursday__c,CC_QAppt__IsAvailableOnTuesday__c,CC_QAppt__isAvailableOnWednesday__c,
                                                     CC_QAppt__IsAvailableOnMonday__c,CC_QAppt__IsAvailableOnSaturday__c,CC_QAppt__IsAvailableOnFriday__c,
                                                     CC_QAppt__Resource__c 
                                                     from CC_QAppt__Working_Hour__c 
                                                     where CC_QAppt__Resource__c In : resourceIds And CC_QAppt__Active__c=true]){
            
            List<CC_QAppt__Working_Hour__c> workinghourList = new List<CC_QAppt__Working_Hour__c>();
            if(resourceWorkingHourMap.containsKey(workinghour.CC_QAppt__Resource__c)){
                workinghourList = resourceWorkingHourMap.get(workinghour.CC_QAppt__Resource__c);
            }
            workinghourList.add(workinghour);
            resourceWorkingHourMap.put(workinghour.CC_QAppt__Resource__c, workinghourList);
        }
        
        if(!resourceWorkingHourMap.isEmpty()){
            String currentTimeZone =  UserInfo.getTimeZone().getID();
            for(CC_QAppt__Appointment_Detail__c details : appDetails){
                
                for(CC_QAppt__Working_Hour__c wHObj : resourceWorkingHourMap.get(details.CC_QAppt__Resource__c)){
                    DateTime appStartDateTime = mapofAppointment.get(details.CC_QAppt__Appointment__c).CC_QAppt__Start_Date_Time__c;
                    DateTime appEndDateTime = mapofAppointment.get(details.CC_QAppt__Appointment__c).CC_QAppt__End_Date_Time__c;    
                    String dayOfAppointment =   'CC_QAppt__IsAvailableOn'+appStartDateTime.format('EEEE')+'__c';                      
                    
                    if(!(appStartDateTime >= wHObj.CC_QAppt__Start_Time__c && appStartDateTime <= wHObj.CC_QAppt__End_Time__c) ||
                    !(appEndDateTime >= wHObj.CC_QAppt__Start_Time__c && appEndDateTime <= wHObj.CC_QAppt__End_Time__c) 
                    ){
                        details.addError(wHObj.CC_QAppt__Resource__r.name + ' is not available on ' + appStartDateTime.format('MM/dd/yyyy h:mm a',currentTimeZone));
                        break;
                    }else if(!(Boolean)whObj.get(dayOfAppointment)){
                        details.addError(wHObj.CC_QAppt__Resource__r.name + ' is not available on ' + appStartDateTime.format('MM/dd/yyyy h:mm a',currentTimeZone));
                        break; 
                    }
                }
            }
        }
    }
    
      public static void sendEmailOnAppointmentBook(Set<Id> appointmentIds, String setSubject) {
        
        List<EmailTemplate> empList = [Select id from EmailTemplate where name ='Appointment Email Template' limit 1];
        
        List<string> storeEmail = new List<string>();
        
        if(appointmentIds.size()>0 && empList.size()>0) {
            Set<Id> customerids = new Set<Id>();
            List<Messaging.SingleEmailMessage> messages =   new List<Messaging.SingleEmailMessage>();
                
            for(CC_QAppt__Appointment_Detail__c cqad : [select Id, CC_QAppt__Appointment__c, CC_QAppt__Resource__c, CC_QAppt__Resource__r.email from CC_QAppt__Appointment_Detail__c where  CC_QAppt__Appointment__c In :appointmentIds and CC_QAppt__Resource__r.email != NULL]) {
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(empList[0].id, cqad.CC_QAppt__Resource__c, cqad.CC_QAppt__Appointment__c);
                email.toAddresses = new List<String>{cqad.CC_QAppt__Resource__r.email};
                email.subject = 'Congratulation Your Appointment has been '+setSubject;
                email.setSaveAsActivity(false);
                email.setTemplateId(empList[0].id);
                messages.add(email);
            }
            if(messages.size()>0) {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if (results[0].success){
                    System.debug('The email was sent successfully.');
                } else{
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
            }
            
            
        }
    }

    
    
}