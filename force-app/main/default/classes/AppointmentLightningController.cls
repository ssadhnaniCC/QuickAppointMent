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
        List<CC_QAppt__Appointment_Detail__c> relatedAppointmentsdetails = new List<CC_QAppt__Appointment_Detail__c>();
        Map<Id,CC_QAppt__Appointment_Detail__c> mapsofrelatedAppointment ;
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
            mapsofrelatedAppointment = QuickAppointmentSOQLManager.getPreviousAppointments('contact',recordId);
             for(Id keys :mapsofrelatedAppointment.keyset()){
                relatedAppointmentsdetails.add(mapsofrelatedAppointment.get(keys));
            }
        }
        if(recordTypeName == 'User'){
            customerList = QuickAppointmentSOQLManager.getCustomers(recordId);
            mapsofrelatedAppointment = QuickAppointmentSOQLManager.getPreviousAppointmentsForCustomers(recordId);
            for(Id keys :mapsofrelatedAppointment.keyset()){
                relatedAppointmentsdetails.add(mapsofrelatedAppointment.get(keys));
            }
        }
        if((recordTypeName == '' || recordTypeName == null ) && (ObjectName == '' || ObjectName == null )){
            mapsofrelatedAppointment = QuickAppointmentSOQLManager.getPreviousAppointments('','');
            for(Id keys :mapsofrelatedAppointment.keyset()){
                relatedAppointmentsdetails.add(mapsofrelatedAppointment.get(keys));
            }
        }
        if((recordTypeName == '' || recordTypeName == null ) && (ObjectName != '' || ObjectName != null )){
            mapsofrelatedAppointment = QuickAppointmentSOQLManager.getPreviousAppointments(ObjectName,recordId);
             for(Id keys :mapsofrelatedAppointment.keyset()){
                relatedAppointmentsdetails.add(mapsofrelatedAppointment.get(keys));
            }
        }
        system.debug('relatedAppointments'+relatedAppointmentsdetails);
        for(CC_QAppt__Appointment_Detail__c appointment : relatedAppointmentsdetails){
            AppointmentWrapper obj = new AppointmentWrapper();
            if(recordTypeName == 'Resource'){
                    obj.ResourceStaffOrCustomer = appointment.CC_QAppt__Resource__r.Name; 
            }
            if(ObjectName == 'CC_QAppt__Appointment_Category__c'){
               List<CC_QAppt__Appointment_Category__c> appcategory  = QuickAppointmentSOQLManager.getAppointmentCategories(appointment.CC_QAppt__Appointment__r.CC_QAppt__Appointment_Category__c,false); 
                obj.ResourceStaffOrCustomer = appcategory[0].Name;
            }     
            if(ObjectName == 'CC_QAppt__Location__c'){
               obj.ResourceStaffOrCustomer =   appointment.CC_QAppt__LocationService__r.CC_QAppt__Location__r.Name;
            }
            if(ObjectName == 'CC_QAppt__Service__c'){
              obj.ResourceStaffOrCustomer =   appointment.CC_QAppt__LocationService__r.CC_QAppt__Service__r.Name;
            } 
           if(recordTypeName == 'User'){
               List<contact> customerLists = QuickAppointmentSOQLManager.getCustomers(recordId);
                if(customerLists.size()>0){
                    obj.ResourceStaffOrCustomer =  customerLists[0].Name;   
                }
            }
            obj.Location = appointment.CC_QAppt__LocationService__r.CC_QAppt__Location__r.Name;
            obj.Service = appointment.CC_QAppt__LocationService__r.CC_QAppt__Service__r.Name;
            obj.Name = appointment.CC_QAppt__Appointment__r.Name;
            obj.StartDate =  appointment.CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy HH:mm:ss',currentTimeZone);
            obj.Status = appointment.CC_QAppt__Appointment__r.CC_QAppt__Status__c;
            appWrapp.add(obj);
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