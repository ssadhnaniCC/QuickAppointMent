public without sharing class AppointmentTriggerHelper {
    public static void checkHoliday(List<Appointment__c> newAppointmentList){
        try{
            Set<Id> locationIdSet = new Set<Id>();
            Map<Id,List<Date>> holidayLocation = new Map<Id,List<Date>>();
            for(Appointment__c app : newAppointmentList){
                locationIdSet.add((Id)app.Locations__c);
            }
            List<Date> dateList;
            if(!locationIdSet.isEmpty()){
                for(CC_QAppt__Public_Holidays__c obj : [Select CC_QAppt__Holiday_Date__c,CC_QAppt__Location__c from CC_QAppt__Public_Holidays__c where CC_QAppt__Location__c In : locationIdSet]){
                    if(!holidayLocation.containskey(obj.CC_QAppt__Location__c))
                        dateList = new List<Date>();
                    else
                        dateList = holidayLocation.get(obj.CC_QAppt__Location__c);
                    dateList.add(obj.CC_QAppt__Holiday_Date__c);
                    holidayLocation.put(obj.CC_QAppt__Location__c,dateList);
                }
                for(Appointment__c app : newAppointmentList){
                    if(holidayLocation.containskey(app.Locations__c)){
                        for(date holidateDate : holidayLocation.get(app.Locations__c)){
                            DateTime dT = app.CC_QAppt__Start_Date_Time__c;
                            String myDate =String.valueOf(date.newinstance(dT.year(), dT.month(), dT.day())).SubStringBefore(' ');
                            if(String.valueOf(holidateDate) == myDate ){
                                app.addError(myDate + ' is a Holiday');
                                break;
                            }
                        }
                    }
                }
            }
        }catch(Exception exp){
            system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
        }
    }
    
    public static void insertAppointmentDetail(List<Appointment__c> appointmentList){
        List<Appointment_Detail__c> appointmentDetailList = new List<Appointment_Detail__c>();
        try{
            for(Appointment__c appObj : appointmentList){
                if(appObj.CC_QAppt__Locations__c != Null){
                    for(String location : appObj.CC_QAppt__Locations__c.split(',')){
                        appointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Location__c = location));
                    }
                }
                if(appObj.CC_QAppt__Services__c != Null){
                    for(String service : appObj.CC_QAppt__Services__c.split(',')){
                        appointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Service__c = service));
                    }
                }
                if(appObj.CC_QAppt__Resources__c != Null){
                    for(String resourceStaff : appObj.CC_QAppt__Resources__c.split(',')){
                        appointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Resource__c = resourceStaff));
                    }
                }
                if(appObj.CC_QAppt__Attendees__c != Null){
                    for(String attednee : appObj.CC_QAppt__Attendees__c.split(',')){
                        appointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Attendee__c = attednee));
                    }
                }
                if(appObj.CC_QAppt__Assets__c != Null){
                    for(String asset : appObj.CC_QAppt__Assets__c.split(',')){
                        appointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Asset__c = asset));
                    }
                }
            }
            Insert appointmentDetailList;
        }catch(Exception exp){
            system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
        }
    }
    
    public Static void updateAppointmentDetail(List<Appointment__c> newAppointmentList,Map<Id,Appointment__c> oldAppointmentMap){
        List<Appointment_Detail__c> insertAppointmentDetailList = new List<Appointment_Detail__c>();
        Set<String> deleteLocationSet = new Set<String>();
        Set<String> deleteResourceSet = new Set<String>();
        Set<String> deleteServiceSet = new Set<String>();
        Set<String> deleteAttendeeSet = new Set<String>();
        Set<String> deleteAssetsSet = new Set<String>();
        
        try{
            for(Appointment__c appObj : newAppointmentList){
                System.debug('Appointment');
                if(appObj.CC_QAppt__Locations__c != null){
                    Set<String> newLocationIdSet = new Set<String>(appObj.CC_QAppt__Locations__c.split(','));
                    Set<String> oldLocationIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Locations__c.split(','));
                    Set<String> newOldLocation =  new Set<String>();
                    newOldLocation.addAll(oldLocationIdSet);
                    newOldLocation.addAll(newLocationIdSet);
                    if( !newOldLocation.isEmpty()){
                        for(String locationId : newOldLocation){
                            System.debug('location');
                            if(!oldLocationIdSet.contains(locationId) && newLocationIdSet.contains(locationId))
                                insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Location__c = locationId));
                            if(oldLocationIdSet.contains(locationId) && !newLocationIdSet.contains(locationId))
                                deleteLocationSet.add(appObj.Id + ',' +locationId);
                        }
                        System.debug('location inse'+insertAppointmentDetailList);
                        System.debug('location old'+oldLocationIdSet);
                        System.debug('location new'+newLocationIdSet);
                        System.debug('location delete'+deleteLocationSet);
                    }
                    
                }
                if(appObj.CC_QAppt__Services__c != Null){
                    Set<String> oldServiceIdSet = new Set<String>(appObj.CC_QAppt__Services__c.split(','));
                    Set<String> newServiceIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Services__c.split(','));
                    Set<String> newOldService =  new Set<String>();
                    newOldService.addAll(oldServiceIdSet);
                    newOldService.addAll(newServiceIdSet);
                    if( !newOldService.isEmpty()){
                        for(String serviceId : newOldService){
                            System.debug('service');
                            if(!oldServiceIdSet.contains(serviceId) && newServiceIdSet.contains(serviceId))
                                insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Service__c = serviceId));
                            if(oldServiceIdSet.contains(serviceId) && !newServiceIdSet.contains(serviceId))
                                deleteServiceSet.add(appObj.Id + ',' +serviceId);
                        }
                    }
                }
                
                if(appObj.CC_QAppt__Resources__c != Null){
                    Set<String> oldResourceIdSet = new Set<String>(appObj.CC_QAppt__Resources__c.split(','));
                    Set<String> newResourceIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Resources__c.split(','));
                    Set<String> newOldResource =  new Set<String>();
                    newOldResource.addAll(oldResourceIdSet);
                    newOldResource.addAll(newResourceIdSet);
                    if( !newOldResource.isEmpty()){
                        for(String resourceId : newOldResource){
                            System.debug('resource');
                            if(!oldResourceIdSet.contains(resourceId) && newResourceIdSet.contains(resourceId))
                                insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Resource__c = resourceId));
                            if(oldResourceIdSet.contains(resourceId) && !newResourceIdSet.contains(resourceId))
                                deleteResourceSet.add(appObj.Id + ',' +resourceId);
                        }
                    }
                }
                
                if(appObj.CC_QAppt__Attendees__c != Null){
                    Set<String> oldAttendeesIdSet = new Set<String>(appObj.CC_QAppt__Attendees__c.split(','));
                    Set<String> newAttendeesIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Attendees__c.split(','));
                    Set<String> newOldAttendees =  new Set<String>();
                    newOldAttendees.addAll(oldAttendeesIdSet);
                    newOldAttendees.addAll(newAttendeesIdSet);
                    if( !newOldAttendees.isEmpty()){
                        for(String attendeeId : newOldAttendees){
                            if(!oldAttendeesIdSet.contains(attendeeId) && newAttendeesIdSet.contains(attendeeId))
                                insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Attendee__c = attendeeId));
                            if(oldAttendeesIdSet.contains(attendeeId) && !newAttendeesIdSet.contains(attendeeId))
                                deleteAttendeeSet.add(appObj.Id + ',' +attendeeId);
                        }
                    }
                }
                
                if(appObj.CC_QAppt__Assets__c != Null){
                    Set<String> oldAssetsIdSet = new Set<String>(appObj.CC_QAppt__Assets__c.split(','));
                    Set<String> newAssetsIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Assets__c.split(','));
                    Set<String> newOldAssets = new Set<String>();
                    newOldAssets.addAll(oldAssetsIdSet);
                    newOldAssets.addAll(newAssetsIdSet);
                    if( !newOldAssets.isEmpty()){
                        for(String assetsId : newOldAssets){
                            if(!oldAssetsIdSet.contains(assetsId) && newAssetsIdSet.contains(assetsId))
                                insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Asset__c = assetsId));
                            if(oldAssetsIdSet.contains(assetsId) && !newAssetsIdSet.contains(assetsId))
                                deleteAssetsSet.add(appObj.Id + ',' +assetsId);
                        }
                    }
                }
            }
            Set<String> AppointmentId = new Set<String>();
            Set<String> recordId = new Set<String>();
            List<CC_QAppt__Appointment_Detail__c> deleteAppointmentList = new List<CC_QAppt__Appointment_Detail__c>();
            if(!deleteLocationSet.isEmpty()){
                for(String locationId : deleteLocationSet){
                    AppointmentId.add(locationId.substringBefore(','));
                    recordId.add(locationId.substringAfter(','));
                }
                deleteAppointmentList = [SELECt Id,CC_QAppt__Appointment__c,CC_QAppt__Location__c FROM CC_QAppt__Appointment_Detail__c WHERE CC_QAppt__Appointment__c IN: AppointmentId AND CC_QAppt__Location__c IN: recordId];
                System.debug('AppointmentId'+AppointmentId);
                System.debug('recordId'+recordId);
                System.debug('deleteAppointmentList'+deleteAppointmentList);
            }
            
            if(!deleteServiceSet.isEmpty()){
                AppointmentId.clear();
                recordId.clear();
                for(String serviceId : deleteServiceSet){
                    AppointmentId.add(serviceId.substringBefore(','));
                    recordId.add(serviceId.substringAfter(','));
                }
                deleteAppointmentList = [SELECt Id FROM CC_QAppt__Appointment_Detail__c WHERE CC_QAppt__Appointment__c IN: AppointmentId AND CC_QAppt__Service__c IN: recordId];
            }
            
            if(!deleteResourceSet.isEmpty()){
                AppointmentId.clear();
                recordId.clear();
                for(String resourceId : deleteResourceSet){
                    AppointmentId.add(resourceId.substringBefore(','));
                    recordId.add(resourceId.substringAfter(','));
                }
                deleteAppointmentList = [SELECt Id FROM CC_QAppt__Appointment_Detail__c WHERE CC_QAppt__Appointment__c IN: AppointmentId AND CC_QAppt__Resource__c IN: recordId];
            }
            
            if(!deleteAttendeeSet.isEmpty()){
                AppointmentId.clear();
                recordId.clear();
                for(String attendeesId : deleteAttendeeSet){
                    AppointmentId.add(attendeesId.substringBefore(','));
                    recordId.add(attendeesId.substringAfter(','));
                }
                deleteAppointmentList = [SELECt Id FROM CC_QAppt__Appointment_Detail__c WHERE CC_QAppt__Appointment__c IN: AppointmentId AND CC_QAppt__Attendee__c IN: recordId];
            }
            
            if(!deleteAssetsSet.isEmpty()){
                AppointmentId.clear();
                recordId.clear();
                for(String assetsId : deleteAssetsSet){
                    AppointmentId.add(assetsId.substringBefore(','));
                    recordId.add(assetsId.substringAfter(','));
                }
                deleteAppointmentList = [SELECt Id FROM CC_QAppt__Appointment_Detail__c WHERE CC_QAppt__Appointment__c IN: AppointmentId AND CC_QAppt__Asset__c IN: recordId];
            }
            if(!insertAppointmentDetailList.isEmpty()){
                System.debug('rtfrom inse'+insertAppointmentDetailList);
                INSERT insertAppointmentDetailList;
            }
            if(!deleteAppointmentList.isEmpty()){
                System.debug('delete'+deleteAppointmentList);
                DELETE deleteAppointmentList;
            }
        }catch(Exception exp){
            system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
        }
    }
    
    public Static void deleteAppointmentDetail(List<Appointment__c> deletedAppointment){
        try{
            Set<Id> deletedIdSet = new Set<Id>();
            For(Appointment__c obj : deletedAppointment){
                deletedIdSet.add(obj.Id);
            }
            List<Appointment_Detail__c> appointmentDetailList = [SELECT Id FROM Appointment_Detail__c WHERE CC_QAppt__Appointment__c IN: deletedIdSet LIMIT 1000];
            DELETE appointmentDetailList;
        }catch(Exception exp){
            system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
        }
    }
    
    public static void sendEmailOnAppointmentBook(List<CC_QAppt__Appointment__c> appointmentList, String setSubject) {
        
        List<EmailTemplate> empList = [Select id from EmailTemplate where name ='Appointment Email Template' limit 1];
        system.debug('empList=='+empList);
        
        List<string> storeEmail = new List<string>();
        Set<Id> appointmentIds = new set<Id>();
        
        for(CC_QAppt__Appointment__c ccqa : appointmentList) {
            appointmentIds.add(ccqa.id);
        }
        
        if(appointmentIds.size()>0 && empList.size()>0) {
            Set<Id> customerids = new Set<Id>();
            
            /*for(Participant__c par : [select Id from Participant__c where CC_QAppt__Appointment__c IN : appointmentIds]) {
                customerids.add(par.Id);
            }*/
            
            /*if(customerids.size()>0) {
                
                for(contact con : [select Id,email from contact where Id In:customerids]) {
                    
                    if(con.Email != null)
                        storeEmail.add(con.Email);
                }
                
            } */           
            
            List<Messaging.SingleEmailMessage> messages =   new List<Messaging.SingleEmailMessage>();
                
            for(CC_QAppt__Appointment_Detail__c cqad : [select Id, CC_QAppt__Appointment__c, CC_QAppt__Resource__c, CC_QAppt__Resource__r.email from CC_QAppt__Appointment_Detail__c where  CC_QAppt__Appointment__c In :appointmentIds and CC_QAppt__Resource__r.email != NULL]) {
                //storeEmail.add(cqad.CC_QAppt__Resource__r.email);
                //String char15templateId =  ((String)empList[0].id).subString(0, 15);
                //String char15whoId =  ((String)cqad.CC_QAppt__Resource__c).subString(0, 15);
                //String char15whatId =  ((String)cqad.CC_QAppt__Appointment__c).subString(0, 15);
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(empList[0].id, cqad.CC_QAppt__Resource__c, cqad.CC_QAppt__Appointment__c);
                email.toAddresses = new List<String>{cqad.CC_QAppt__Resource__r.email};
                email.subject = 'Congratulation Your Appointment has been '+setSubject;
                email.setSaveAsActivity(false);
                email.setTemplateId(empList[0].id);
                //email.setWhatId(cqad.CC_QAppt__Appointment__c); //This is important for the merge fields in template to work
                  
                messages.add(email);
                
                
                
                /*Messaging.SingleEmailMessage message = new        Messaging.SingleEmailMessage();
                message.setTargetObjectId(contact.id); 
                   message.setSenderDisplayName(‘Company Support’); 
                   message.setReplyTo(‘no-reply@company.com’);
                   message.setUseSignature(false); 
                   message.setBccSender(false); 
                   message.setSaveAsActivity(false); 
                  EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = ‘Test Account Alert Email’];
                  message.setTemplateID(emailTemplate.Id); 
                  message.setWhatId(account.Id); //This is important for the merge fields in template to work
                  message.toAddresses = new String[] { contact.email};
                  Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                  Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);*/
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
    
    public static void handleOnBeforeInsert(List<Appointment__c> newAppointmentList) {
        AppointmentTriggerHelper.checkHoliday(newAppointmentList);
    }
    
    public static void handleOnBeforeUpdate() {
        
    }
    
    public static void handleOnAfterInsert(List<CC_QAppt__Appointment__c> appointmentList) {
        AppointmentTriggerHelper.insertAppointmentDetail(appointmentList);
        AppointmentTriggerHelper.sendEmailOnAppointmentBook(appointmentList,'Scheduled');
        
    }
    
    public static void handleOnAfterUpdate(List<CC_QAppt__Appointment__c> appointmentList,Map<Id,CC_QAppt__Appointment__c> oldAppointmentMap) {
        
        
        AppointmentTriggerHelper.updateAppointmentDetail(appointmentList,oldAppointmentMap);
        AppointmentTriggerHelper.sendEmailOnAppointmentBook(appointmentList,'Modified');
    }
    
    public static void handleOnBeforeDelete() {
        
    }
    
    public static void handleOnAfterDelete(List<CC_QAppt__Appointment__c> appointmentList) {
        AppointmentTriggerHelper.deleteAppointmentDetail(appointmentList);
    }
    
    public static void handleOnUndeleteFunctionality(List<CC_QAppt__Appointment__c> appointmentList) {
        AppointmentTriggerHelper.insertAppointmentDetail(appointmentList);
    }
    
}