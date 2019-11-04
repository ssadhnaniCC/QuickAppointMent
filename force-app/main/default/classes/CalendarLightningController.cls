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
    public static List<calendarWrapper> fetchAppointments(){
        List<calendarWrapper> calWrapp = new List<calendarWrapper>();
        //Get User Time Zone
        TimeZone tz = UserInfo.getTimeZone();
        String currentTimeZone =  tz.getID();
        //get Event color from custome setting
        UIpanel__c UIPanelData = UIpanel__c.getInstance(Userinfo.getUserid());
        String  StatusUpcoming = UIPanelData.Status_Upcoming__c;
        String  StatusRunning = UIPanelData.Status_Running__c;
        String  StatusCompleted = UIPanelData.Status_Completed__c;
        String  StatusDeclined = UIPanelData.Status_Declined__c;
        List<CC_QAppt__Appointment__c> previousAppointments  = QuickAppointmentSOQLManager.getPreviousAppointments();
        for(CC_QAppt__Appointment__c prevApp : previousAppointments){
            calendarWrapper obj = new calendarWrapper();
            obj.Id = prevApp.Id;
            obj.startDate = prevApp.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy HH:mm:ss',currentTimeZone);
            obj.endDate = prevApp.CC_QAppt__End_Date_Time__c.format('MM/dd/yyyy HH:mm:ss',currentTimeZone);
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
        @AuraEnabled   public String Description;
        @AuraEnabled   public String Status;
        @AuraEnabled   public String eventColor; 
    }
}