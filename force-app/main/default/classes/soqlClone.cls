public class soqlClone {
    
    @AuraEnabled
    public static list<Service__c> fetchAllServices(){
        return [select name,Description__c,Duration__c,Price__c from Service__c ];
        
    }
    @AuraEnabled
    public static list<contact> fetchAllResourceStaff(String resourceId){
        if(resourceId != null){
            return [select Id,name,RecordType.Name,Capacity__c,Languages__c,Level__c,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,location__c from contact where RecordType.Name IN ('Resource', 'Staff') And Id =: resourceId];
        }
        else{
            return [select Id,name,RecordType.Name,Capacity__c,Languages__c,Level__c,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,location__c from contact where RecordType.Name IN ('Resource', 'Staff')]; 
        }
    }
    @AuraEnabled
    public  static List<contact> getCustomers(string CustomerId){   
          if(CustomerId != null){
        return [select Id,firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where recordtype.name =: 'User' and id =:CustomerId];
    }  
         else{
            return [select Id,firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where recordtype.name =: 'User' LIMIT 50000]; 
        }
    }
    @AuraEnabled
    public  static List<CC_QAppt__Appointment_Category__c> getAppointmentCategories(Id appointmentId){   
        if(appointmentId!=null){
            return [select Id,Name,CC_QAppt__IsAssetMandatory__c,CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsMultipleAttendee__c,	CC_QAppt__IsMultipleLocation__c,	CC_QAppt__IsMultipleResource__c,CC_QAppt__IsMultipleService__c,CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsServiceMandatory__c,CC_QAppt__IsPricingApplicable__c from CC_QAppt__Appointment_Category__c where id=:appointmentId];
        }
        else{
            return [select Id,CC_QAppt__IsLocationMandatory__c,Name,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsServiceMandatory__c,CC_QAppt__IsPricingApplicable__c from CC_QAppt__Appointment_Category__c limit 100];
        }
        
    }  
    
    
    public static List<CC_QAppt__Resource_Service_Alignment__c> previousResourceServiceAlignemnts(Set<Id> PreviousServices,String contactid){ 
        if(PreviousServices != null) 
        {
            return [select CC_QAppt__Service__c,CC_QAppt__Location__c,CC_QAppt__Resource_Staff__c from CC_QAppt__Resource_Service_Alignment__c where service__c IN: PreviousServices and CC_QAppt__Resource_Staff__c =: contactid];
        }
        else{
            return [select CC_QAppt__Service__c,CC_QAppt__Location__c, CC_QAppt__Service__r.Name,CC_QAppt__Location__r.Name,CC_QAppt__Resource_Staff__c from CC_QAppt__Resource_Service_Alignment__c where CC_QAppt__Resource_Staff__c =: contactid];
        }
    }
    public static List<appointment__c> getAppointments(Set<Id> ResourceServiceAlignmentIds){
        return  [select id, name,Resource_Service_Alignment__c from appointment__c where Resource_Service_Alignment__c IN: ResourceServiceAlignmentIds];
    }
    
    public static List<CC_QAppt__Location__c> getLocation(){
        return [SELECT Id,name,CC_QAppt__City__c,CC_QAppt__Country__c,CC_QAppt__Postal_Code__c,CC_QAppt__State__c,CC_QAppt__Street__c,CC_QAppt__Valid__c FROM CC_QAppt__Location__c Limit 10000];
    }   
    public static List<CC_QAppt__Location_Service__c> getDependentService(Set<Id> LocationIds){
        return [select CC_QAppt__Service__c,CC_QAppt__Service__r.name, CC_QAppt__Location__c from CC_QAppt__Location_Service__c where location__c IN: LocationIds];
    }
    
    //Get Selected Locations
    public static List<location__c> getSelectedLocationWithSer(String serId) {
        List<CC_QAppt__Location__c> cql = getLocation();
        Map<String,CC_QAppt__Location__c> mapOfLoc = new Map<String,CC_QAppt__Location__c>();
        
        for(CC_QAppt__Location__c ccl : cql) {
            mapOfLoc.put(ccl.Id, ccl);
        }
        
        
        List<location__c> locList = new List<location__c>();
        
        List<Location_Service__c> LocSer = [select location__c, service__c from Location_Service__c where service__c =: serId];
        for(Location_Service__c lsr : LocSer) {
            locList.add(mapOfLoc.get(lsr.location__c));
        }
        
        system.debug('locList@@'+locList);
        
        return locList;
    }
   
    // Common Query for Calendar 
    public static List<CC_QAppt__Appointment__c> getPreviousAppointments(String objName, String RecordId){
        if(RecordId == '' || objName == ''){
       return  [select id,name,CC_QAppt__Start_Date_Time__c,CC_QAppt__End_Date_Time__c,CC_QAppt__Busy_Time__c,CC_QAppt__Status__c,CC_QAppt__Capacity__c,CC_QAppt__Total_Participants__c,CC_QAppt__Description__c from Appointment__c where Start_Date_Time__c != null];     
        }
        else{
            String query = 'select id, name, CC_QAppt__Start_Date_Time__c,Resource_Service_Alignment__r.Resource_Staff__c, CC_QAppt__End_Date_Time__c, CC_QAppt__Busy_Time__c, CC_QAppt__Status__c, CC_QAppt__Capacity__c,';
            query += ' CC_QAppt__Total_Participants__c,CC_QAppt__Description__c FROM CC_QAppt__Appointment__c ';
            if(objName == 'Contact'){
              query += ' WHERE Resource_Service_Alignment__r.Resource_Staff__c =:RecordId';
            }    
            if(objName == 'CC_QAppt__Location__c'){
               //Create Logic for Location
            }
            if(objName == 'CC_QAppt__Service__c'){
               //Create Logic for Services 
            }
            system.debug('query'+query);
            List<CC_QAppt__Appointment__c> prevAppointments = Database.query(query);
              return prevAppointments;
          }
    }
    
    
    //Query to show related appointments for Customer
     public static List<CC_QAppt__Appointment__c> getPreviousAppointmentsForCustomers(String customerId){
          List<Participant__c> PartLIst = new List<Participant__c>();
        
        set<string> appIds = new set<string>();
        if(customerId != null){
            PartList = [select Appointment__c,Participant_Name__c from Participant__c where Participant_Name__c =: customerId];
            for(Participant__c p : PartList){
                appIds.add(p.Appointment__c);
            }
        
            return  [select name,Status__c,Resource_Service_Alignment__r.Location__r.street__c,Resource_Service_Alignment__r.Location__r.city__c,Resource_Service_Alignment__r.Service__r.name,Resource_Service_Alignment__r.Service__r.Price__c,Discount__c,
                                           Resource_Service_Alignment__r.Resource_Staff__r.name,Description__c,Start_Date_Time__c,End_Date_Time__c
                                           from Appointment__c where id in :appIds];
        }
        else{
       return  [select id,name,CC_QAppt__Start_Date_Time__c,CC_QAppt__End_Date_Time__c,CC_QAppt__Busy_Time__c,CC_QAppt__Status__c,CC_QAppt__Capacity__c,CC_QAppt__Total_Participants__c,CC_QAppt__Description__c from Appointment__c where Start_Date_Time__c != null];     
        }
    }
    
}