global with sharing class CalendarCtrl{
    public List<SelectOption> allTimeZones{get;set;}
    public string selectedTimeZone{get;set;}
    public Appointment__c Appointment{get;set;}
    public list<Appointment__c> AppList{get;set;}  
    public boolean hasbooking{get;set;}
    public map<string,list<Appointment__c>> DateAppointmentMap{get;set;}
    public date startDate{get;set;}
    
    public CalendarCtrl(){
        hasbooking = false;
        allTimeZones = fetchAllTimeZone();
        selectedTimeZone =  UserInfo.getTimeZone().getID();
        Appointment = new Appointment__c();
        if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible() ){
            AppList = new List<Appointment__c>();
            DateAppointmentMap = new map<string,list<Appointment__c>>();
            AppList = [select name,Start_Date_Time__c from Appointment__c where Start_Date_Time__c!= null];  
            for(Appointment__c ap: AppList){
               list<Appointment__c> DAppList= DateAppointmentMap.get(ap.Start_Date_Time__c.format('dd/MM/yyyy'));    
               if(DAppList==null){
                   DAppList= new list<Appointment__c>();
               }
               
               DAppList.add(ap);
               DateAppointmentMap.put(ap.Start_Date_Time__c.format('dd/MM/yyyy'),DAppList);
            }
        }
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
    
    public pagereference saveBusyTime(){
        Appointment.Start_Date_Time__c = datetime.newInstanceGmt(Appointment.Start_Date_Time__c.date(),Appointment.Start_Date_Time__c.time());
        Appointment.end_Date_Time__c = datetime.newInstanceGmt(Appointment.end_Date_Time__c.date(),Appointment.end_Date_Time__c.time());
        Appointment.Description__c = 'Busy Time';
        Appointment.busy_time__c = true;
        Appointment.name = 'Busy';
        if(Schema.sObjectType.Appointment__c.fields.name.isCreateable() && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isCreateable() && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isCreateable()
        && Schema.sObjectType.Appointment__c.fields.Busy_Time__c.isCreateable() && Schema.sObjectType.Appointment__c.fields.Status__c.isCreateable() && Schema.sObjectType.Appointment__c.fields.Capacity__c.isCreateable()
        && Schema.sObjectType.Appointment__c.fields.Total_Participants__c.isCreateable() && Schema.sObjectType.Appointment__c.fields.Description__c.isCreateable()){
            insert Appointment;
        }
        return new pagereference('/apex/calendar');
    }
    
    @RemoteAction
    global static string fetchAllAppointmentSlotsJSON(string currentTimezone){
        string StatusUpcoming;
        string StatusRunning;
        string StatusCompleted;
        string StatusDeclined;
        
        boolean appname;
        boolean appdiscription;
        boolean Appstatus;
        boolean AppCapacity;
        
        //get Event color from custome setting
        UIpanel__c UIPanelData = UIpanel__c.getInstance(Userinfo.getUserid());
        StatusUpcoming = UIPanelData.Status_Upcoming__c;
        StatusRunning = UIPanelData.Status_Running__c;
        StatusCompleted = UIPanelData.Status_Completed__c;
        StatusDeclined = UIPanelData.Status_Declined__c;
        
        appname = UIPanelData.Appointment_Name__c;
        appdiscription = UIPanelData.Description__c;
        Appstatus = UIPanelData.Status__c;
        AppCapacity = UIPanelData.Capacity__c;
        
        JSONGenerator g = JSON.createGenerator(true);
        g.writeStartArray();
        if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isAccessible()
        && Schema.sObjectType.Appointment__c.fields.Busy_Time__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Status__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Capacity__c.isAccessible()
        && Schema.sObjectType.Appointment__c.fields.Total_Participants__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Description__c.isAccessible()){
            List<Appointment__c> appList = [select id,name,Start_Date_Time__c,End_Date_Time__c,Busy_Time__c,Status__c,Capacity__c,Total_Participants__c,Description__c from Appointment__c where Start_Date_Time__c != null];
            Map<string,list<Appointment__c>> mapEvents = new Map<string,list<Appointment__c>>();
            for( Appointment__c appObj : appList ){
                list<Appointment__c> lstApp ;
                if(mapEvents.get(appObj.Start_Date_Time__c +':'+ appObj.End_Date_Time__c) != null ){
                    lstApp = mapEvents.get(appObj.Start_Date_Time__c +':'+ appObj.End_Date_Time__c);
                }else{
                    lstApp = new list<Appointment__c>();
                }
                lstApp.add(appObj);
                mapEvents.put(appObj.Start_Date_Time__c +':'+ appObj.End_Date_Time__c,lstApp);
            }
        
        
        for( String strKey : mapEvents.keySet() ){
            list<Appointment__c> lstApp = mapEvents.get(strKey);            
            Datetime StartGMTDate =  lstApp[0].Start_Date_Time__c;
            Datetime EndGMTDate =  lstApp[0].End_Date_Time__c;  
            String appIds = '';    
            string comma = '';                  
            for( Appointment__c appObj : lstApp ){
                appIds += comma + appObj.id;
                comma = ',';
            }
            string name = '';
            string discrip = '';
            string status = '';
            string capacity ='';
            string newLine = '';
            
            for( Appointment__c appObj : lstApp ){
                name += newLine + appObj.name;
                discrip += newLine + appObj.Description__c;
                status += newLine + appObj.status__c;
                capacity += newLine + appObj.capacity__c; 
                 newLine = ' , ';
            }
                        
            g.writeStartObject();
            g.writeStringField('id', appIds);            
            g.writeStringField('title','Appointments= ('+lstApp.size()+')');
            
            if(appname == true){
                g.writeStringField('Name','Name= '+name + ' ');
            }else{
                g.writeStringField('Name','');
            }            
            if(appdiscription == true){
                g.writeStringField('Description','Description= '+discrip +' ');
            }else{
                g.writeStringField('Description','');
            }if(Appstatus == true){
                g.writeStringField('Status','Status= '+status+' ');
            }else{
                 g.writeStringField('Status','');
            }if(AppCapacity == true){
                g.writeStringField('Capacity','Capacity= '+capacity +' ');
            }else{
                g.writeStringField('Capacity','');
            }
            System.debug('g :'+g);        
            System.debug('----start date'+ StartGMTDate.format());
            System.debug('----end date'+ EndGMTDate);
            g.writeStringField('start', StartGMTDate.format('MM/dd/yyyy HH:mm:ss') +'');
            g.writeStringField('end', EndGMTDate.format('MM/dd/yyyy HH:mm:ss')+ '' );
            
            for(Appointment__c ap : lstApp){
                if(ap.Status__c == 'Upcoming'){
                    g.writeStringField('eventColor',StatusUpcoming);
                }else if(ap.Status__c == 'Running'){
                    g.writeStringField('eventColor',StatusRunning);
                }else if(ap.Status__c == 'Completed'){
                    g.writeStringField('eventColor',StatusCompleted);
                }else if(ap.Status__c == 'Declined'){
                    g.writeStringField('eventColor',StatusDeclined);
                }else if(ap.Busy_Time__c == true){
                    g.writeStringField('eventColor','red');
                }
            }
            g.writeEndObject();
            
        }
        }
        g.writeEndArray();
        String strtemp = g.getAsString(); 
        System.debug('strtemp  : '+strtemp );       
        strtemp = strtemp.replaceAll('\'','');
        System.debug('strtemp  : '+strtemp );
        return strtemp;
        
    }
    public void searchAgenda(){
    
        AppList = new List<Appointment__c>();
        DateAppointmentMap = new map<string,list<Appointment__c>>();
        if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible() ){
            AppList = [select name,Start_Date_Time__c from Appointment__c where  DAY_ONLY(Start_Date_Time__c) =: startDate];
            if(AppList.size()==0){
              hasbooking = true;
            }
            for(Appointment__c ap: AppList){
               list<Appointment__c> DAppList= DateAppointmentMap.get(ap.Start_Date_Time__c.format('dd/MM/yyyy'));    
               if(DAppList==null){
                   DAppList= new list<Appointment__c>();
               }
               DAppList.add(ap);
               DateAppointmentMap.put(ap.Start_Date_Time__c.format('dd/MM/yyyy'),DAppList);
            }
        }
        
    }
    public void closeAgenda(){
       hasbooking = false;
       startDate = null;
        AppList = new List<Appointment__c>();
        DateAppointmentMap = new map<string,list<Appointment__c>>();
        if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible() ){
            AppList = [select name,Start_Date_Time__c from Appointment__c];
            if(AppList.size()==0){
              hasbooking = true;
            }
            for(Appointment__c ap: AppList){
               list<Appointment__c> DAppList= DateAppointmentMap.get(ap.Start_Date_Time__c.format('dd/MM/yyyy'));    
               if(DAppList==null){
                   DAppList= new list<Appointment__c>();
               }
               DAppList.add(ap);
               DateAppointmentMap.put(ap.Start_Date_Time__c.format('dd/MM/yyyy'),DAppList);
            }
        }
        
    }
}