@isTest
public class TestDataFactory {   
    /* Inserts testing data for customer */
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
    
    /* Inserts testing data for publicholiday */
    public static list<CC_QAppt__Public_Holidays__c> publicHolidayList(integer size){
        list<CC_QAppt__Public_Holidays__c> pubicHolidayList=new list<CC_QAppt__Public_Holidays__c>();
        for(integer i=0;i<size;i++){
            CC_QAppt__Public_Holidays__c holidayObj=new  CC_QAppt__Public_Holidays__c(CC_QAppt__Description__c='test'+i,CC_QAppt__Holiday_Date__c=system.today().addDays(i),Name='test'+i);
       pubicHolidayList.add(holidayObj);
        }
        return pubicHolidayList;
    }
    
    /* Inserts testing data for AppointmentCategoryList */
    public static list<CC_QAppt__Appointment_Category__c> AppointmentCategoryList(integer size){
        list<CC_QAppt__Appointment_Category__c> categoryList=new list<CC_QAppt__Appointment_Category__c>();
        for(integer i=0;i<size;i++){
            CC_QAppt__Appointment_Category__c obj=new CC_QAppt__Appointment_Category__c(Name='test'+i,CC_QAppt__IsAssetMandatory__c=true,CC_QAppt__IsAttendeeMandatory__c=true	,CC_QAppt__IsAvaliablePublically__c=true,CC_QAppt__IsLocationMandatory__c=true,CC_QAppt__IsMultipleAsset__c=true,CC_QAppt__IsMultipleAttendee__c=true,CC_QAppt__IsMultipleLocation__c=true,CC_QAppt__IsMultipleResource__c=true,CC_QAppt__IsMultipleService__c=true,CC_QAppt__IsResourceMandatory__c=true,CC_QAppt__IsPricingApplicable__c=true,CC_QAppt__IsServiceMandatory__c=true);
            categoryList.add(obj);
        } 
        return categoryList;
        
    }
    
    /* Inserts testing data for AppointmentCategoryList */
    public static list<contact> resourceList(Integer size){
        List<contact> resourceList = new List<contact>();
        for(Integer i=0 ; i<size ;i++){
            Contact con = new Contact(firstname='first'+i,lastname='last'+i,MailingStreet='MailingStreet'+i,MailingCity='Gurgaon'+i,MailingState='Haryana'+i,MailingPostalCode='1100'+i,MailingCountry='India'+i,Phone='991199292'+i ,email='test@gmail.com'); 
            Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Resource').getRecordTypeId();
            con.RecordtypeId=recordTypeId;
            resourceList.add(con);
        }
        return resourceList;
    }
    
   /* Inserts testing data for LocationList */
    public static List<CC_QAppt__Location__c> locationList(Integer size){
        List<CC_QAppt__Location__c> locationList = new List<CC_QAppt__Location__c>();
        for(Integer i=0 ; i<size ;i++){
            CC_QAppt__Location__c loc = new CC_QAppt__Location__c(name='location'+i,CC_QAppt__City__c='New Delhi'+i,CC_QAppt__Country__c='India'+i,CC_QAppt__Postal_Code__c='1100'+i,CC_QAppt__State__c='State'+i,CC_QAppt__Street__c='Street'+i);     
            locationList.add(loc);
        }
        return locationList;
    }
    
   /* Inserts testing data for LocationServiceAlignment */
    public static List<CC_QAppt__Location_Service__c> locationServiceAlignment(List<Id> Location ,Id ServiceId){
        List<CC_QAppt__Location_Service__c> locationServiceList = new List<CC_QAppt__Location_Service__c>();
        for(Id ids : Location){
            CC_QAppt__Location_Service__c locationservice = new CC_QAppt__Location_Service__c(CC_QAppt__Location__c=ids ,CC_QAppt__Service__c = ServiceId);
            locationServiceList.add(locationservice);
        }
        return locationServiceList;
    }
    
    /* Inserts testing data for ServiceList */
    public static List<CC_QAppt__Service__c> serviceList(Integer size){
        List<CC_QAppt__Service__c> serviceList = new List<CC_QAppt__Service__c>();
        for(Integer i=0 ; i<size ;i++){
            CC_QAppt__Service__c service = new CC_QAppt__Service__c(Name='Service'+i,CC_QAppt__Description__c='Description'+i,CC_QAppt__Duration__c=60,CC_QAppt__Price__c=765);     
            serviceList.add(service);
        }
        return serviceList;
    }
    
