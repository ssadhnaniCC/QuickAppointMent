public with sharing class AppointmentCtrl{
    public string selectedLocation{get;set;}
    public string selectedService{get;set;}
    public string selectedProvider{get;set;}
    public Map<string,Location__c> LocationMap {get;set;}
    public Map<string,service__c> serviceMap {get;set;}
    public Map<string,contact> providerMap {get;set;}
    public List<Resource_Service_Alignment__c> resourceAlignmentList{get;set;}
    public Appointment__c Appointment{get;set;}
    public Appointment__c newAppointment{get;set;}
    public boolean containts{get;set;}
    public List<Appointment__c> appList{get;set;}
    public string appId{get;set;}
    public string DateUrl{get;set;}
    public string TimeUrl{get;set;}
    public string withoutId{get;set;}
    public boolean errorDiv{get;set;}
    public boolean warningDiv{get;set;}
    public boolean NameShowHide{get;set;}
    public boolean checkDobuleBooking{get;set;}
    public boolean cloneButtonShowHide{get;set;}
    public UIpanel__c UIPanelData{get;set;}
    
    public boolean ResourceStaffDesable{get;set;}
    public boolean multipleIds{get;set;}
    public List<Appointment__c> AppMultipleList{get;set;}
    public string SelectedApppointmentId{get;set;}
    public boolean fromCloneButton{get;set;}
    public boolean containtselement{get;set;}
    public Appointment__c cloneApp {get;set;}
    
    // Variables for insert start datetime and end datetime
    public string startDate{get;set;}
    public string startTime{get;set;}
    public integer duration{get;set;}
    public decimal CapacityofParticapent {get;set;}
    public decimal discount{get;set;}
    public decimal totalprice{get;set;}
    
    // varibles for customer
    public List<contact> participantList {get;set;}
    public List<ContactUserModel> ContactUser{get;set;}
    public List<Participant__c> ParticipantInsertedList{get;set;}
    public boolean ParticipantPanel{get;set;}
    public List<ContactUserModel> addedParticipantList{get;set;}
    public string removeId{get;set;}
    public string NameSearch{get;set;}
    public contact con{get;set;}
    
    // controller
    public AppointmentCtrl(){
        containts = true;
        containtselement= false;
        cloneButtonShowHide = false;
        NameShowHide = true;
        errorDiv = false;
        warningDiv = false;
        ResourceStaffDesable = true;
        fromCloneButton =  false;
        Appointment = new Appointment__c();
        newAppointment = new Appointment__c();
        appList = new List<Appointment__c>();
        
        con = new contact();
        appList = new List<Appointment__c>();
        if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isAccessible()
           && Schema.sObjectType.Appointment__c.fields.Busy_Time__c.isAccessible()){
               appList = [select id,name,Start_Date_Time__c,End_Date_Time__c,Busy_Time__c from Appointment__c where Start_Date_Time__c = THIS_MONTH];
           }
        
        resourceAlignmentList = new List<Resource_Service_Alignment__c>();
        if(Schema.sObjectType.Resource_Service_Alignment__c.fields.name.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible() && Schema.sObjectType.Service__c.fields.name.isAccessible()
           && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.contact.fields.name.isAccessible()
           && Schema.sObjectType.Resource_Service_Alignment__c.fields.location__c.isAccessible() && Schema.sObjectType.Location__c.fields.name.isAccessible() && Schema.sObjectType.Location__c.fields.Street__c.isAccessible() && Schema.sObjectType.Location__c.fields.Country__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.City__c.isAccessible() && Schema.sObjectType.Location__c.fields.Postal_Code__c.isAccessible()){
               resourceAlignmentList = [select name,Service__r.name,Resource_Staff__r.name,location__c,Location__r.Street__c,Location__r.City__c,
                                        Location__r.State__c,Location__r.Country__c,location__r.Postal_Code__c
                                        from Resource_Service_Alignment__c where location__c != null];
           }
        fetchLocation();
        
        
        multipleIds = false;
        
        appId = ApexPages.currentPage().getParameters().get('id'); 
        DateUrl = ApexPages.currentPage().getParameters().get('date');
        TimeUrl = ApexPages.currentPage().getParameters().get('time');
        
        if(appId != '' && appId!=null){
            if(appId.contains(',')){
                multipleIds = true;
                List<string> appIdsSet = new List<string>();
                appIdsSet = appId.split(',');
                
                System.debug('---'+appIdsSet);
                AppMultipleList = new List<Appointment__c>();
                if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Status__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible()
                   && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Description__c.isAccessible()){
                       AppMultipleList = [select name,Status__c,Resource_Service_Alignment__c,All_Day_Event__c,Description__c  from Appointment__c where id IN: appIdsSet];  
                   }
                
                newAppointment = getAppBasedOnId(appIdsSet[0]);
                if(newAppointment.name != 'Busy'){
                    AppData();
                    showInsertedParticipent(appIdsSet[0]);
                }
            }else{
                newAppointment = getAppBasedOnId(appId);
                if(newAppointment.name != 'Busy'){
                    AppData();
                    showInsertedParticipent(appId);
                }
            }
            cloneButtonShowHide = true;
        }else{    
            NameShowHide = false;    
            ParticipantPanel = true;
            newAppointment.Status__c = 'Upcoming';
            startDate = DateUrl;
            startTime = TimeUrl;
            
        }
        
        UIPanelData = UIpanel__c.getInstance(Userinfo.getUserid());
        checkDobuleBooking = UIPanelData.dobule_booking__c;
    }
    
    private Appointment__c getAppBasedOnId(string appId){
        if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Status__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible()
           && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Description__c.isAccessible()
           && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible()
           && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible() && Schema.sObjectType.Service__c.fields.Price__c.isAccessible() && Schema.sObjectType.Service__c.fields.Duration__c.isAccessible()
           && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Discount__c.isAccessible()
           && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible()&& Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isAccessible()){
               return [select name,Status__c,Resource_Service_Alignment__r.Location__c,Resource_Service_Alignment__r.Service__c,Resource_Service_Alignment__r.Service__r.Price__c,Resource_Service_Alignment__r.Service__r.Duration__c,Discount__c,
                       Resource_Service_Alignment__r.Resource_Staff__c,All_Day_Event__c,Description__c,Start_Date_Time__c,End_Date_Time__c
                       from Appointment__c where id =: appId];
           }
        return null;
    }
    private void AppData(){
        selectedLocation = newAppointment.Resource_Service_Alignment__r.Location__c;
        fetchServiceBasedOnLocation();
        selectedService  =  newAppointment.Resource_Service_Alignment__r.Service__c;  
        fetchProviderBasedOnService();       
        selectedProvider = newAppointment.Resource_Service_Alignment__r.Resource_Staff__c; 
        
        System.debug(selectedLocation);
        System.debug(selectedService);
        
        List<string> sDateTime = new List<string>();
        List<string> eDateTime = new List<string>();
        
        sDateTime = string.valueOf(newAppointment.Start_Date_Time__c).split(' ');
        eDateTime = string.valueOf(newAppointment.End_Date_Time__c).split(' ');
        // List<string> splitDate = sDateTime[0].split('/');
        startDate = sDateTime[0];
        startTime = sDateTime[1];
        duration =  Integer.valueOf(((newAppointment.End_Date_Time__c).getTime() - (newAppointment.Start_Date_Time__c).getTime())/(1000*60));
        
        getDiscount();
        if(newAppointment.id != null){
            ParticipantPanel = true;
        }
    }
    public void SelectedAppointment(){
        newAppointment = getAppBasedOnId(SelectedApppointmentId);
        AppData();
        //getDiscount();
        showInsertedParticipent(SelectedApppointmentId);
        
    }
    //method to get all loction and put into map
    private void fetchLocation(){
        LocationMap = new Map<string,Location__c>();
        if(Schema.sObjectType.Location__c.fields.name.isAccessible() && Schema.sObjectType.Location__c.fields.Street__c.isAccessible() && Schema.sObjectType.Location__c.fields.Country__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.City__c.isAccessible() && Schema.sObjectType.Location__c.fields.Postal_Code__c.isAccessible()){
               for(Location__c ali: [select name,street__c,city__c,state__c,country__c,postal_code__c from location__c where  Id != null]){
                   if(ali.id != null){
                       Location__c loc = new Location__c();
                       loc.id = ali.id;
                       loc.name = ali.name;
                       loc.street__c = ali.street__c;
                       loc.city__c = ali.city__c;
                       loc.State__c = ali.State__c;
                       loc.country__c = ali.country__c;
                       loc.Postal_Code__c = ali.Postal_Code__c;
                       LocationMap.put(ali.id, loc);
                   }
               }
           }
    }
    
    public void fetchServiceBasedOnLocation(){
        errorDiv = false;
        serviceMap = new Map<string,service__c>();
        if(selectedLocation != null){
            if(Schema.sObjectType.Resource_Service_Alignment__c.fields.name.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible() && Schema.sObjectType.Service__c.fields.Price__c.isAccessible() && Schema.sObjectType.Service__c.fields.Duration__c.isAccessible()
               && Schema.sObjectType.Service__c.fields.name.isAccessible()
               && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.contact.fields.name.isAccessible()
               && Schema.sObjectType.Resource_Service_Alignment__c.fields.location__c.isAccessible() && Schema.sObjectType.location__c.fields.Street__c.isAccessible() && Schema.sObjectType.location__c.fields.City__c.isAccessible() 
               && Schema.sObjectType.location__c.fields.State__c.isAccessible() && Schema.sObjectType.location__c.fields.Country__c.isAccessible() && Schema.sObjectType.location__c.fields.Postal_Code__c.isAccessible()){
                   for(Resource_Service_Alignment__c ali: [select name,Service__r.name,service__r.price__c,Service__r.Duration__c,Resource_Staff__r.name,location__c,Location__r.Street__c,Location__r.City__c,
                                                           Location__r.State__c,Location__r.Country__c,location__r.Postal_Code__c,Resource_Staff__c,Resource_Staff__r.Capacity__c
                                                           from Resource_Service_Alignment__c where location__c =: selectedLocation]){
                                                               if(ali.service__c != null){    
                                                                   service__c ser = new service__c ();
                                                                   ser.id = ali.service__c;
                                                                   ser.name = ali.service__r.name;
                                                                   ser.Price__c  = ali.service__r.price__c;
                                                                   ser.Duration__c = ali.service__r.Duration__c;
                                                                   serviceMap.put(ali.service__c, ser);
                                                               }                                                              
                                                           }
               }
            if(serviceMap.size() == 0){            
                providerMap = new Map<string,contact>();           
                errorDiv = true;
                ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'There is no service for selected location');
                ApexPages.addMessage(requirereasonMessage);
            }
        }
    }
    
    public void fetchProviderBasedOnService(){
        ResourceStaffDesable = false;
        providerMap = new Map<string,contact>();
        if(selectedService != null){
            if(Schema.sObjectType.Resource_Service_Alignment__c.fields.name.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible()
               && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.Capacity__c.isAccessible()){
                   for(Resource_Service_Alignment__c ali: [select name,Service__c,Resource_Staff__c,Resource_Staff__r.name,Resource_Staff__r.Capacity__c from Resource_Service_Alignment__c where Service__c =: selectedService]){
                       if(ali.Resource_Staff__c != null){
                           contact con = new contact();
                           con.id = ali.Resource_Staff__c;
                           con.lastname = ali.Resource_Staff__r.name;
                           con.Capacity__c = ali.Resource_Staff__r.Capacity__c;
                           providerMap.put(ali.Resource_Staff__c,con);
                       }
                   } 
               }
        }
    }
    
    public List<SelectOption> getLocationList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(' ','-Select Location-'));
        for(string str: LocationMap.keyset()){
            
            options.add(new SelectOption(str,LocationMap.get(str).name));
        }                 
        return options;
    }
    
    public List<SelectOption> getServiceList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(' ','-Select Service-'));
        if(serviceMap != null){
            for(string str: serviceMap.keyset()){
                if(serviceMap.containskey(str)){
                    options.add(new SelectOption(str,serviceMap.get(str).name));
                }
            }
        }
        
        return options;
    }
    public List<SelectOption> getProviderList(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption(' ','Resource/Staff'));
        if(providerMap != null){
            for(string str: providerMap.keyset()){
                if(providerMap.containsKey(str)){
                    options.add(new SelectOption(str,providerMap.get(str).lastname));
                }
            } 
        }
        return options;
    }
    
    /*public decimal getCapacity(){
if(selectedProvider != null){
return providerMap.get(selectedProvider).Capacity__c;
}else{
return 0;
}
}*/
    
    public decimal getPriceBasedOnService(){
        if(selectedService != null){
            if(serviceMap != null && serviceMap.containskey(selectedService)){
                return serviceMap.get(selectedService).Price__c;
            }
            else{
                return 0;
            }
        }else{
            return 0;
        }
    }
    public Integer getServiceDuration(){
        if(selectedService != null){
            //system.debug('servicemap'+serviceMap);
            // system.debug('servicemapduration'+serviceMap.get(selectedService).duration__c);
            if(serviceMap != null && serviceMap.containsKey(selectedService)){ 
                return Integer.valueOf(serviceMap.get(selectedService).duration__c);
            }
            else{
                return 0;
            }
        }else{
            return 0;
        }
    }
    
    public void getDiscount(){
        if(serviceMap != null && serviceMap.containskey(selectedService)){
            if(selectedService != null  && newAppointment.Discount__c != null){
                errorDiv = false;  
                if(serviceMap.get(selectedService).Price__c >0 && (newAppointment.Discount__c>=0 && newAppointment.Discount__c<=100 )){
                    totalprice = ((serviceMap.get(selectedService).Price__c) - Integer.valueOf(((serviceMap.get(selectedService).Price__c) * (newAppointment.Discount__c)/100)));
                } 
                else{
                    errorDiv = true;  
                    ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Please Enter Valid Value for Discount/Price'));
                    //  ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Discount/Price cant be negative');
                    //  ApexPages.addMessage(requirereasonMessage);
                    totalprice = (serviceMap.get(selectedService).Price__c);
                }
            }else{
                totalprice = serviceMap.get(selectedService).Price__c;
            }
        }
        else{
            totalprice = 0;
        }
    }
    
    public decimal getTotalPrice(){
        if(totalprice != null){
            return totalprice;
        }else{
            return 0;
        }            
    }
    
    public PageReference  saveAppointment(){
        errorDiv = false;
        if(selectedLocation == ' ' || selectedLocation == null){
            errorDiv = true;  
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Select location');
            ApexPages.addMessage(requirereasonMessage);
            return null;     
        }else if(selectedService == ' ' || selectedService == null){
            errorDiv = true;  
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please select  service.');
            ApexPages.addMessage(requirereasonMessage);
            return null;
        }else if(selectedProvider == ' ' || selectedProvider == null){
            errorDiv = true;  
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Select resource/staff');
            ApexPages.addMessage(requirereasonMessage);
            return null;
        }else if(startDate  == '' || startDate == null){
            errorDiv = true;  
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Select Date');
            ApexPages.addMessage(requirereasonMessage);
            return null;
        }else if(startTime == '' || startTime == null){
            errorDiv = true;  
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Select Time');
            ApexPages.addMessage(requirereasonMessage);
            return null;
        }
        else if(newAppointment.Discount__c < 0){
            errorDiv = true;  
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Discount should be between 0 to 100');
            ApexPages.addMessage(requirereasonMessage);
            return null;
        }
        else if(newAppointment.status__c != 'Upcoming'){
            Date todaydate = System.now().date();   
            String start;      
            if(startDate.contains('/')){
                start = startDate.replaceAll('/','-');
            }       
            else{
                start = startDate;
            }
            list<string> dtList = start.split('-');
            system.debug('datelist'+dtList);
            date startdt = Date.newInstance(Integer.valueOf(dtList[0]),Integer.valueOf(dtList[1]),Integer.valueOf(dtList[2].trim()));
            system.debug('startdate'+startdt.format());
            system.debug('todaydates'+todaydate.format());                       
            if(startdt.format() > todaydate.format()){
                //       system.debug('Greaterdate');
                errorDiv = true;
                ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'For future date please choose upcoming as status');
                ApexPages.addMessage(requirereasonMessage);
                return null;
            }          
        }
        else{
            errorDiv = false;
        }
        
        
        if(errorDiv  == false){
            System.debug('save duration---'+duration);
            list<string> timeList = startTime.split(':');
            string getTime = timeList[0].trim()+':'+timeList[1].trim()+' '+timeList[2].trim();
            String start;      
            if(startDate.contains('/')){
                start = startDate.replaceAll('/','-');
            }       
            else{
                start = startDate;
            }           
            list<string> dtList = start.split('-');
            System.debug('dtList -- '+dtList);
            // System.debug('dtList[0] -- '+dtList[0]);
            //  System.debug('dtList[2] -- '+dtList[1]);
            //System.debug('dtList[2] -- '+dtList[2]);
            
            // System.debug('dtList[0] -- '+Integer.valueOf(dtList[0]));
            // System.debug('dtList[2] -- '+Integer.valueOf(dtList[1]));
            // System.debug('dtList[2] -- '+Integer.valueOf(dtList[2].trim()));
            
            date startdt = Date.newInstance(Integer.valueOf(dtList[0]),Integer.valueOf(dtList[1]),Integer.valueOf(dtList[2].trim()));
            
            System.debug('startdt --> '+startdt);
            
            Time myTime = Time.newInstance(Integer.valueOf(timeList[0].trim()),Integer.valueOf(timeList[1].trim()),0,0);
            
            newAppointment.Start_Date_Time__c = datetime.newInstance(startdt,myTime);
            newAppointment.end_Date_Time__c = datetime.newInstance(startdt,myTime).addMinutes(duration);
            if(serviceMap.containsKey(selectedService) && providerMap.containsKey(selectedProvider) && LocationMap.containsKey(selectedLocation))   {         
                newAppointment.name = serviceMap.get(selectedService).name +'---'+ providerMap.get(selectedProvider).lastname+'---'+ LocationMap.get(selectedLocation).name ;
            }
            
            Resource_Service_Alignment__c alignment = new Resource_Service_Alignment__c();
            
            if(Schema.sObjectType.Resource_Service_Alignment__c.fields.name.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible()
               && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.location__c.isAccessible() ){
                   try{
                       alignment = [select id,name,location__c,service__c,Resource_Staff__c from Resource_Service_Alignment__c where service__c =: selectedService and Resource_Staff__c =: selectedProvider and location__c =: selectedLocation];
                   }
                   catch(Exception e){                       
                   }
                   if(alignment != null){
                       newAppointment.Resource_Service_Alignment__c = alignment.id;
                   }
               }
            
            
            if(fromCloneButton == true){
                if(checkDobuleBooking == false){
                    if (Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Status__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible()
                        && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible()  && Schema.sObjectType.Service__c.fields.Price__c.isAccessible()
                        && Schema.sObjectType.Appointment__c.fields.Discount__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible()
                        && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Description__c.isAccessible()
                        && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.location__c.isAccessible()){
                            
                            for(appointment__c app: [select name,Resource_Service_Alignment__c,Resource_Service_Alignment__r.Location__c,Resource_Service_Alignment__r.Service__c,
                                                     Resource_Service_Alignment__r.Resource_Staff__c,Start_Date_Time__c,End_Date_Time__c
                                                     from Appointment__c where Resource_Service_Alignment__c != null]){
                                                         if(selectedProvider == app.Resource_Service_Alignment__r.Resource_Staff__c && newAppointment.Start_Date_Time__c == app.Start_Date_Time__c){
                                                             errorDiv = true;
                                                             ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Dobule Booking is not allow');
                                                             ApexPages.addMessage(requirereasonMessage);
                                                             
                                                         }
                                                     }
                        }
                }else{
                    cloneApp = newAppointment.clone(false,false,false,false);
                    if(Schema.sObjectType.Appointment__c.fields.name.isCreateable() && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isCreateable() && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isCreateable()
                       && Schema.sObjectType.Appointment__c.fields.Busy_Time__c.isCreateable() && Schema.sObjectType.Appointment__c.fields.Status__c.isCreateable() && Schema.sObjectType.Appointment__c.fields.Capacity__c.isCreateable()
                       && Schema.sObjectType.Appointment__c.fields.Total_Participants__c.isCreateable() && Schema.sObjectType.Appointment__c.fields.Description__c.isCreateable()){
                           insert cloneApp;
                       }
                    
                    List<Participant__c> PList = new List<Participant__c>();
                    if(addedParticipantList != null){
                        for(ContactUserModel cModel: addedParticipantList){
                            if(cModel.isCheck == true ){
                                Participant__c p = new Participant__c();
                                p.Participant_Name__c = cModel.con.id;
                                p.Appointment__c = cloneApp.id;
                                PList.add(p);
                            }
                        }
                    }
                    List<Participant__c> tempDelete = new List<Participant__c>();
                    if (Schema.sObjectType.Participant__c.fields.Participant_Name__c.isAccessible() && Schema.sObjectType.Participant__c.fields.Appointment__c.isAccessible()){
                        tempDelete = [select Participant_Name__c,Appointment__c from Participant__c where Appointment__c =: cloneApp.id];
                    }
                    
                    if(tempDelete.size()>0){
                        if(Participant__c.sObjectType.getDescribe().isDeletable()){
                            delete tempDelete;
                        }
                    }
                    
                    
                    if(PList.size()>0){
                        if ((Schema.sObjectType.Participant__c.fields.Participant_Name__c.isCreateable() && Schema.sObjectType.Participant__c.fields.Appointment__c.isCreateable()) 
                            && (Schema.sObjectType.Participant__c.fields.Participant_Name__c.isUpdateable() && Schema.sObjectType.Participant__c.fields.Appointment__c.isUpdateable())){
                                upsert PList;
                            }
                    }
                    if(cloneApp.id != null){
                        ParticipantPanel = true;
                        showInsertedParticipent(cloneApp.id);
                    }
                    Notification__c noti = new Notification__c();
                    noti.Contact__c = selectedProvider;
                    noti.Description__c = 'Appointment is created on' + cloneApp.Start_Date_Time__c.format('MM/dd/yyyy h:mm a');
                    noti.Appointment__c  = cloneApp.id;
                    if(Schema.sObjectType.Notification__c.fields.view__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Contact__c.isCreateable()
                       && Schema.sObjectType.Notification__c.fields.read__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Description__c.isCreateable()){
                           insert noti;
                       }
                }
            }else{
                
                if ((Schema.sObjectType.Appointment__c.fields.name.isCreateable() 
                     && Schema.sObjectType.Appointment__c.fields.Status__c.isCreateable() 
                     && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isCreateable() 
                     && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isCreateable()
                     && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isCreateable()  
                     && Schema.sObjectType.Service__c.fields.Price__c.isCreateable()
                     && Schema.sObjectType.Appointment__c.fields.Discount__c.isCreateable() 
                     && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isCreateable()
                     && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isCreateable() 
                     && Schema.sObjectType.Appointment__c.fields.Description__c.isCreateable()
                     && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isCreateable() 
                     && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isCreateable() 
                     && Schema.sObjectType.Resource_Service_Alignment__c.fields.location__c.isCreateable())
                    &&(Schema.sObjectType.Appointment__c.fields.name.isUpdateable() 
                       && Schema.sObjectType.Appointment__c.fields.Status__c.isUpdateable() 
                       && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isUpdateable() 
                       && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isUpdateable()
                       
                       && Schema.sObjectType.Service__c.fields.Price__c.isUpdateable()
                       && Schema.sObjectType.Appointment__c.fields.Discount__c.isUpdateable() 
                       
                       && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isUpdateable() 
                       && Schema.sObjectType.Appointment__c.fields.Description__c.isUpdateable()
                       && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isUpdateable() 
                       && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isUpdateable() 
                       && Schema.sObjectType.Resource_Service_Alignment__c.fields.location__c.isUpdateable())){
                           try{ 
                               upsert newAppointment;
                           }
                           catch(Exception e){
                               
                           }
                           
                       }
                system.debug('i m out');
                Notification__c noti = new Notification__c();
                noti.Contact__c = selectedProvider;
                noti.Description__c = 'Appointment is created on' + newAppointment.Start_Date_Time__c.format('MM/dd/yyyy h:mm a');
                noti.Appointment__c  = newAppointment.id;
                if(Schema.sObjectType.Notification__c.fields.view__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Contact__c.isCreateable()
                   && Schema.sObjectType.Notification__c.fields.read__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Description__c.isCreateable()){
                       insert noti;
                   }
            }
            
            
            List<Participant__c> PList = new List<Participant__c>();
            if(addedParticipantList != null){
                for(ContactUserModel cModel: addedParticipantList){
                    if(cModel.isCheck == true ){
                        Participant__c p = new Participant__c();
                        p.Participant_Name__c = cModel.con.id;
                        p.Appointment__c = newAppointment.id;
                        PList.add(p);
                    }
                }
            }
            List<Participant__c> tempListDelete = new List<Participant__c>();
            if (Schema.sObjectType.Participant__c.fields.Participant_Name__c.isAccessible() && Schema.sObjectType.Participant__c.fields.Appointment__c.isAccessible()){
                tempListDelete =   [select Participant_Name__c,Appointment__c from Participant__c where Appointment__c =: newAppointment.id];
            }
            
            if(tempListDelete.size()>0){
                if(Participant__c.sObjectType.getDescribe().isDeletable()){
                    delete tempListDelete;
                }
            }
            if(PList.size()>0){
                System.debug('----Particpent'+ Plist);
                if ((Schema.sObjectType.Participant__c.fields.Participant_Name__c.isCreateable() && Schema.sObjectType.Participant__c.fields.Appointment__c.isCreateable()) ){
                    
                    insert PList;
                }
            }
            
            if(newAppointment.id != null){
                ParticipantPanel = true;
                showInsertedParticipent(newAppointment.id);
            }
        }
        return null;
    }
    
    public PageReference  cloneExistingRecord(){
        
        
        cloneApp = newAppointment.clone(false,false,false,false);
        errorDiv=false;
        
        System.debug('---- in  clone method'+cloneApp);
        list<string> timeList = startTime.split(':');
        string getTime = timeList[0].trim()+':'+timeList[1].trim()+' '+timeList[2].trim();
        
        list<string> dtList = startDate.split('-');
        date startdt = Date.newInstance(Integer.valueOf(dtList[0]),Integer.valueOf(dtList[1]),Integer.valueOf(dtList[2]));
        Time myTime = Time.newInstance(Integer.valueOf(timeList[0].trim()),Integer.valueOf(timeList[1].trim()),0,0);
        
        
        cloneApp.Start_Date_Time__c = datetime.newInstance(startdt,myTime);
        cloneApp.end_Date_Time__c = datetime.newInstance(startdt,myTime).addMinutes(duration);
        if(selectedService == ' ' || selectedService == null){
            
            errorDiv = true;  
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please select  service.');
            ApexPages.addMessage(requirereasonMessage);
            return null;
            
        }
        
        if(selectedProvider == ' ' || selectedProvider == null){
            errorDiv = true;  
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Select resource/staff');
            ApexPages.addMessage(requirereasonMessage);
            return null;
        }
        
        if(checkDobuleBooking == false){
            for(appointment__c app: [select name,Resource_Service_Alignment__c,Resource_Service_Alignment__r.Location__c,Resource_Service_Alignment__r.Service__c,
                                     Resource_Service_Alignment__r.Resource_Staff__c,Start_Date_Time__c,End_Date_Time__c
                                     from Appointment__c where Resource_Service_Alignment__c != null]){
                                         
                                         if(selectedProvider == app.Resource_Service_Alignment__r.Resource_Staff__c && newAppointment.Start_Date_Time__c == app.Start_Date_Time__c){
                                             errorDiv = true;
                                             
                                             ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Dobule Booking is not allow');
                                             ApexPages.addMessage(requirereasonMessage);
                                             
                                         }
                                     }
        }
        
        
        if(errorDiv == false){
            cloneButtonShowHide = false;
            fromCloneButton = true;
            insert cloneApp;
            Notification__c noti = new Notification__c();
            noti.Contact__c = selectedProvider;
            noti.Description__c = 'Appointment is created on' + newAppointment.Start_Date_Time__c.format('EEE, MMM d yyyy h:mm a');
            noti.Appointment__c  = newAppointment.id;
            insert noti;
            return null;
            //return new pagereference('/apex/calendar');
        }
        return null;
    }
    
    //show inserted participant list for this appointment
    private void showInsertedParticipent(string appId){
        addedParticipantList = new List<ContactUserModel>();
        List<Participant__c> ParticipantInserted = new List<Participant__c>();
        if(appId != null){
            if (Schema.sObjectType.Participant__c.fields.Participant_Name__c.isAccessible() && Schema.sObjectType.Participant__c.fields.Appointment__c.isAccessible()){ 
                ParticipantInserted = [select Participant_Name__c,Appointment__c from Participant__c where Appointment__c =: appId];
            }
        }
        for(Participant__c  p : ParticipantInserted){
            ContactUserModel CU = new ContactUserModel();
            if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.Capacity__c.isAccessible()
               && Schema.sObjectType.contact.fields.email.isAccessible() && Schema.sObjectType.contact.fields.Level__c.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
               && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
               && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.Description .isAccessible()){
                   CU.con = [select name,email,phone,RecordType.Name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode,Description from contact where id =: p.Participant_Name__c];
               }
            CU.isCheck=true;
            addedParticipantList.add(CU);
        }
    }
    
    // fetch Participant (Contact of users)
    public void fetchParticipant(){  
        containts = true; 
        warningDiv = false;
        ContactUser = new List<ContactUserModel>();
        set<string> insertedParticipentContactIds = new set<string>();
        
        if(addedParticipantList != null){
            for(ContactUserModel cModel: addedParticipantList){
                insertedParticipentContactIds.add(cModel.con.id);
            } 
        }
        
        
        participantList = new List<contact>();
        if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.Capacity__c.isAccessible()
           && Schema.sObjectType.contact.fields.email.isAccessible() && Schema.sObjectType.contact.fields.Level__c.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
           && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
           && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.Description .isAccessible()){
               
               participantList = [select name,email,phone,RecordType.Name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode,Description from contact where RecordType.Name =: 'User'];
               for(contact c: participantList){
                   ContactUserModel CU = new ContactUserModel();
                   CU.con=c;
                   //CU.isCheck=false;
                   if(insertedParticipentContactIds.contains(c.id)){
                       CU.isCheck=true;
                   }else{
                       CU.isCheck=false;
                   }
                   ContactUser.add(CU);
               }
           }
    } 
    
    public void addParticipant(){
        warningDiv = false;
        Map<Id,ContactUserModel> comparemap = new Map<Id,ContactUserModel>();
        for(ContactUserModel c : ContactUser){
            if(!comparemap.containskey(c.con.id)){
                comparemap.put(c.con.id,c); 
            }   
        }
        if(addedParticipantList != null)
        {
            for(ContactUserModel c : addedParticipantList){
                if(!comparemap.containskey(c.con.id)){
                    comparemap.put(c.con.id,c); 
                }
            }
        }
        ContactUser = new List<ContactUserModel>();
        for(Id ids : comparemap.keyset()){
            ContactUser.add(comparemap.get(ids));
        }
        addedParticipantList = new List<ContactUserModel>();
        
        System.debug('---addedParticipantListNew'+ addedParticipantList);
        for(ContactUserModel cModel: ContactUser){
            if(cModel.isCheck == true){
                addedParticipantList.add(cModel);
                system.debug('@@@@@@participantlist'+addedParticipantList);
            }
        }
        System.debug('---addedParticipantListNew'+ addedParticipantList);
        if(addedParticipantList.size()>0){
            containtselement = true;
            
        }
        if(addedParticipantList.size()==0)
        {
            containtselement = false;
            warningDiv = true;
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Warning,'Select Customer before Adding');
            ApexPages.addMessage(requirereasonMessage);
        }
        system.debug('--- list'+ addedParticipantList);
        
        
    }
    
    public void removeParticipant(){
        for(integer i=0; i< addedParticipantList.size(); i++){
            system.debug('List'+addedParticipantList);
            system.debug('added'+addedParticipantList.get(i).con.id);
            system.debug('removeId'+removeId);
            if(addedParticipantList.get(i).con.id == removeId){
                system.debug('Hi');
                system.debug('check'+addedParticipantList.get(i).ischeck);
                addedParticipantList.get(i).ischeck = false;
                addedParticipantList.remove(i);
            }
        }
        if(addedParticipantList.size()>0){
            containtselement = true;
        }
        else{
            containtselement = false;
        }
    }
    // method for save participent
    /*public void saveParticipant(){
List<Participant__c> PList = new List<Participant__c>();
for(ContactUserModel cModel: addedParticipantList){
if(cModel.isCheck == true ){
Participant__c p = new Participant__c();
p.Participant_Name__c = cModel.con.id;
p.Appointment__c = newAppointment.id;
PList.add(p);
}
}
delete  [select Participant_Name__c,Appointment__c from Participant__c where Appointment__c =: appId];
if(PList.size()>0){
upsert PList;
}
}*/
    
    public PageReference  search(){
        system.debug('ContactUser'+ContactUser);
        system.debug('ContactUserLength'+ContactUser.size());
        system.debug('beforeaddedParticipantList'+addedParticipantList);
        List<ContactUserModel> listbefore = new List<ContactUserModel>();
        if(addedParticipantList!=null){
            listbefore.addall(addedParticipantList); 
        }
        addedParticipantList = new List<ContactUserModel>();
        if(ContactUser.size()>0){
            for(ContactUserModel con : ContactUser){
                if(con.isCheck == true){
                    addedParticipantList.add(con);
                }
            }
        }
        if(listbefore.size()>0){
            addedParticipantList.addall(listbefore);
        }
        system.debug('New addedParticipantList'+addedParticipantList);
        ContactUser = new List<ContactUserModel>();
        set<string> insertedParticipentContactIds = new set<string>();
        if(addedParticipantList != null){
            for(ContactUserModel cModel: addedParticipantList){
                insertedParticipentContactIds.add(cModel.con.id);
            } 
        }
        system.debug('Inserted New Set'+insertedParticipentContactIds);
        
        String searchValue = '%'+NameSearch+'%';
        if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.Capacity__c.isAccessible()
           && Schema.sObjectType.contact.fields.email.isAccessible() && Schema.sObjectType.contact.fields.Level__c.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
           && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
           && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.Description .isAccessible()){
               participantList = [select name,email,phone,RecordType.Name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode,Description from contact where name like : searchValue and RecordType.Name =: 'User'];
               for(contact c: participantList){
                   ContactUserModel CU = new ContactUserModel();
                   CU.con=c;
                   //CU.isCheck=false;
                   if(insertedParticipentContactIds.contains(c.id)){
                       CU.isCheck=true;
                   }else{
                       CU.isCheck=false;
                   }
                   ContactUser.add(CU);
               }
               if(ContactUser.size()==0){
                   containts = false;
               }
               else{
                   containts = true;
                   
               }
               
               system.debug('ContactUserNew'+ContactUser);
           }
        return null;
    }
    public class ContactUserModel{
        public contact con{get;set;}
        public boolean isCheck{get;set;}
    }
    public void addCustomerFromAppointment(){
        errorDiv = false;
        con = new contact();
        
    }
    public void saveCustomer(){
        errorDiv = false;
        if(con.lastname == null || con.lastname ==''){
            errorDiv = true;
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Last Name can not be blank');
            ApexPages.addMessage(requirereasonMessage);
            
        }
        
        else if(String.isNotBlank(con.email)){
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
            Pattern MyPattern = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPattern.matcher(con.email);
            
            if (!MyMatcher.matches()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please Enter Valid Email'));
                errorDiv =true;
                
            }
            
            // return null;
            
        }
        
        else{
            
            errorDiv = false;
        }     
        
        if( errorDiv == false){
            Id TypeRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('User').getRecordTypeId();
            con.RecordTypeId = TypeRecordTypeId;
            system.debug('<<<<<<<>>>>>>>>><<<<<<>>>>>>>');
            if((Schema.sObjectType.contact.fields.firstname.isCreateable() && Schema.sObjectType.contact.fields.lastname.isCreateable() && Schema.sObjectType.contact.fields.Capacity__c.isCreateable()
                && Schema.sObjectType.contact.fields.email.isCreateable() && Schema.sObjectType.contact.fields.Level__c.isCreateable() && Schema.sObjectType.contact.fields.Phone.isCreateable()
                && Schema.sObjectType.contact.fields.MailingCity.isCreateable() && Schema.sObjectType.contact.fields.MailingCountry.isCreateable() && Schema.sObjectType.contact.fields.MailingState.isCreateable()
                && Schema.sObjectType.contact.fields.MailingStreet.isCreateable() && Schema.sObjectType.contact.fields.MailingPostalCode.isCreateable() && Schema.sObjectType.contact.fields.Description.isCreateable()) && (Schema.sObjectType.contact.fields.firstname.isCreateable() && Schema.sObjectType.contact.fields.lastname.isCreateable() && Schema.sObjectType.contact.fields.Capacity__c.isUpdateable()
                                                                                                                                                                                                                             && Schema.sObjectType.contact.fields.email.isUpdateable() && Schema.sObjectType.contact.fields.Level__c.isUpdateable() && Schema.sObjectType.contact.fields.Phone.isUpdateable()                                                                                                                                                                                                                  && Schema.sObjectType.contact.fields.MailingCity.isUpdateable() && Schema.sObjectType.contact.fields.MailingCountry.isUpdateable() && Schema.sObjectType.contact.fields.MailingState.isUpdateable()
                                                                                                                                                                                                                             && Schema.sObjectType.contact.fields.MailingStreet.isUpdateable() && Schema.sObjectType.contact.fields.MailingPostalCode.isUpdateable() && Schema.sObjectType.contact.fields.Description.isUpdateable())){
                                                                                                                                                                                                                                 try{    
                                                                                                                                                                                                                                     upsert con;    
                                                                                                                                                                                                                                     con=null;
                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 catch(DmlException e) {
                                                                                                                                                                                                                                     errorDiv = true;
                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                 }    
                                                                                                                                                                                                                             }
            
            
        }
    }
}