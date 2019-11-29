public class AppointmentTriggerHelper {
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
                Set<String> oldLocationIdSet = new Set<String>(appObj.CC_QAppt__Locations__c.split(','));
                Set<String> newLocationIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Locations__c.split(','));
                Set<String> newOldLocation =  oldLocationIdSet;
                newOldLocation.addAll(newLocationIdSet);
                if( !newOldLocation.isEmpty()){
                    for(String locationId : newOldLocation){
                        if(!oldLocationIdSet.contains(locationId) && newLocationIdSet.contains(locationId))
                            insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Location__c = locationId));
                        if(oldLocationIdSet.contains(locationId) && !newLocationIdSet.contains(locationId))
                            deleteLocationSet.add(appObj.Id + ',' +locationId);
                    }
                }
                
                Set<String> oldServiceIdSet = new Set<String>(appObj.CC_QAppt__Services__c.split(','));
                Set<String> newServiceIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Services__c.split(','));
                Set<String> newOldService =  oldServiceIdSet;
                newOldService.addAll(newServiceIdSet);
                if( !newOldService.isEmpty()){
                    for(String serviceId : newOldService){
                        if(!oldServiceIdSet.contains(serviceId) && newServiceIdSet.contains(serviceId))
                            insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Location__c = serviceId));
                        if(oldServiceIdSet.contains(serviceId) && !newServiceIdSet.contains(serviceId))
                            deleteServiceSet.add(appObj.Id + ',' +serviceId);
                    }
                }
                
                Set<String> oldResourceIdSet = new Set<String>(appObj.CC_QAppt__Resources__c.split(','));
                Set<String> newResourceIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Resources__c.split(','));
                Set<String> newOldResource =  oldResourceIdSet;
                newOldResource.addAll(newResourceIdSet);
                if( !newOldResource.isEmpty()){
                    for(String resourceId : newOldResource){
                        if(!oldResourceIdSet.contains(resourceId) && newResourceIdSet.contains(resourceId))
                            insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Resource__c = resourceId));
                        if(oldResourceIdSet.contains(resourceId) && !newResourceIdSet.contains(resourceId))
                            deleteResourceSet.add(appObj.Id + ',' +resourceId);
                    }
                }
                
                Set<String> oldAttendeesIdSet = new Set<String>(appObj.CC_QAppt__Attendees__c.split(','));
                Set<String> newAttendeesIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Attendees__c.split(','));
                Set<String> newOldAttendees =  oldAttendeesIdSet;
                newOldAttendees.addAll(newAttendeesIdSet);
                if( !newOldAttendees.isEmpty()){
                    for(String attendeeId : newOldAttendees){
                        if(!oldAttendeesIdSet.contains(attendeeId) && newAttendeesIdSet.contains(attendeeId))
                            insertAppointmentDetailList.add(new Appointment_Detail__c(CC_QAppt__Appointment__c = appObj.Id,CC_QAppt__Attendee__c = attendeeId));
                        if(oldAttendeesIdSet.contains(attendeeId) && !newAttendeesIdSet.contains(attendeeId))
                            deleteAttendeeSet.add(appObj.Id + ',' +attendeeId);
                    }
                }
                
                Set<String> oldAssetsIdSet = new Set<String>(appObj.CC_QAppt__Assets__c.split(','));
                Set<String> newAssetsIdSet = new Set<String>(oldAppointmentMap.get(appObj.Id).CC_QAppt__Assets__c.split(','));
                Set<String> newOldAssets =  oldAssetsIdSet;
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
}