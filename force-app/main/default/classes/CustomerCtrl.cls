public with sharing class CustomerCtrl{
    public List<contact> UserList{get;set;}
    public string CustomerId{get;set;}
    public contact con{get;set;}
    public string customerIdForDelete{get;set;}
    public string selectedType{get;set;}
    public boolean errorDiv{get;set;}
    public string CustomerIdForAppointment{get;set;}
    public boolean relatedAppointment{get;set;}
    public List<Appointment__c> AppListForCustomer{get;set;}
    public contact customerName{get;set;}
    public boolean containtselement{get;set;}
    public string customerNameSearch{get;set;} 
    public string customerAppIdForDelete{get;set;}
    
    public CustomerCtrl(){
        UserList = new List<contact>();
        UserList = getConList();
          if(UserList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
        selectedType = 'User';
        errorDiv = false;
        relatedAppointment = false;
    }
    private List<contact> getConList(){
         if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.firstname.isAccessible()
            && Schema.sObjectType.contact.fields.lastname.isAccessible() && Schema.sObjectType.contact.fields.email.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
            && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
            && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.Description.isAccessible()){
        
            return [select firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where recordtype.name =: 'User'];
        }
        return null;
    }
    public void goToNewEditMode(){
        errorDiv = false;
        if(CustomerId == ''){
            con = new contact();
        }else{
            con = getCustomerById(CustomerId);
        }
    }
    private contact getCustomerById(string cId){
        if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.firstname.isAccessible()
            && Schema.sObjectType.contact.fields.lastname.isAccessible() && Schema.sObjectType.contact.fields.email.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
            && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
            && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.Description.isAccessible()){
        
            return [select firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where id =: cId];
        }
        return null;
    }
    public PageReference saveCustomer(){
             system.debug('@@@@1'+con);
             errorDiv=false;
    
          if(con.lastname == null || con.lastname ==''){
            errorDiv = true;
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'first name and last name can not be blank ');
            ApexPages.addMessage(requirereasonMessage);
            return null;
            }
         if(String.isNotBlank(con.email)){
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
            Pattern MyPattern = Pattern.compile(emailRegex);
             Matcher MyMatcher = MyPattern.matcher(con.email);

             if (!MyMatcher.matches()){
                 system.debug('hello');
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please Enter Valid Email'));
                  errorDiv = true;
                 return null;
             }
             else{                       
                 errorDiv=false; 
             }
       }
             if(errorDiv==false){                
                system.debug('@@@@2'+con);
                errorDiv = false;
                Id TypeRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(selectedType).getRecordTypeId();
                con.RecordTypeId = TypeRecordTypeId;
                if((Schema.sObjectType.contact.fields.firstname.isCreateable() && Schema.sObjectType.contact.fields.lastname.isCreateable() && Schema.sObjectType.contact.fields.Capacity__c.isCreateable()
                     && Schema.sObjectType.contact.fields.Phone.isCreateable()
                    && Schema.sObjectType.contact.fields.MailingCity.isCreateable() && Schema.sObjectType.contact.fields.MailingCountry.isCreateable() && Schema.sObjectType.contact.fields.MailingState.isCreateable()
                    && Schema.sObjectType.contact.fields.MailingStreet.isCreateable() && Schema.sObjectType.contact.fields.MailingPostalCode.isCreateable()
                    && (Schema.sObjectType.contact.fields.firstname.isUpdateable() && Schema.sObjectType.contact.fields.lastname.isUpdateable() && Schema.sObjectType.contact.fields.Capacity__c.isUpdateable()
                    && Schema.sObjectType.contact.fields.Phone.isUpdateable()
                    && Schema.sObjectType.contact.fields.MailingCity.isUpdateable() && Schema.sObjectType.contact.fields.MailingCountry.isUpdateable() && Schema.sObjectType.contact.fields.MailingState.isUpdateable()
                    && Schema.sObjectType.contact.fields.MailingStreet.isUpdateable() && Schema.sObjectType.contact.fields.MailingPostalCode.isUpdateable()))){
        
                        try {
                            upsert con;
                            
                            system.debug('@@@@@@con3'+con);
                        } catch(DmlException e) {
                            errorDiv = true;
                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Duplicate Contact can\'t be Inserted.Please uncheck duplicate rule for contact '));
                        }    
                        
            }
                UserList = getConList();
                if(UserList.size()>0){
                    containtselement = true;
                }
                else{
                    containtselement = false;
                }
                //return new pagereference('/apex/Customer');
                return null;
         }
        
        else{
            
            return null;
            
        }
    }
    public void DeleteCustomer(){
        errorDiv = false;
        contact deleteCon = new contact();
        deleteCon = getCustomerById(customerIdForDelete);
        if(contact.sObjectType.getDescribe().isDeletable()){
            delete deleteCon;
        }
        UserList = getConList();
           if(UserList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
    }
    public void ShowCustomerAppointment(){
        relatedAppointment = true;
        List<Participant__c> PartLIst = new List<Participant__c>();
        set<string> appIds = new set<string>();
        if (Schema.sObjectType.Participant__c.fields.Participant_Name__c.isAccessible() && Schema.sObjectType.Participant__c.fields.Appointment__c.isAccessible()){
            PartList = [select Appointment__c,Participant_Name__c from Participant__c where Participant_Name__c =: CustomerIdForAppointment];
            for(Participant__c p : PartList){
                appIds.add(p.Appointment__c);
            }
        
        customerName = getCustomerById(CustomerIdForAppointment);
        AppListForCustomer = new List<Appointment__c>();
         if(Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Status__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible()
                   && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Description__c.isAccessible()
                   && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible()
                   && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible() && Schema.sObjectType.Service__c.fields.Price__c.isAccessible() && Schema.sObjectType.Service__c.fields.Duration__c.isAccessible()
                   && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Discount__c.isAccessible()
                   && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible()&& Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isAccessible()){
                   
                AppListForCustomer = [select name,Status__c,Resource_Service_Alignment__r.Location__r.street__c,Resource_Service_Alignment__r.Location__r.city__c,Resource_Service_Alignment__r.Service__r.name,Resource_Service_Alignment__r.Service__r.Price__c,Discount__c,
                                           Resource_Service_Alignment__r.Resource_Staff__r.name,Description__c,Start_Date_Time__c,End_Date_Time__c
                                           from Appointment__c where id IN :  appIds];
           }
       } 
    }
    public PageReference search(){
    relatedAppointment = false;
        String searchValue = '%'+customerNameSearch+'%';
        if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.firstname.isAccessible()
            && Schema.sObjectType.contact.fields.lastname.isAccessible() && Schema.sObjectType.contact.fields.email.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
            && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
            && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.Description.isAccessible()){
        
            UserList =[select firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where  name like : searchValue  and recordtype.name =: 'User'];
          if(UserList.size()>0){
           containtselement = true;
           }
        else{
         containtselement = false;
           }
        }
        return null;
    }
    public Appointment__c getAppointmentbyId(string aId){
         if (Schema.sObjectType.Appointment__c.fields.name.isAccessible() && Schema.sObjectType.Appointment__c.fields.Status__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible()
                    && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible()  && Schema.sObjectType.Service__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Appointment__c.fields.Discount__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible()
                    && Schema.sObjectType.Appointment__c.fields.All_Day_Event__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.Description__c.isAccessible()
                    && Schema.sObjectType.Appointment__c.fields.Start_Date_Time__c.isAccessible() && Schema.sObjectType.Appointment__c.fields.End_Date_Time__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.location__c.isAccessible()
                    && Schema.sObjectType.Location__c.fields.Street__c.isAccessible()  && Schema.sObjectType.Location__c.fields.City__c.isAccessible() && Schema.sObjectType.Service__c.fields.name.isAccessible() && Schema.sObjectType.contact.fields.name.isAccessible() ){
            
            return [select name,Status__c,Resource_Service_Alignment__r.Location__r.street__c,Resource_Service_Alignment__r.Location__r.city__c,Resource_Service_Alignment__r.Service__r.name,Resource_Service_Alignment__r.Service__r.Price__c,Discount__c,
                                       Resource_Service_Alignment__r.Resource_Staff__r.name,Description__c,Start_Date_Time__c,End_Date_Time__c
                                       from Appointment__c where id =:  aId];
          }
          return null;
    }
    public void DeleteCustomerAppointment(){
        errorDiv = false;
        Appointment__c delApp = new Appointment__c();
        delApp = getAppointmentbyId(customerAppIdForDelete);
        if(Appointment__c.sObjectType.getDescribe().isDeletable()){
            delete delApp;
        }
        ShowCustomerAppointment();
    }
}