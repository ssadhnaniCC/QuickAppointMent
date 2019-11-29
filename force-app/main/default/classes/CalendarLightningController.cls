/**
* @author Cloud Certitude
* @date OCTOBER 2019
* @description This class is used to display, edit & delete Contact records where RecordType is 'Resource'
*/
public class CalendarLightningController {
    
/*******************************************************************************************************
* @description This is the method which returns All the Appointments.
* @returns Returns Wrapper List with Appointments details.
*/
    @AuraEnabled
    public static List<calendarWrapper> fetchAppointments(String ObjectName, String recordId){
        String recordTypeName ;
        
        If(!String.isBlank(recordId) && String.isBlank(ObjectName)){
          Id recordIds = recordId;
           ObjectName = recordIds.getSObjectType().getDescribe().getName();        
        }
        List<CC_QAppt__Appointment__c> previousAppointments  = new List<CC_QAppt__Appointment__c>();
        List<calendarWrapper> calWrapp = new List<calendarWrapper>();
        List<contact> customerList = new List<contact>();  
        //Get User Time Zone
        TimeZone tz = UserInfo.getTimeZone();
        String currentTimeZone =  tz.getID();
        //get Event color from custome setting
        UIpanel__c UIPanelData = UIpanel__c.getInstance(Userinfo.getUserid());
        String  StatusUpcoming = UIPanelData.Status_Upcoming__c;
        String  StatusRunning = UIPanelData.Status_Running__c;
        String  StatusCompleted = UIPanelData.Status_Completed__c;
        String  StatusDeclined = UIPanelData.Status_Declined__c;
        List<contact> con = [SELECT RecordType.Name,RecordType.DeveloperName FROM contact where Id =: recordId];
        if(con.size()>0){
        recordTypeName = con[0].RecordType.Name;
        }
        if(recordTypeName == 'Resource'){
            previousAppointments = QuickAppointmentSOQLManager.getPreviousAppointments('contact',recordId);
        }
        if(recordTypeName == 'User'){
            customerList = QuickAppointmentSOQLManager.getCustomers(recordId);
            previousAppointments = QuickAppointmentSOQLManager.getPreviousAppointmentsForCustomers(recordId);
        }
        if((recordTypeName == '' || recordTypeName == null ) && (ObjectName == '' || ObjectName == null )){
           previousAppointments = QuickAppointmentSOQLManager.getPreviousAppointments('','');
        }
        if((recordTypeName == null ) && (ObjectName != null )){
           previousAppointments = QuickAppointmentSOQLManager.getPreviousAppointments(ObjectName,recordId);
        }
        for(CC_QAppt__Appointment__c prevApp : previousAppointments){
            calendarWrapper obj = new calendarWrapper();
            obj.Id = prevApp.Id;
            obj.startDate = prevApp.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
            obj.endDate = prevApp.CC_QAppt__End_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
           
            if(recordTypeName == 'Resource'){
               List<contact> resourceList =  QuickAppointmentSOQLManager.fetchAllResourceStaff(recordId);
               if(resourceList.size()>0){
                   obj.RelatedListName = resourceList[0].Name; 
               }         
            }
            
            if(ObjectName == 'CC_QAppt__Location__c'){
                  Set<Id> locationid = new set<id>();
                locationid.add(recordId);
                List<CC_QAppt__Location__c> LocationList = QuickAppointmentSOQLManager.fetchSelectedLocationForAppointment(locationid);
                if(LocationList.size()>0){  
                    obj.RelatedListName =  LocationList[0].Name;
                }
                locationid.clear();    
            }
            if(ObjectName == 'CC_QAppt__Service__c'){
                Set<Id> Serviceid = new set<id>();
                Serviceid.add(recordId);
                List<CC_QAppt__Service__c> selectedServicesList = QuickAppointmentSOQLManager.fetchSelectedServiceForAppointment(Serviceid);
                if(selectedServicesList.size()>0){  
                    obj.RelatedListName =  selectedServicesList[0].Name;
                }
                Serviceid.clear();
            }
           
            if(ObjectName == 'CC_QAppt__Appointment_Category__c'){
                if( prevApp.CC_QAppt__Appointment_Category__r != null){
                 obj.RelatedListName =  prevApp.CC_QAppt__Appointment_Category__r.Name;
                }
            }    
            if(recordTypeName == 'User'){
            obj.RelatedListName = customerList[0].Name;
            }
            obj.Name = prevApp.Name;
            obj.Description = prevApp.CC_QAppt__Description__c;
            obj.Status = prevApp.CC_QAppt__Status__c;
            if(prevApp.CC_QAppt__Status__c == 'Upcoming'){
                obj.eventColor = StatusUpcoming;        
            }
            else if (obj.Status == 'Running'){
                obj.eventColor = StatusRunning;        
            }
            else if (obj.Status == 'Completed'){
                obj.eventColor = StatusCompleted;        
            }
            else if (obj.Status == 'Declined'){
                obj.eventColor = StatusDeclined;        
            }
            else if(prevApp.Busy_Time__c == true){
                obj.eventColor = 'red';         
            }
            calWrapp.add(obj);
        }
        return calWrapp; 
    }
/*******************************************************************************************************
* @description This is the wrapper class calendarWrapper containing appointment details
*/
    public class calendarWrapper{
        @AuraEnabled   public String Id;    
        @AuraEnabled   public String startDate;
        @AuraEnabled   public String endDate;
        @AuraEnabled   public String Name;
        @AuraEnabled   public String RelatedListName;
        @AuraEnabled   public String Description;
        @AuraEnabled   public String Status;
        @AuraEnabled   public String eventColor; 
    }
}