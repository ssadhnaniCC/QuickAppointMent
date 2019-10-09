public with sharing class ResourceStaffUsersCtrl{
    public Contact con{get;set;}
    public list<contact> conList{get;set;}
    public string contactId{get;set;}
    public boolean isEdatible {get;set;}
    public boolean relatedList{get;set;}
    public string selectedType {get;set;}
    public List<appointment__c> alignmentList{get;set;}
    public string deletedId{get;set;}
    public string alignmentId{get;set;}
    public boolean relatedListNewEdit{get;set;}
    public Resource_Service_Alignment__c Alignment{get;set;}
    public string ConIdForAlignemnt{get;set;}
    public string contactIdForDelete{get;set;}
    public string selectedLocation{get;set;}
    public string selectedService{get;set;}
    public boolean errorDiv{get;set;}
    public string NameSearch{get;set;}
    public List<selectoption> allLocation{get;set;}
    public List<selectoption> selectedMuliLocation{get;set;}
    public List<location__c> getLocation{get;set;}
    public List<service__c> getService{get;set;}
    public boolean containtselement{get;set;}
    
    public List<selectoption> AvaliableService{get;set;}
    public List<selectoption> selectedMultiService{get;set;}
    public boolean ServiceDesableFirstTime{get;set;}
    public set<Id> PreviousServices{get;set;}
    
    public ResourceStaffUsersCtrl(){
        isEdatible = false;
        relatedList = false;
        relatedListNewEdit = false;
        errorDiv = false;
        ServiceDesableFirstTime = false;
        
        selectedType = 'Resource';
        con = new contact();
        conList = AppointmentHelper.fetchAllResourceStaff();
          if(conList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
        alignmentList = new List<appointment__c>();
        
        getLocation  = new List<location__c>();
        getService = new List<service__c>();
        getAllLocation();
        getAllService();
    }
    
     private void getAllLocation(){
        getLocation = AppointmentHelper.fetchActiveLocation();
        allLocation = new list<selectoption>();
        selectedMuliLocation = new list<selectoption>();
        for(location__c loc: getLocation){
            allLocation.add(new SelectOption(loc.id,loc.name));
        }  
    }
    
    private void getAllService(){
        
        getService = AppointmentHelper.fetchAllServices();
        AvaliableService = new list<selectOption>();
        selectedMultiService = new list<selectOption>();
        for(service__c ser: getService){
            AvaliableService.add(new SelectOption(ser.id,ser.name));    
        }
    }
    
    public void getServiceBasedOnLocation(){
        ServiceDesableFirstTime = true;
        
        selectedMultiService = new list<selectOption>();
        set<id> locId = new set<Id>();
        for(integer i=0; i< selectedMuliLocation.size(); i++){
            locId.add(selectedMuliLocation[i].getValue());
        }
        map<string,String> mapSelectedService = new map<string,String>();
         if(Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.service__c.isAccessible() 
         && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.service__c.fields.name.isAccessible() ){
            for(Resource_Service_Alignment__c ser : [select Location__c, service__c,service__r.name, Resource_Staff__c from Resource_Service_Alignment__c where Resource_Staff__c =: con.Id]){
                if(!mapSelectedService.containsKey(ser.service__c)){
                    selectedMultiService.add(new SelectOption(ser.service__c,ser.service__r.name));
                    mapSelectedService.put(ser.service__c,ser.service__r.name);
                }
            }
        }
        AvaliableService = new list<selectOption>();
        if(Schema.sObjectType.Location_Service__c.fields.Location__c.isAccessible() && Schema.sObjectType.Location_Service__c.fields.Service__c.isAccessible()
            && Schema.sObjectType.service__c.fields.name.isAccessible()){
            for(Location_Service__c ser: [select service__c,service__r.name, location__c from Location_Service__c where location__c IN: locId]){
                if(!mapSelectedService.containsKey(ser.service__c)){    
                    mapSelectedService.put(ser.service__c,ser.service__r.name);
                    AvaliableService.add(new SelectOption(ser.service__c,ser.service__r.name));
                    
                }
            }
        }
    } 
    public void goToNewEditMode(){
        errorDiv = false;
        isEdatible = true;
        relatedList = false;
        if(contactId ==''){
            ServiceDesableFirstTime = false;
            con = new contact();
            getAllLocation();
           PreviousServices = new set<Id>();
        }else{
            //isEdatible = false;
            
           
            con = getContactById(contactId);
            PreviousServices = new set<Id>();
//            system.debug('Previous Services'+PreviousServices);
            for(integer i=0; i<selectedMultiService.size(); i++){
                PreviousServices.add(selectedMultiService[i].getValue());
            }
            System.debug('----- previouse service'+ PreviousServices);
        }
    }
    private contact getContactById(string conId){
        system.debug('contactid'+conId);
        ServiceDesableFirstTime = false;
        contact conObj = new contact();
        selectedMuliLocation = new list<selectOption>();
        
        AvaliableService = new list<selectOption>();
        selectedMultiService = new list<selectOption>();
         if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.Capacity__c.isAccessible()
        && Schema.sObjectType.contact.fields.Languages__c.isAccessible() && Schema.sObjectType.contact.fields.Level__c.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
        && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
        && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.location__c.isAccessible()){
        
            conObj = [select name,lastname,Capacity__c,Languages__c,Level__c,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,location__c from contact where id=: conId];
        }
       
        system.debug('conObj'+conObj);
       List<Resource_Service_Alignment__c> AligList = new List<Resource_Service_Alignment__c>();
       if(Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.service__c.isAccessible() 
         && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() ){
         
           AligList = [select Location__c, service__c, Resource_Staff__c from Resource_Service_Alignment__c where Resource_Staff__c =: conId];
             system.debug('AligList'+AligList);
         }
       
       map<string,Location__c> mapGetLocs = new map<string,Location__c>();
       map<string,String> mapSelectedLocs = new map<string,String>();
       set<Id> LocIds = new set<Id>();
       set<Id> SerIds = new set<Id>();
       for(Resource_Service_Alignment__c ali : AligList){
           LocIDs.add(ali.location__c);
           SerIds.add(ali.service__c);
       }
       if(LocIDs.size()> 0){
           ServiceDesableFirstTime = true;
       }
       if(Schema.sObjectType.location__c.fields.name.isAccessible() && Schema.sObjectType.location__c.fields.Street__c.isAccessible()
       && Schema.sObjectType.location__c.fields.Street__c.isAccessible() && Schema.sObjectType.location__c.fields.city__c.isAccessible()){
           for(location__c loc : [select id,name,Street__c,city__c from location__c where id IN: LocIDs]){
               mapGetLocs.put(loc.id,loc);
               selectedMuliLocation.add(new selectoption(loc.id,loc.name));
               mapSelectedLocs.put(loc.id,loc.name);
           }
       }
       
       map<string,service__c> mapGetServices = new map<string,service__c>();
       map<string,String> mapSelectedService = new map<string,String>();
       if(Schema.sObjectType.service__c.fields.name.isAccessible()){
           for(service__c ser: [select id, name from service__c where id IN: SerIds]){
               mapGetServices.put(ser.id,ser);
               selectedMultiService.add(new selectoption(ser.id,ser.name));
               mapSelectedService.put(ser.id,ser.name);
           }
       }
       if(AligList.size()>0){
           
            allLocation=new list<selectOption>();
           for(location__c loc: getLocation){
                if(!mapSelectedLocs.containsKey(loc.id))
                    allLocation.add(new SelectOption(loc.id,loc.name));
                
            }
            
            AvaliableService = new list<selectOption>();
            set<id> locId = new set<Id>();
            for(integer i=0; i< selectedMuliLocation.size(); i++){
                locId.add(selectedMuliLocation[i].getValue());
            }
            if(Schema.sObjectType.Location_Service__c.fields.Location__c.isAccessible() && Schema.sObjectType.Location_Service__c.fields.Service__c.isAccessible()
            && Schema.sObjectType.service__c.fields.name.isAccessible()){
                for(Location_Service__c ser: [select service__c,service__r.name, location__c from Location_Service__c where location__c IN: locId]){
                    if(!mapSelectedService.containsKey(ser.service__c))
                        AvaliableService.add(new SelectOption(ser.service__c,ser.service__r.name));
                }
            }
       }else{
           getAllLocation();
           getAllService();
       }
       System.debug('----locations'+selectedMuliLocation);
       return conObj;
    }
    
    public void DeleteResourceStaffUsers(){
        errorDiv = false;
        contact deleteCon = new contact();
        deleteCon = getContactById(contactIdForDelete);
        if(contact.sObjectType.getDescribe().isDeletable()){
            delete deleteCon;
        }
        conList = AppointmentHelper.fetchAllResourceStaff();
          if(conList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
    }
    
    /*public List<SelectOption> getType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Resource','Resource'));
        options.add(new SelectOption('Staff','Staff'));            
        return options;
    }*/
    public PageReference  ResourceStaffUsers(){
        system.debug('---- save');
        Id TypeRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(selectedType).getRecordTypeId();
        con.RecordTypeId = TypeRecordTypeId;
        if(con.name.CONTAINS(' ')){
            list<string> tempList = con.name.split(' ');
            con.firstname = tempList[0];
            con.lastname = tempList[1];
        }else{
            con.lastname = con.name;
        }
        
        if(con.lastname == '' || con.lastname == null){
            errorDiv = true;
                ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please enter resource/staff name');
                ApexPages.addMessage(requirereasonMessage);
                return null;
        }else{
            errorDiv = false;
        }
        /*if(selectedType == 'Staff'){
            con.Capacity__c = 1;
        }
        if(selectedType== 'Resource'){
            if(con.Capacity__c == 0){
                errorDiv = true;
                ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'When type is resource capacity can not be 0 ');
                ApexPages.addMessage(requirereasonMessage);
                return null;
            }
        }*/
        if((Schema.sObjectType.contact.fields.firstname.isCreateable() && Schema.sObjectType.contact.fields.lastname.isCreateable() && Schema.sObjectType.contact.fields.Capacity__c.isCreateable()
         && Schema.sObjectType.contact.fields.Phone.isCreateable()
        && Schema.sObjectType.contact.fields.MailingCity.isCreateable() && Schema.sObjectType.contact.fields.MailingCountry.isCreateable() && Schema.sObjectType.contact.fields.MailingState.isCreateable()
        && Schema.sObjectType.contact.fields.MailingStreet.isCreateable() && Schema.sObjectType.contact.fields.MailingPostalCode.isCreateable()
        && (Schema.sObjectType.contact.fields.firstname.isUpdateable() && Schema.sObjectType.contact.fields.lastname.isUpdateable() && Schema.sObjectType.contact.fields.Capacity__c.isUpdateable()
        && Schema.sObjectType.contact.fields.Phone.isUpdateable()
        && Schema.sObjectType.contact.fields.MailingCity.isUpdateable() && Schema.sObjectType.contact.fields.MailingCountry.isUpdateable() && Schema.sObjectType.contact.fields.MailingState.isUpdateable()
        && Schema.sObjectType.contact.fields.MailingStreet.isUpdateable() && Schema.sObjectType.contact.fields.MailingPostalCode.isUpdateable()))){
            try{
            upsert con;
            }
            catch(DmlException e) {
               errorDiv = true;  
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Duplicate Contact can\'t be Inserted.Please uncheck duplicate rule for contact '));  
            }
        }
        if(selectedMultiService.size() > 0 ){
            set<Id> newServices = new set<Id>();
            List<Integer> removeIndex = new List<Integer>();
            for(integer j=0; j<selectedMultiService.size(); j++){
                newServices.add(selectedMultiService[j].getValue());
                if(PreviousServices.contains(selectedMultiService[j].getValue())) removeIndex.add(j);
            }
            for(Integer i : removeIndex){
                selectedMultiService.remove(i);
            }
            System.debug('---new servicess '+ newServices);
            
            for(ID Serid : PreviousServices){
                if(newServices.contains(Serid)){
                    PreviousServices.remove(Serid);
                }
            } 
            System.debug('---- now previous servicce '+ PreviousServices);
        }
        List<Resource_Service_Alignment__c> DeleteAlignments = new List<Resource_Service_Alignment__c>();
        
        if(Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.service__c.isAccessible() 
         && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() ){
         
            DeleteAlignments = [select service__c,Location__c,Resource_Staff__c from Resource_Service_Alignment__c where service__c IN: PreviousServices and Resource_Staff__c =: con.id];
        }
        set<id> aliIds = new set<Id>();
        for(Resource_Service_Alignment__c ali : DeleteAlignments){
            aliIds.add(ali.id);
        }
        List<appointment__c> DeleteAppointent = new List<appointment__c>();
        if(aliIds.size() > 0){
            if(Schema.sObjectType.appointment__c.fields.name.isAccessible() && Schema.sObjectType.appointment__c.fields.Resource_Service_Alignment__c.isAccessible()){
                 DeleteAppointent = [select id, name,Resource_Service_Alignment__c from appointment__c where Resource_Service_Alignment__c IN: aliIds];
             }
        }
        if(DeleteAppointent.size()>0){
            if(appointment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteAppointent;
            }
        }
        if(DeleteAlignments.size() > 0){
            if(Resource_Service_Alignment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteAlignments;
            }
        }
     //   system.debug('--- selected Location '+ selectedMuliLocation);
        system.debug('--- selected service '+ selectedMultiService);
        //if(!PreviousServices.isEmpty()){
        List<Resource_Service_Alignment__c> SaveAlignments = new List<Resource_Service_Alignment__c>();
        for(integer i=0; i< selectedMuliLocation.size(); i++){
            for(integer j=0; j<selectedMultiService.size(); j++){
                Resource_Service_Alignment__c Alignments = new Resource_Service_Alignment__c();
                Alignments.location__c = selectedMuliLocation[i].getValue();
                Alignments.service__c  = selectedMultiService[j].getValue();
                Alignments.Resource_Staff__c = con.Id;
                SaveAlignments.add(Alignments);
            }
        }
        if(SaveAlignments.size()> 0 ){
            if((Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isCreateable() && Schema.sObjectType.Resource_Service_Alignment__c.fields.service__c.isCreateable() 
         && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isCreateable())){
             try{
                insert SaveAlignments;
             }
           catch(DmlException e) {
               errorDiv = true;  
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Duplicate Record can\'t be Inserted.Please uncheck duplicate rule for contact'));  
            }
            }
        }
         //}
        conList = AppointmentHelper.fetchAllResourceStaff();
          if(conList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
        //return new pagereference('/apex/ResourceStaffUsers');
        return null;
    }
    
    public void ShowAlignemtn(){
        relatedList = true;
        con = getContactById(ConIdForAlignemnt);
        alignmentList = getAlignmentList(ConIdForAlignemnt);
    }
    
    /*public void DeleteAlignment(){
        Resource_Service_Alignment__c temp = new Resource_Service_Alignment__c();
        temp = [select name,Service__r.name,Resource_Staff__r.name,Location__c from Resource_Service_Alignment__c where id =: deletedId];
        delete temp;
        relatedList = true;
        isEdatible = true;
        alignmentList = getAlignmentList(contactId);
    }
    public void AddNewAlignment(){
        relatedListNewEdit = true;
        if(alignmentId == ''){
            Alignment = new Resource_Service_Alignment__c();
        }else{
            Alignment = [select name,Service__r.name,Location__r.street__c,Location__r.city__c from Resource_Service_Alignment__c where id =: alignmentId ];
            
        }
    }*/
    
    public list<appointment__c> getAlignmentList(string conId){
         if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Status__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible()
                   && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Description__c.isAccessible()
                   && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible()
                   && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible() && Schema.sObjectType.Service__c.fields.Price__c.isAccessible() && Schema.sObjectType.Service__c.fields.Duration__c.isAccessible()
                   && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Discount__c.isAccessible()
                   && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible()&& Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isAccessible()){
                   
         return  [select name,Status__c,Resource_Service_Alignment__r.Location__r.street__c,Resource_Service_Alignment__r.Location__r.city__c,Resource_Service_Alignment__r.Service__r.name,Resource_Service_Alignment__r.Service__r.Price__c,Discount__c,
                                   Resource_Service_Alignment__r.Resource_Staff__r.name,Description__c,Start_Date_Time__c,End_Date_Time__c
                                   from Appointment__c where Resource_Service_Alignment__r.Resource_Staff__c =:  conId];
        }
        return null;
    }
    
    public void SaveAlignment(){
        if(alignmentId == ''){
            Alignment.Resource_Staff__c = ConIdForAlignemnt;
        }
        Alignment.Location__c = selectedLocation;
        Alignment.Service__c = selectedService;
        if((Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isCreateable() && Schema.sObjectType.Resource_Service_Alignment__c.fields.service__c.isCreateable() 
         && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isCreateable()) && (Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isUpdateable() && Schema.sObjectType.Resource_Service_Alignment__c.fields.service__c.isUpdateable() 
         && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isUpdateable())  ){
         
            upsert Alignment;
        }
        relatedListNewEdit = false;
        alignmentList = getAlignmentList(ConIdForAlignemnt);
    }
    
     public List<SelectOption> getActiveLocation() {
         List<SelectOption> activeLocationList = new List<SelectOption>();
         List<location__c> loc = AppointmentHelper.fetchActiveLocation();
         for(location__c l: loc){
             activeLocationList.add(new SelectOption(l.id,l.name));
         }
         return activeLocationList;
     }
     public List<SelectOption> getActiveService() {
         List<SelectOption> activeServiceList = new List<SelectOption>();
         List<Service__c> ser = AppointmentHelper.fetchActiveServices();
         for(Service__c se: ser){
             activeServiceList.add(new SelectOption(se.id,se.name));
         }
         return activeServiceList;
     }
     public PageReference search(){
        String searchValue = '%'+NameSearch+'%';
        if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.Capacity__c.isAccessible()
        && Schema.sObjectType.contact.fields.Languages__c.isAccessible() && Schema.sObjectType.contact.fields.Level__c.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
        && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
        && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.location__c.isAccessible()){
        
        
            conList = [select name,lastname,Capacity__c,Languages__c,Level__c,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,RecordType.Name from contact where name like : searchValue and RecordType.Name IN ('Resource', 'Staff')];
                  if(conList.size()>0){
    containtselement = true;
    }
    else{
     containtselement = false;
    }
        }
        return null;
    }
}