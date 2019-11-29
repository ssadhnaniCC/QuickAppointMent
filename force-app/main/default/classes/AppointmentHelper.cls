public with sharing class AppointmentHelper{

    public static list<location__c> fetchAllLocations(){
        if(Schema.sObjectType.Location__c.fields.name.isAccessible() && Schema.sObjectType.Location__c.fields.Street__c.isAccessible() && Schema.sObjectType.Location__c.fields.Country__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.City__c.isAccessible() && Schema.sObjectType.Location__c.fields.Postal_Code__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.Coordinates__Latitude__s.isAccessible() && Schema.sObjectType.Location__c.fields.Coordinates__Longitude__s.isAccessible()){
            return [select name,Street__c,State__c,Country__c,City__c,Postal_Code__c,Coordinates__Latitude__s,Coordinates__Longitude__s from Location__c where id != null];
        }
        return null;
    }
    
    public static list<location__c> fetchActiveLocation(){
        if(Schema.sObjectType.Location__c.fields.name.isAccessible() && Schema.sObjectType.Location__c.fields.Street__c.isAccessible() && Schema.sObjectType.Location__c.fields.Country__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.City__c.isAccessible() && Schema.sObjectType.Location__c.fields.Postal_Code__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.Coordinates__Latitude__s.isAccessible() && Schema.sObjectType.Location__c.fields.Coordinates__Longitude__s.isAccessible()){
            return [select name,Street__c,State__c,Country__c,City__c,Postal_Code__c,Coordinates__Latitude__s,Coordinates__Longitude__s from Location__c where id != null];
        }
        return null;
    }
    
    
    public static list<Service__c> fetchAllServices(){
        
        if(Schema.sObjectType.Service__c.fields.name.isAccessible() && Schema.sObjectType.Service__c.fields.Description__c.isAccessible() && Schema.sObjectType.Service__c.fields.Duration__c.isAccessible() 
         && Schema.sObjectType.Service__c.fields.Padding_Time__c.isAccessible() && Schema.sObjectType.Service__c.fields.Price__c.isAccessible()){
            return [select name,Description__c,Duration__c,Padding_Time__c,Price__c from Service__c where id != null];
        }
        return null;
    }
    
    public static list<Service__c> fetchActiveServices(){
        if(Schema.sObjectType.Service__c.fields.name.isAccessible() && Schema.sObjectType.Service__c.fields.Description__c.isAccessible() && Schema.sObjectType.Service__c.fields.Duration__c.isAccessible() 
         && Schema.sObjectType.Service__c.fields.Padding_Time__c.isAccessible() && Schema.sObjectType.Service__c.fields.Price__c.isAccessible()){
            return [select name,Description__c,Duration__c,Padding_Time__c,Price__c from Service__c where id != null];
        }
        return null;
    }
    
    
  /*  public static list<contact> fetchAllResourceStaffUsers(){
        if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.Capacity__c.isAccessible()
        && Schema.sObjectType.contact.fields.Languages__c.isAccessible() && Schema.sObjectType.contact.fields.Level__c.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
        && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
        && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.location__c.isAccessible()){
            return [select name,RecordType.Name,Capacity__c,Languages__c,Level__c,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,location__c from contact where RecordType.Name IN ('Resource', 'Staff')];
        }
        return null;
    }*/
    
    public static list<contact> fetchAllResourceStaff(){
        if(Schema.sObjectType.contact.fields.name.isAccessible() && Schema.sObjectType.contact.fields.Capacity__c.isAccessible()
        && Schema.sObjectType.contact.fields.Languages__c.isAccessible() && Schema.sObjectType.contact.fields.Level__c.isAccessible() && Schema.sObjectType.contact.fields.Phone.isAccessible()
        && Schema.sObjectType.contact.fields.MailingCity.isAccessible() && Schema.sObjectType.contact.fields.MailingCountry.isAccessible() && Schema.sObjectType.contact.fields.MailingState.isAccessible()
        && Schema.sObjectType.contact.fields.MailingStreet.isAccessible() && Schema.sObjectType.contact.fields.MailingPostalCode.isAccessible() && Schema.sObjectType.contact.fields.location__c.isAccessible()){
            return [select name,RecordType.Name,Capacity__c,Languages__c,Level__c,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,location__c from contact where RecordType.Name IN ('Resource', 'Staff')];
        }
        return null;
        
    }
}