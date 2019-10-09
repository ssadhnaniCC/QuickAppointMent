public with sharing class ServiceCtrl{
    public Service__c Buss{get;set;}
    public List<Service__c> bussList{get;set;}
    public string BussinessId{get;set;}
    public boolean isEdatible {get;set;}
    public string ServiceIdForDelete{get;set;}
    public boolean errorDiv{get;set;}
    public List<location__c> getLocation{get;set;}
    public List<selectoption> allLocation{get;set;}
    public List<selectoption> selectedLocation{get;set;}
    public boolean containtselement{get;set;}
    public string ServiceNameSearch{get;set;}
   // public boolean warningDiv{get;set;}
    
    
    public ServiceCtrl(){
        isEdatible = false;
        errorDiv = false;
         //warningDiv = false;
        Buss = new Service__c();
        bussList = AppointmentHelper.fetchAllServices();
       if(bussList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
        getLocation  = new List<location__c>();
        getAllLocation();
    }
    private void getAllLocation(){
        getLocation = AppointmentHelper.fetchActiveLocation();
        allLocation = new list<selectoption>();
        selectedLocation = new list<selectoption>();
        for(location__c loc: getLocation){
            allLocation.add(new SelectOption(loc.id,loc.name));
        }
        
        
        
    }
    public void goToNewEditMode(){
        isEdatible = true;
       // warningDiv=false;
       
       system.debug('aaayaayayya');
         errorDiv = false;
        if(BussinessId ==''){
             system.debug('qqqqqqqqq');
             Buss = new Service__c();
             getAllLocation();
        }else{
            Buss= getServiceById(BussinessId);
        }
    }
    private Service__c getServiceById(string BussId){
      service__c ser= new service__c();
      
      selectedLocation=new list<selectOption>();
       if(Schema.sObjectType.Service__c.fields.name.isAccessible() && Schema.sObjectType.Service__c.fields.Description__c.isAccessible()
       && Schema.sObjectType.Service__c.fields.Duration__c.isAccessible() && Schema.sObjectType.Service__c.fields.Padding_Time__c.isAccessible()
       && Schema.sObjectType.Service__c.fields.Price__c.isAccessible()){
           ser=  [select name,Description__c,Duration__c,Padding_Time__c,Price__c from Service__c where id =: BussId];
       }
       
       List<Location_Service__c> LocSer = new List<Location_Service__c>();
       if(Schema.sObjectType.Location_Service__c.fields.Location__c.isAccessible() && Schema.sObjectType.Location_Service__c.fields.Service__c.isAccessible()){
           LocSer = [select location__c, service__c from Location_Service__c where service__c =: BussId];
       }
       map<string,Location__c> mapGetLocs = new map<string,Location__c>();
       map<string,String> mapSelectedLocs = new map<string,String>();
       for(location__c loc : getLocation){
           mapGetLocs.put(loc.id,loc);
       }
       
       if(LocSer.size() > 0){
               
           for(Location_Service__c l : LocSer){
               selectedLocation.add(new selectoption(l.location__c,mapGetLocs.get(l.location__c).name));
               mapSelectedLocs.put(l.location__c,mapGetLocs.get(l.location__c).name);
           }
           allLocation=new list<selectOption>();
           for(location__c loc: mapGetLocs.values()){
                if(!mapSelectedLocs.containsKey(loc.id))
                    allLocation.add(new SelectOption(loc.id,loc.name));
                
            }
       }else{
           getAllLocation();
       }
       
       return ser;
    }
    public PageReference saveBussiness(){
       system.debug('saveBussiness');
        
        if(Buss.name == '' || Buss.name == null){
               errorDiv = true;
               // warningDiv = true;
                ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Enter Service Name');
                ApexPages.addMessage(requirereasonMessage);
                return null;
        } 
        if(Buss.Duration__c == 0 || Buss.Duration__c == null ){
            errorDiv = true;
                ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Enter Duration');
                ApexPages.addMessage(requirereasonMessage);
                return null;
        }
         if(Buss.Duration__c >=1000 ){
               errorDiv = true;
                ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Duration should be less than 1000');
                ApexPages.addMessage(requirereasonMessage);
                return null;      
        }
         if(Buss.price__c == 0.00 || Buss.price__c == null){
               system.debug('AA gyaaaa qaaaaa');
            errorDiv = true;
                ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Enter Price');
                ApexPages.addMessage(requirereasonMessage);
              system.debug(requirereasonMessage);
               
                return null;
        }
          
        else{
            errorDiv = false;
            }
            system.debug('@@@@@@hiiiii') ; 
            if(errorDiv == false){
                list<Location_Service__c> locserList = new list<Location_Service__c>();
            
            if((Schema.sObjectType.Service__c.fields.name.isCreateable() && Schema.sObjectType.Service__c.fields.Description__c.isCreateable()
               && Schema.sObjectType.Service__c.fields.Duration__c.isCreateable() && Schema.sObjectType.Service__c.fields.Padding_Time__c.isCreateable()
               && Schema.sObjectType.Service__c.fields.Price__c.isCreateable()) && (Schema.sObjectType.Service__c.fields.name.isUpdateable() && Schema.sObjectType.Service__c.fields.Description__c.isUpdateable()
               && Schema.sObjectType.Service__c.fields.Duration__c.isUpdateable() && Schema.sObjectType.Service__c.fields.Padding_Time__c.isUpdateable()
               && Schema.sObjectType.Service__c.fields.Price__c.isUpdateable())){
                 try{
                upsert Buss;
                }
                catch(Exception e){
                            errorDiv = true;         
                }
                
            //    system.debug('TestBUss');
            }
            
            List<Location_Service__c> DeleteLocSer = new List<Location_Service__c>();
            if(Schema.sObjectType.Location_Service__c.fields.Location__c.isAccessible() && Schema.sObjectType.Location_Service__c.fields.Service__c.isAccessible()){
                DeleteLocSer = [select location__c, service__c from Location_Service__c where service__c =: Buss.id];
            }
            if(DeleteLocSer.size() > 0){
                if(Location_Service__c.sObjectType.getDescribe().isDeletable()){
                    Delete DeleteLocSer;
                }
            }
            
            for(integer i=0; i< selectedLocation.size(); i++){
                Location_Service__c LS = new Location_Service__c();
                
                LS.Service__c = Buss.id;
                LS.location__c = selectedLocation[i].getValue();
                locserList.add(LS);
            }
            if(locserList.size() > 0){
                if((Schema.sObjectType.Location_Service__c.fields.Location__c.isCreateable() && Schema.sObjectType.Location_Service__c.fields.Service__c.isCreateable())
                && (Schema.sObjectType.Location_Service__c.fields.Location__c.isUpdateable() && Schema.sObjectType.Location_Service__c.fields.Service__c.isUpdateable())){
                    upsert locserList;
                }
            }
            bussList = AppointmentHelper.fetchAllServices();
              if(bussList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
            isEdatible = false;
          //  return new pagereference('/apex/CC_QAppt__ServicePage');
          
            }
        return null;
    }
    public void DeleteBussiness(){
        Service__c deleteService = new Service__c ();
        deleteService = getServiceById(ServiceIdForDelete);
        if(Service__c.sObjectType.getDescribe().isDeletable()){
            delete deleteService;
        }
        bussList = AppointmentHelper.fetchAllServices();
          if(bussList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
    }
    public PageReference search(){
    system.debug('in search');
        String searchValue = '%'+ServiceNameSearch+'%';
        if(Schema.sObjectType.Service__c.fields.name.isAccessible() && Schema.sObjectType.Service__c.fields.Description__c.isAccessible()
           && Schema.sObjectType.Service__c.fields.Duration__c.isAccessible() && Schema.sObjectType.Service__c.fields.Padding_Time__c.isAccessible()
           && Schema.sObjectType.Service__c.fields.Price__c.isAccessible()){
       
            bussList =[select name,Description__c,Duration__c,Padding_Time__c,Price__c from Service__c where name like  : searchValue];
            if(bussList.size()>0){
            containtselement = true;
            }
            else{
             containtselement = false;
            }
        }
        return null;
    }
}