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
        List<CC_QAppt__Appointment_Detail__c> previousAppointments  = new List<CC_QAppt__Appointment_Detail__c>();
        
        List<CC_QAppt__Appointment__c> appointments = new List<CC_QAppt__Appointment__c>();
        Map<Id,CC_QAppt__Appointment_Detail__c> mapsofrelatedAppointment ;
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
            mapsofrelatedAppointment = QuickAppointmentSOQLManager.getPreviousAppointments('contact',recordId);
            for(Id keys :mapsofrelatedAppointment.keyset()){
                previousAppointments.add(mapsofrelatedAppointment.get(keys));
            } 
        }
        if(recordTypeName == 'User'){
            customerList = QuickAppointmentSOQLManager.getCustomers(recordId);
            mapsofrelatedAppointment = QuickAppointmentSOQLManager.getPreviousAppointmentsForCustomers(recordId);
             for(Id keys :mapsofrelatedAppointment.keyset()){
                previousAppointments.add(mapsofrelatedAppointment.get(keys));
            }
        }
        if((recordTypeName == '' || recordTypeName == null ) && (ObjectName == '' || ObjectName == null )){
           mapsofrelatedAppointment = QuickAppointmentSOQLManager.getAllAppointments();
            for(Id keys :mapsofrelatedAppointment.keyset()){
                previousAppointments.add(mapsofrelatedAppointment.get(keys));
            }
        }
        if((recordTypeName == null ) && (ObjectName != null )){
           mapsofrelatedAppointment = QuickAppointmentSOQLManager.getPreviousAppointments(ObjectName,recordId);
            for(Id keys :mapsofrelatedAppointment.keyset()){
                previousAppointments.add(mapsofrelatedAppointment.get(keys));
            }
        }
        for(CC_QAppt__Appointment_Detail__c prevApp : previousAppointments){
            calendarWrapper obj = new calendarWrapper();
            obj.Id = prevApp.CC_QAppt__Appointment__c;
            obj.startDate = prevApp.CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
            obj.endDate = prevApp.CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
           
            if(recordTypeName == 'Resource'){
            obj.RelatedListName  =  prevApp.CC_QAppt__Resource__r.Name;              
            }
            
            if(ObjectName == 'CC_QAppt__Location__c'){
            obj.RelatedListName      = prevApp.CC_QAppt__LocationService__r.CC_QAppt__Location__r.Name;     
            }
            if(ObjectName == 'CC_QAppt__Service__c'){
             obj.RelatedListName      = prevApp.CC_QAppt__LocationService__r.CC_QAppt__Service__r.Name;
 
            } 
            if(ObjectName == 'CC_QAppt__Appointment_Category__c'){
              obj.RelatedListName      = prevApp.CC_QAppt__Appointment__r.CC_QAppt__Appointment_Category__r.Name;
            }    
            if(recordTypeName == 'User'){
            obj.RelatedListName = customerList[0].Name;
            }
            obj.Name = prevApp.CC_QAppt__Appointment__r.Name;
            obj.Description = prevApp.CC_QAppt__Appointment__r.CC_QAppt__Description__c;
            obj.Status = prevApp.CC_QAppt__Appointment__r.CC_QAppt__Status__c;
            if(prevApp.CC_QAppt__Appointment__r.CC_QAppt__Status__c == 'Upcoming'){
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
            else if(prevApp.CC_QAppt__Appointment__r.Busy_Time__c == true){
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