    /* Inserts testing data for ResourceServiceAlignment */
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
    /* Inserts testing data for Creating Appointment */
    public static List<CC_QAppt__Appointment__c> createAppointment(String ResourceServiceId,String appointmentCategoryId,String status){
        List<CC_QAppt__Appointment__c> appList = new List<CC_QAppt__Appointment__c>();
        CC_QAppt__Appointment__c appointmentRecord = new CC_QAppt__Appointment__c(Name='App',CC_QAppt__Description__c='Desc',CC_QAppt__Resource_Service_Alignment__c=ResourceServiceId,CC_QAppt__Appointment_Category__c=appointmentCategoryId,CC_QAppt__Start_Date_Time__c=Datetime.now(),CC_QAppt__End_Date_Time__c=Datetime.now(),CC_QAppt__Status__c = status);
        appList.add(appointmentRecord);
        return appList;
    }
    
    /* Inserts testing data for Creating AppointmentCategory */
    public static List<CC_QAppt__Appointment_Category__c> createAppointmentCategory(Integer size){
        List<CC_QAppt__Appointment_Category__c> appCategoryList = new List<CC_QAppt__Appointment_Category__c>(); 
        for(Integer i=0;i<size;i++){
           CC_QAppt__Appointment_Category__c appointmentCategory = new CC_QAppt__Appointment_Category__c(Name='Category'+i,CC_QAppt__IsAssetMandatory__c=true,CC_QAppt__IsAttendeeMandatory__c=true,CC_QAppt__IsAvaliablePublically__c=true,CC_QAppt__IsLocationMandatory__c=true,CC_QAppt__IsMultipleAsset__c=true,CC_QAppt__IsMultipleLocation__c=true,CC_QAppt__IsMultipleResource__c=true);
           appCategoryList.add(appointmentCategory);
        }
        return appCategoryList;
    }
    
   /* Inserts testing data for Creating workingHourList */
    public static List<CC_QAppt__Working_Hour__c> workingHourList(Integer size){
        contact con = new contact();
        con.LastName = 'Test';
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Resource').getRecordTypeId();
        con.RecordtypeId=recordTypeId;
        Insert con;
        List<CC_QAppt__Working_Hour__c> workingHourList = new List<CC_QAppt__Working_Hour__c>();
        for(Integer i=0 ; i<size ;i++){
            CC_QAppt__Working_Hour__c workingHour = new CC_QAppt__Working_Hour__c(CC_QAppt__Active__c=true,CC_QAppt__Start_Time__c=system.today(),CC_QAppt__Resource__c=con.Id,CC_QAppt__End_Time__c=system.today());     
            workingHourList.add(workingHour);
        }
        return workingHourList;
    }
    
    /* Inserts testing data for Creating AppointmentFeedback */
    public static List<CC_QAppt__Appointment_Feedback__c> createAppointmentFeedback(Integer size){
        List<CC_QAppt__Appointment_Feedback__c> appFeedbackList = new List<CC_QAppt__Appointment_Feedback__c>(); 
        for(Integer i=0;i<size;i++){
           CC_QAppt__Appointment_Feedback__c appFeedback = new CC_QAppt__Appointment_Feedback__c(Name='Feedback'+i,CC_QAppt__Rating__c= String.valueOf(i + 1));
           appFeedbackList.add(appFeedback);
        }
        return appFeedbackList;
    }
	
	
	/* Inserts testing data for Creating Participant */
    public static List<CC_QAppt__Participant__c> createAppointmentParticipant(String appointment,String contact,integer size){
        List<CC_QAppt__Participant__c> appParticipantList = new List<CC_QAppt__Participant__c>(); 
        for(Integer i=0;i<size;i++){
           CC_QAppt__Participant__c appParticipant = new CC_QAppt__Participant__c(CC_QAppt__Appointment__c= appointment, CC_QAppt__Participant_Name__c = contact);
           appParticipantList.add(appParticipant);
        }
        return appParticipantList;
    }
    public static CC_QAppt__Appointment_Detail__c createAppointmentDetails(String appointmentId,String locationServiceId,String ResourceId){
        CC_QAppt__Appointment_Detail__c appDetail;
        if(ResourceId != null){
         appDetail = new CC_QAppt__Appointment_Detail__c(CC_QAppt__Appointment__c=appointmentId,CC_QAppt__LocationService__c=locationServiceId,CC_QAppt__Resource__c=ResourceId);
        }
        else{
           appDetail = new CC_QAppt__Appointment_Detail__c(CC_QAppt__Appointment__c=appointmentId,CC_QAppt__LocationService__c=locationServiceId);
        }
        return appDetail;
    }
    public static List<CC_QAppt__Asset__c> createAssets(Integer size){
       List<CC_QAppt__Asset__c> assetList = new List<CC_QAppt__Asset__c>();
        for(Integer i=0 ;i<size;i++){
            CC_QAppt__Asset__c asset = new CC_QAppt__Asset__c(Name='TestAsset'+i,CC_QAppt__Price__c=566);
            assetList.add(asset);
        }
        return assetList;
    }
    
}