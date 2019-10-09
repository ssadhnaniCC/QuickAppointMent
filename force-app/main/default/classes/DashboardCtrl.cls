public with sharing class DashboardCtrl{
    
    public List<Appointment__c> appLIst{get;set;}
    public List<Appointment__c> appPastList{get;set;}
    public List<Appointment__c> appByService{get;set;} 
    public List<Participant__c> customerAppointment{get;set;}
    
    public map<string,List<appointment__c>> serviceMap{get;set;}
    public map<string,List<appointment__c>> locationMap{get;set;}
    public map<string,List<appointment__c>> customerMap{get;set;}
    
    public DashboardCtrl(){
        if (Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Status__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible()
            && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible()  && Schema.sObjectType.Service__c.fields.Price__c.isAccessible()
            && Schema.sObjectType.Appointment__c.fields.Discount__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible()
            && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Description__c.isAccessible()
            && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isAccessible()){
                appList = new List<Appointment__c>();
                appLIst = [select name,Status__c,Resource_Service_Alignment__r.Location__c,Resource_Service_Alignment__r.Service__c,Resource_Service_Alignment__r.Service__r.Price__c,Discount__c,
                                           Resource_Service_Alignment__r.Resource_Staff__c,All_Day_Event__c,Description__c,Start_Date_Time__c,End_Date_Time__c
                                           from Appointment__c where DAY_ONLY(Start_Date_Time__c)>=: Date.Today()];
               
               appPastList = new List<Appointment__c>();
               appPastList = [select name,Status__c,Resource_Service_Alignment__r.Location__c,Resource_Service_Alignment__r.Service__c,Resource_Service_Alignment__r.Service__r.Price__c,Discount__c,
                                           Resource_Service_Alignment__r.Resource_Staff__c,All_Day_Event__c,Description__c,Start_Date_Time__c,End_Date_Time__c
                                           from Appointment__c where DAY_ONLY(Start_Date_Time__c) <=: Date.Today()];
              
              appByService = [select name,Status__c,Resource_Service_Alignment__r.Location__c,Resource_Service_Alignment__r.Location__r.street__c,Resource_Service_Alignment__r.Location__r.city__c,Resource_Service_Alignment__r.Service__c,Resource_Service_Alignment__r.Service__r.name,Resource_Service_Alignment__r.Service__r.Price__c,Discount__c,
                                           Resource_Service_Alignment__r.Resource_Staff__c,All_Day_Event__c,Description__c,Start_Date_Time__c,End_Date_Time__c,Resource_Service_Alignment__r.Location__r.name
                                           from Appointment__c where Start_Date_Time__c != null and DAY_ONLY(Start_Date_Time__c) >=: Date.Today()];                        
        }                      
        if(Schema.sObjectType.Participant__c.fields.Participant_Name__c.isAccessible() && Schema.sObjectType.Participant__c.fields.Appointment__c.isAccessible() && Schema.sObjectType.contact.fields.name.isAccessible()){
            customerAppointment =  [select id, Appointment__c, Participant_Name__c,Participant_Name__r.name from Participant__c where appointment__c != null];   
        }
                                   
      serviceMap = new map<string,List<appointment__c>>();
      locationMap = new map<string,List<appointment__c>>();
      
      for(appointment__c app : appByService){
          list<appointment__c> lst=serviceMap.get(app.Resource_Service_Alignment__r.Service__r.name);
          list<appointment__c> lstLoc = locationMap.get(app.Resource_Service_Alignment__r.Location__r.name);
           if(lst==null){
               lst=new list<appointment__c>();                
           }
           if(lstLoc == null){
               lstLoc = new list<appointment__c>();
           }
           lst.add(app);
           lstLoc.add(app);
           serviceMap.put(app.Resource_Service_Alignment__r.Service__r.name,lst);
           locationMap.put(app.Resource_Service_Alignment__r.Location__r.name, lstLoc);
      }
      set<id> setAppPartIds=new set<id>();
      for(Participant__c ap : customerAppointment ){
          setAppPartIds.add(ap.appointment__c);
      } 
      map<id,Appointment__c> mapApps=new map<id,Appointment__c>();
      if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible()){
          for(Appointment__c app: [select id ,name, Start_Date_Time__c from appointment__c where id in :setAppPartIds]){
              mapApps.put(app.id,app);
          }
      }
          
      customerMap  = new map<string,List<appointment__c>>();
      for(Participant__c par: customerAppointment){
          list<appointment__c> lst = customerMap.get(par.Participant_Name__r.name);
           if(lst==null){
               lst=new list<appointment__c>();                
           }
           lst.add(mapApps.get(par.Appointment__c));
         customerMap.put(par.Participant_Name__r.name,lst);
      }
      
    }
}