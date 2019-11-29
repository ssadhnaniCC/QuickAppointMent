/**
* @author Cloud Certitude
* @date NOVEMBER 2019
* @description This class is used to fetchRelatedAppointments from ResourceStaff And Customer'
*/
public class AppointmentLightningController {
    
    /*******************************************************************************************************
* @description This is the method which returns related appointments for ResourceStaff/Customer.
* @returns Returns List of Contact resources on PageLoad.
*/
    @AuraEnabled
    public static List<AppointmentWrapper> relatedAppointment(String ObjectName,String recordId){
        
        If(!String.isBlank(recordId) && String.isBlank(ObjectName)){
            Id recordIds = recordId;
            ObjectName = recordIds.getSObjectType().getDescribe().getName();  
        }
        List<AppointmentWrapper> appWrapp = new List<AppointmentWrapper>();
        List<CC_QAppt__Appointment__c> relatedAppointments = new List<CC_QAppt__Appointment__c>();
        List<contact> customerList = new List<contact>();  
        //Get User Time Zone
        TimeZone tz = UserInfo.getTimeZone();
        String currentTimeZone =  tz.getID();
        String recordTypeName;
        
        // Get Recordtype name for knowing whether record is of resourcestaff or customer
        List<contact> con = [SELECT RecordType.Name,RecordType.DeveloperName FROM contact where Id =: recordId];
        
        if(con.size()>0){
            recordTypeName = con[0].RecordType.Name;
        } 
        if(recordTypeName == 'Resource'){
            //   system.debug('Resource');
            relatedAppointments = QuickAppointmentSOQLManager.getPreviousAppointments('contact',recordId);
        }
        if(recordTypeName == 'User'){
            customerList = QuickAppointmentSOQLManager.getCustomers(recordId);
            relatedAppointments = QuickAppointmentSOQLManager.getPreviousAppointmentsForCustomers(recordId);
        }
        if((recordTypeName == '' || recordTypeName == null ) && (ObjectName == '' || ObjectName == null )){
            relatedAppointments = QuickAppointmentSOQLManager.getPreviousAppointments('','');
        }
        if((recordTypeName == '' || recordTypeName == null ) && (ObjectName != '' || ObjectName != null )){
            relatedAppointments = QuickAppointmentSOQLManager.getPreviousAppointments(ObjectName,recordId);
        }
        system.debug('relatedAppointments'+relatedAppointments);
        for(CC_QAppt__Appointment__c appointment : relatedAppointments){
            Set<Id> selectedLocationId = new Set<Id>();
            Set<Id> selectedServiceId = new Set<Id>();
            AppointmentWrapper obj = new AppointmentWrapper();
            if(!String.isBlank(appointment.CC_QAppt__Locations__c)){
                List<Id> locationids =  appointment.CC_QAppt__Locations__c.split(','); 
                selectedLocationId.addall(locationids);
                List<CC_QAppt__Location__c> selectedLocationList =  QuickAppointmentSOQLManager.fetchSelectedLocationForAppointment(selectedLocationId);
                if(selectedLocationList.size() == 1){
                    obj.Location =  selectedLocationList[0].Name;
                }
                else{
                    String commaSepratedList = '';
                    for(CC_QAppt__Location__c loc : selectedLocationList){
                        if(commaSepratedList == ''){
                            commaSepratedList = loc.Name;
                        }
                        else{
                            commaSepratedList += ',' + loc.Name ; 
                        }
                    }
                    obj.Location = commaSepratedList;
                }
                selectedLocationList.clear();
                locationids.clear();
            }         
            if(!String.isBlank(appointment.CC_QAppt__Services__c)){
                List<Id> servicesids =  appointment.CC_QAppt__Services__c.split(','); 
                selectedServiceId.addall(servicesids);
                List<CC_QAppt__Service__c> selectedServicesList = QuickAppointmentSOQLManager.fetchSelectedServiceForAppointment(selectedServiceId);
                if(selectedServicesList.size() == 1){
                    obj.Service =  selectedServicesList[0].Name;
                }
                else{
                    String commaSepratedList = '';
                    for(CC_QAppt__Service__c service : selectedServicesList){
                        if(commaSepratedList == ''){
                            commaSepratedList = service.Name;
                        }
                        else{
                            commaSepratedList += ',' + service.Name ; 
                        }
                    }
                    obj.Service = commaSepratedList;
                }
                servicesids.clear();
                selectedServicesList.clear();
            }
            if(recordTypeName == 'Resource'){
                List<contact> resourceList =  QuickAppointmentSOQLManager.fetchAllResourceStaff(recordId);
                if(resourceList.size()>0){
                    obj.ResourceStaffOrCustomer = resourceList[0].Name; 
                }               
            }
            if(ObjectName == 'CC_QAppt__Appointment_Category__c'){
                    obj.ResourceStaffOrCustomer =  appointment.CC_QAppt__Appointment_Category__r.Name;
            }     
            if(ObjectName == 'CC_QAppt__Location__c'){
                Set<Id> locationid = new set<id>();
                locationid.add(recordId);
                List<CC_QAppt__Location__c> LocationList = QuickAppointmentSOQLManager.fetchSelectedLocationForAppointment(locationid);
                if(LocationList.size()>0){  
                    obj.ResourceStaffOrCustomer =  LocationList[0].Name;
                }
                locationid.clear();
            }
            if(ObjectName == 'CC_QAppt__Service__c'){
                Set<Id> Serviceid = new set<id>();
                Serviceid.add(recordId);
                List<CC_QAppt__Service__c> selectedServicesList = QuickAppointmentSOQLManager.fetchSelectedServiceForAppointment(Serviceid);
                if(selectedServicesList.size()>0){  
                    obj.ResourceStaffOrCustomer =  selectedServicesList[0].Name;
                }
                Serviceid.clear();
            } 
            if(recordTypeName == 'User'){
               List<contact> customerLists = QuickAppointmentSOQLManager.getCustomers(recordId);
                if(customerLists.size()>0){
                    obj.ResourceStaffOrCustomer =  customerLists[0].Name;   
                }
            }
            
            obj.Name = appointment.Name;
            obj.StartDate =  appointment.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy HH:mm:ss',currentTimeZone);
            obj.Status = appointment.CC_QAppt__Status__c;
            appWrapp.add(obj);
            
            if(!selectedLocationId.isEmpty()){
            selectedLocationId.clear();
            }
            if(!selectedServiceId.isEmpty()){
            selectedServiceId.clear();
            }
        }
        return appWrapp;
    }
    /*******************************************************************************************************
* @description Wrapper Class for storing appointment related datas.
*/
    public class AppointmentWrapper{
        @AuraEnabled   public String Name;
        @AuraEnabled   public String Location;
        @AuraEnabled   public String Service;
        @AuraEnabled   public String ResourceStaff;
        @AuraEnabled   public String ResourceStaffOrCustomer;
        @AuraEnabled   public String StartDate;
        @AuraEnabled   public String Status;
    }
}