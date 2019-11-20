@isTest
public class TestDataFactory {
    // public static  list<contact> custList=new list<contact>();
    public static list<contact> customerList(Integer size){
        list<contact> custList=new list<contact>();
        for(integer i=0; i<size; i++){            
            Contact con=new Contact(firstname='first'+i,lastname='last'+i,email='test'+i+'@gmail.com',Phone='123'+i+i+'1233',MailingStreet='MailingStreet'+i,MailingCity='Mailingcity'+i,MailingState='MailingState'+i,MailingPostalCode='12312'+i,MailingCountry='Country'+i,Description='Description'+i);
            Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('User').getRecordTypeId();
            con.RecordtypeId=recordTypeId;
            custlist.add(con);
        }
        return custList;
    }
    public static list<CC_QAppt__Appointment_Category__c> AppointmentCategoryList(integer size){
        list<CC_QAppt__Appointment_Category__c> categoryList=new list<CC_QAppt__Appointment_Category__c>();
        for(integer i=0;i<size;i++){
            CC_QAppt__Appointment_Category__c obj=new CC_QAppt__Appointment_Category__c(Name='test'+i,CC_QAppt__IsAssetMandatory__c=true,CC_QAppt__IsAttendeeMandatory__c=true	,CC_QAppt__IsAvaliablePublically__c=true,CC_QAppt__IsLocationMandatory__c=true,CC_QAppt__IsMultipleAsset__c=true,CC_QAppt__IsMultipleAttendee__c=true,CC_QAppt__IsMultipleLocation__c=true,CC_QAppt__IsMultipleResource__c=true,CC_QAppt__IsMultipleService__c=true,CC_QAppt__IsResourceMandatory__c=true,CC_QAppt__IsPricingApplicable__c=true,CC_QAppt__IsServiceMandatory__c=true);
            categoryList.add(obj);
        } 
        return categoryList;
        
    }
    public static list<contact> resourceList(Integer size){
        List<contact> resourceList = new List<contact>();
        for(Integer i=0 ; i<size ;i++){
            Contact con = new Contact(firstname='first'+i,lastname='last'+i,MailingStreet='MailingStreet'+i,MailingCity='Gurgaon'+i,MailingState='Haryana'+i,MailingPostalCode='1100'+i,MailingCountry='India'+i,Phone='991199292'+i); 
            Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Resource').getRecordTypeId();
            con.RecordtypeId=recordTypeId;
            resourceList.add(con);
        }
        return resourceList;
    }
    public static List<CC_QAppt__Location__c> locationList(Integer size){
        List<CC_QAppt__Location__c> locationList = new List<CC_QAppt__Location__c>();
        for(Integer i=0 ; i<size ;i++){
            CC_QAppt__Location__c loc = new CC_QAppt__Location__c(name='location'+i,CC_QAppt__City__c='New Delhi'+i,CC_QAppt__Country__c='India'+i,CC_QAppt__Postal_Code__c='1100'+i,CC_QAppt__State__c='State'+i,CC_QAppt__Street__c='Street'+i);     
            locationList.add(loc);
        }
        return locationList;
    }
    public static List<CC_QAppt__Location_Service__c> locationServiceAlignment(List<Id> Location ,Id ServiceId){
        List<CC_QAppt__Location_Service__c> locationServiceList = new List<CC_QAppt__Location_Service__c>();
        for(Id ids : Location){
            CC_QAppt__Location_Service__c locationservice = new CC_QAppt__Location_Service__c(CC_QAppt__Location__c=ids ,CC_QAppt__Service__c = ServiceId);
            locationServiceList.add(locationservice);
        }
        return locationServiceList;
    }
    public static List<CC_QAppt__Service__c> serviceList(Integer size){
        List<CC_QAppt__Service__c> serviceList = new List<CC_QAppt__Service__c>();
        for(Integer i=0 ; i<size ;i++){
            CC_QAppt__Service__c service = new CC_QAppt__Service__c(Name='Service'+i,CC_QAppt__Description__c='Description'+i,CC_QAppt__Duration__c=60,CC_QAppt__Price__c=765);     
            serviceList.add(service);
        }
        return serviceList;
    }
    public static List<Resource_Service_Alignment__c> resourceServiceAlignment(List<Id> locationids ,List<Id> serviceids ,String ResourceId){
        List<Resource_Service_Alignment__c> resourceServiceAlignmentList = new List<Resource_Service_Alignment__c>();
        for(Integer i = 0;i<locationids.size();i++){
            for(Integer j=0;j<serviceids.size();j++){
              Resource_Service_Alignment__c resourceService = new Resource_Service_Alignment__c(CC_QAppt__Resource_Staff__c=ResourceId,CC_QAppt__Service__c=serviceids[j],CC_QAppt__Location__c=locationids[i]);   
              resourceServiceAlignmentList.add(resourceService);
            }
        }
      return resourceServiceAlignmentList;  
    }
    public static List<CC_QAppt__Appointment__c> createAppointment(String ResourceServiceId,String appointmentCategoryId){
        List<CC_QAppt__Appointment__c> appList = new List<CC_QAppt__Appointment__c>();
        CC_QAppt__Appointment__c appointmentRecord = new CC_QAppt__Appointment__c(Name='App',CC_QAppt__Description__c='Desc',CC_QAppt__Resource_Service_Alignment__c=ResourceServiceId,CC_QAppt__Appointment_Category__c=appointmentCategoryId,CC_QAppt__Start_Date_Time__c=Datetime.now(),CC_QAppt__End_Date_Time__c=Datetime.now());
        appList.add(appointmentRecord);
        return appList;
    }
    public static List<CC_QAppt__Appointment_Category__c> createAppointmentCategory(Integer size){
        List<CC_QAppt__Appointment_Category__c> appCategoryList = new List<CC_QAppt__Appointment_Category__c>(); 
        for(Integer i=0;i<size;i++){
           CC_QAppt__Appointment_Category__c appointmentCategory = new CC_QAppt__Appointment_Category__c(Name='Category'+i,CC_QAppt__IsAssetMandatory__c=true,CC_QAppt__IsAttendeeMandatory__c=true,CC_QAppt__IsAvaliablePublically__c=true,CC_QAppt__IsLocationMandatory__c=true,CC_QAppt__IsMultipleAsset__c=true,CC_QAppt__IsMultipleLocation__c=true,CC_QAppt__IsMultipleResource__c=true);
           appCategoryList.add(appointmentCategory);
        }
        return appCategoryList;
    }
    
    public static List<CC_QAppt__Working_Hour__c> workingHourList(Integer size){
        contact con = new contact();
        con.LastName = 'Test';
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Resource').getRecordTypeId();
        con.RecordtypeId=recordTypeId;
        Insert con;
         List<CC_QAppt__Working_Hour__c> workingHourList = new List<CC_QAppt__Working_Hour__c>();
        for(Integer i=0 ; i<size ;i++){
            CC_QAppt__Working_Hour__c workingHour = new CC_QAppt__Working_Hour__c(CC_QAppt__Start_Date__c=system.today()+i,CC_QAppt__Resource__c=con.Id);     
            workingHourList.add(workingHour);
        }
        return workingHourList;
    }
    
}