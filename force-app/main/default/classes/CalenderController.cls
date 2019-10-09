public with sharing class CalenderController{
    public List<SelectOption> allTimeZones{get;set;}
    public string selectedTimeZone{get;set;}
    
    public CalenderController(){
        allTimeZones = fetchAllTimeZone();
        selectedTimeZone =  UserInfo.getTimeZone().getID();
    }
    
    public List<SelectOption> fetchAllTimeZone(){
        List<SelectOption> timeZonePickList = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getdescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            timeZonePickList.add(new SelectOption(p.getValue(),p.getlabel()));      
        }
        return timeZonePickList;
    } 
    
    @RemoteAction
    public static string fetchAllAppointmentSlotsJSON(string currentTimezone){
        JSONGenerator g = JSON.createGenerator(true);
        g.writeStartArray();
        List<Appointment__c> appList = [select id,name,Start_Date_Time__c,End_Date_Time__c,Busy_Time__c,Description__c from Appointment__c where Start_Date_Time__c != null];
        for( Appointment__c appObj : appList ){
            Datetime StartGMTDate =  appObj.Start_Date_Time__c;
            Datetime EndGMTDate =  appObj.End_Date_Time__c;
            
            g.writeStartObject();
            g.writeStringField('id', appObj.id);
            g.writeStringField('title', appObj.Description__c);
            g.writeStringField('start', StartGMTDate.format('MM/dd/yyyy HH:mm:ss',currentTimezone) );
            g.writeStringField('end', EndGMTDate.format('MM/dd/yyyy HH:mm:ss',currentTimezone) );
            if( appObj.Busy_Time__c ){
                g.writeStringField('eventColor','red');
            }else{
                g.writeStringField('eventColor','blue');
            }
            g.writeEndObject();
        }
        g.writeEndArray();
        String strtemp = g.getAsString();        
        strtemp = strtemp.replaceAll('\'','');
        

        return strtemp;
    }
}