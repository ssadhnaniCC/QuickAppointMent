public class QuickAppointmentSOQLManager {
    
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
    public  static List<contact> getCustomers(){   
        
        return [select Id,firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where recordtype.name =: 'User' LIMIT 50000];
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
}