public class QuickAppointmentSOQLManager {
    
    @AuraEnabled
    public static list<Service__c> fetchAllServices(){
        return [select Id,name,Description__c,Duration__c,Price__c from Service__c ];
        
    }
    @AuraEnabled
    public static list<contact> fetchAllResourceStaff(String resourceId){
        if(resourceId != null){
            return [select Id,name,RecordType.Name,Capacity__c,Languages__c,Level__c,Email,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,location__c from contact where RecordType.Name IN ('Resource', 'Staff') And Id =: resourceId];
        }
        else{
            return [select Id,name,RecordType.Name,Capacity__c,Languages__c,Level__c,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,location__c from contact where RecordType.Name IN ('Resource', 'Staff')]; 
        }
    }
    
    @AuraEnabled
    public static List<CC_QAppt__Resource_Service_Alignment__c> fetchResourceServiceAlignments(){
        List<CC_QAppt__Resource_Service_Alignment__c> resourceService  =   [select id,CC_QAppt__Resource_Staff__c,CC_QAppt__Service__c,CC_QAppt__Price__c from CC_QAppt__Resource_Service_Alignment__c];
   
        return resourceService;
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
    public  static List<CC_QAppt__Appointment_Category__c> getAppointmentCategories(String appointmentCategoryId, Boolean isPublic){   
        isPublic = isPublic == null ? false : isPublic;
        String query = 'select Id,Name,CC_QAppt__IsAssetMandatory__c,CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsMultipleAttendee__c, CC_QAppt__IsMultipleLocation__c,CC_QAppt__IsMultipleResource__c,CC_QAppt__IsMultipleService__c,CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsServiceMandatory__c,CC_QAppt__IsPricingApplicable__c,CC_QAppt__PricingForAsset__c,CC_QAppt__PricingForResource__c,CC_QAppt__PricingForService__c from CC_QAppt__Appointment_Category__c ';
        query += (String.isNotBlank(appointmentCategoryId) || isPublic) ? 'WHERE ' : '';
        query += isPublic ? 'CC_QAppt__IsAvaliablePublically__c = true ' : '';
        query += String.isNotBlank(appointmentCategoryId) ? 'Id = :appointmentCategoryId ' : '';
        
        return Database.query(query + ' LIMIT 100');
        
        
    }  

    public static List<CC_QAppt__Appointment_Category__c> getPublicAppointmentCategories(){
      return [select Id,CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsMultipleLocation__c,CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsMultipleAttendee__c,CC_QAppt__IsAssetMandatory__c,CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsMultipleResource__c,Name,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsServiceMandatory__c,CC_QAppt__IsMultipleService__c,CC_QAppt__IsPricingApplicable__c from CC_QAppt__Appointment_Category__c where CC_QAppt__IsAvaliablePublically__c = true limit 100];
        
    }
    
    public static List<contact> getRecentCustomers(){
     return [select Id,firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where recordtype.name =: 'User' order by lastmodifieddate desc  LIMIT 100]; 

        
    }
    public static List<Contact> filterCustomers(String CustName){
        String searchKey = '%' + CustName + '%';
        return [select Id,firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where Name Like :searchKey  And recordtype.name =: 'User' ORDER BY LastModifiedDate DESC  LIMIT 100];
    }
    
    @AuraEnabled
    public  static List<CC_QAppt__Public_Holidays__c> getPublicHolidays(Id locationId){   
        if(locationId!=null){
            return [select Id,Name,CC_QAppt__Holiday_Date__c,CC_QAppt__Location__r.Name from CC_QAppt__Public_Holidays__c where CC_QAppt__Location__c=:locationId ];
        }
        return null;
        
    }  
    
    public static List<CC_QAppt__Resource_Service_Alignment__c> previousResourceServiceAlignemnts(Set<Id> PreviousServices,String contactid){ 
        if(PreviousServices != null) 
        {
            return [select CC_QAppt__Service__c,CC_QAppt__Location__c,CC_QAppt__Price__c,CC_QAppt__Resource_Staff__c from CC_QAppt__Resource_Service_Alignment__c where service__c IN: PreviousServices and CC_QAppt__Resource_Staff__c =: contactid];
        }
        else{
            return [select CC_QAppt__Service__c,CC_QAppt__Location__c, CC_QAppt__Service__r.Name,CC_QAppt__Price__c,CC_QAppt__Location__r.Name,CC_QAppt__Resource_Staff__c from CC_QAppt__Resource_Service_Alignment__c where CC_QAppt__Resource_Staff__c =: contactid];
        }
    }
    public static List<appointment__c> getAppointments(Set<Id> ResourceServiceAlignmentIds){
        return  [select id, name,Resource_Service_Alignment__c from appointment__c where Resource_Service_Alignment__c IN: ResourceServiceAlignmentIds];
    }
    
    public static List<CC_QAppt__Location__c> getLocation(){
        return [SELECT Id,name,CC_QAppt__City__c,CC_QAppt__Country__c,CC_QAppt__Postal_Code__c,CC_QAppt__State__c,CC_QAppt__Street__c,CC_QAppt__Valid__c FROM CC_QAppt__Location__c Limit 10000];
    }   
    public static List<CC_QAppt__Location_Service__c> getDependentService(Set<Id> LocationIds){
        return [select Id,CC_QAppt__Service__c,CC_QAppt__Service__r.name, CC_QAppt__Location__c,CC_QAppt__Service__r.CC_QAppt__Price__c from CC_QAppt__Location_Service__c where location__c IN: LocationIds];
    }
    
    
    public static List<Resource_Service_Alignment__c> getDependentResourceStaff(Set<Id> ServiceIds){
        Set<Id> uniqueResourceIds = new set<Id>();  
        List<Resource_Service_Alignment__c> resourceServiceAlignment =  [select name,CC_QAppt__Service__c,CC_QAppt__Price__c,CC_QAppt__Resource_Staff__c,CC_QAppt__Resource_Staff__r.name,CC_QAppt__Resource_Staff__r.Capacity__c from Resource_Service_Alignment__c where Service__c IN: ServiceIds];
        return resourceServiceAlignment;
    }
    
    public static List<Resource_Service_Alignment__c> getResourceStaffBasedOnLocation(Set<Id> locationIds){
    List<Resource_Service_Alignment__c> resourceServiceAlignment =  [select name,CC_QAppt__Service__c,CC_QAppt__Price__c,CC_QAppt__Resource_Staff__c,CC_QAppt__Resource_Staff__r.name,CC_QAppt__Resource_Staff__r.Capacity__c from Resource_Service_Alignment__c where CC_QAppt__Location__c IN: locationIds];
     return resourceServiceAlignment;
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
    public static Map<Id,CC_QAppt__Appointment_Detail__c> getPreviousAppointments(String objName, String RecordId){
        Map<Id,CC_QAppt__Appointment_Detail__c> mapofAppointment = new Map<Id,CC_QAppt__Appointment_Detail__c>();
        if(RecordId != '' && objName != '' ){
            String query = 'select CC_QAppt__Appointment__r.Busy_Time__c,CC_QAppt__Appointment__r.CC_QAppt__Appointment_Category__r.Name,CC_QAppt__Appointment__r.CC_QAppt__Description__c,CC_QAppt__Appointment__c,CC_QAppt__Resource__c,CC_QAppt__Resource__r.Name,CC_QAppt__Appointment__r.Name,CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c,CC_QAppt__LocationService__r.CC_QAppt__Location__c,CC_QAppt__LocationService__r.CC_QAppt__Location__r.Name,CC_QAppt__LocationService__r.CC_QAppt__Service__r.Name,CC_QAppt__LocationService__r.CC_QAppt__Service__c,CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c,CC_QAppt__Appointment__r.CC_QAppt__Status__c,CC_QAppt__Appointment__r.CC_QAppt__Appointment_Category__c from CC_QAppt__Appointment_Detail__c';
            if(objName == 'CC_QAppt__Appointment_Category__c'){
                query += ' where CC_QAppt__Appointment__r.CC_QAppt__Appointment_Category__c =:  RecordId';          
            }
            
            if(objName == 'CC_QAppt__Location__c'){
                query +=  ' where (CC_QAppt__LocationService__r.CC_QAppt__Location__c =:  RecordId And CC_QAppt__Resource__c = null) And (CC_QAppt__Asset__c = null)';
             }
            if(objName == 'CC_QAppt__Service__c'){
                query += ' where (CC_QAppt__LocationService__r.CC_QAppt__Service__c =:  RecordId And CC_QAppt__Resource__c = null) And (CC_QAppt__Asset__c = null)'  ;  
             }
            if(objName == 'Contact'){
                query += ' where CC_QAppt__Resource__c =: RecordId';
            }
            List<CC_QAppt__Appointment_Detail__c> appdetaillist = Database.query(query);
            for(CC_QAppt__Appointment_Detail__c appdetails : appdetaillist){
                if(!mapofAppointment.containsKey(appdetails.CC_QAppt__Appointment__c)){
                   mapofAppointment.put(appdetails.CC_QAppt__Appointment__c,appdetails); 
                }
            }
            return mapofAppointment;
        }
        else{
            return null;
        }
    }
    public static Map<Id,CC_QAppt__Appointment_Detail__c>  getAllAppointments(){
         Map<Id,CC_QAppt__Appointment_Detail__c> mapsOfAppointmentDetail = new Map<Id,CC_QAppt__Appointment_Detail__c>();
        List<CC_QAppt__Appointment_Detail__c> appdetails =     [select CC_QAppt__Appointment__c,name,CC_QAppt__Appointment__r.Name,CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c,CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c,CC_QAppt__Appointment__r.CC_QAppt__Busy_Time__c,CC_QAppt__Appointment__r.CC_QAppt__Status__c,CC_QAppt__Appointment__r.CC_QAppt__Description__c from CC_QAppt__Appointment_Detail__c];     
        for(CC_QAppt__Appointment_Detail__c app : appdetails){
            if(!mapsOfAppointmentDetail.containsKey(app.CC_QAppt__Appointment__c)){
                mapsOfAppointmentDetail.put(app.CC_QAppt__Appointment__c,app);
            }
        }
        return mapsOfAppointmentDetail;
    }
    
    public static Map<Id,CC_QAppt__Appointment_Detail__c> getPreviousAppointmentsForCustomers(String customerId){
        Map<Id,CC_QAppt__Appointment_Detail__c> mapsOfAppointmentDetail = new Map<Id,CC_QAppt__Appointment_Detail__c>();
        List<Participant__c> PartLIst = new List<Participant__c>();   
        set<string> appIds = new set<string>();
        if(customerId != null){
            PartList = [select Appointment__c,Participant_Name__c from Participant__c where Participant_Name__c =: customerId];
            for(Participant__c p : PartList){
                appIds.add(p.Appointment__c);
            }
            List<CC_QAppt__Appointment_Detail__c> appdetails = [select CC_QAppt__Appointment__c,CC_QAppt__Appointment__r.CC_QAppt__Description__c,CC_QAppt__Appointment__r.Name,CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c,CC_QAppt__LocationService__r.CC_QAppt__Location__r.Name,CC_QAppt__LocationService__r.CC_QAppt__Service__r.Name,CC_QAppt__LocationService__r.CC_QAppt__Service__c,CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c,CC_QAppt__Appointment__r.CC_QAppt__Status__c,CC_QAppt__Appointment__r.CC_QAppt__Appointment_Category__c,CC_QAppt__LocationService__r.CC_QAppt__Location__c  from CC_QAppt__Appointment_Detail__c where CC_QAppt__Appointment__c in :appIds];
            for(CC_QAppt__Appointment_Detail__c app : appdetails){
                if(!mapsOfAppointmentDetail.containsKey(app.CC_QAppt__Appointment__c)){
                    mapsOfAppointmentDetail.put(app.CC_QAppt__Appointment__c,app);
                }
            }
            return mapsOfAppointmentDetail;
        }
        else{
         List<CC_QAppt__Appointment_Detail__c> appdetails = [select CC_QAppt__Appointment__r.Name,CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c,CC_QAppt__LocationService__r.CC_QAppt__Location__r.Name,CC_QAppt__LocationService__r.CC_QAppt__Service__r.Name,CC_QAppt__LocationService__r.CC_QAppt__Service__c,CC_QAppt__Appointment__r.CC_QAppt__End_Date_Time__c,CC_QAppt__Appointment__r.CC_QAppt__Status__c,CC_QAppt__Appointment__r.CC_QAppt__Appointment_Category__c,CC_QAppt__LocationService__r.CC_QAppt__Location__c  from CC_QAppt__Appointment_Detail__c];     
            for(CC_QAppt__Appointment_Detail__c app : appdetails){
                if(!mapsOfAppointmentDetail.containsKey(app.CC_QAppt__Appointment__c)){
                    mapsOfAppointmentDetail.put(app.CC_QAppt__Appointment__c,app);
                }
            }
            return mapsOfAppointmentDetail;
        }
    }
    public static List<CC_QAppt__Appointment__c> getAppointmentOnEdit(String appId){
        return [select id,name,CC_QAppt__Status__c,CC_QAppt__Appointment_Category__c,CC_QAppt__Description__c,CC_QAppt__TotalPrice__c,CC_QAppt__Duration__c,CC_QAppt__Start_Date_Time__c,CC_QAppt__Locations__c,CC_QAppt__Services__c,CC_QAppt__Resources__c,CC_QAppt__Assets__c,CC_QAppt__Attendees__c,CC_QAppt__Discount__c,CC_QAppt__End_Date_Time__c from CC_QAppt__Appointment__c where id =:appId];
    }        
    
    public static List<CC_QAppt__Location__c> fetchSelectedLocationForAppointment(Set<Id> locationIds){
           return [SELECT Id,name,CC_QAppt__City__c,CC_QAppt__Country__c,CC_QAppt__Postal_Code__c,CC_QAppt__State__c,CC_QAppt__Street__c,CC_QAppt__Valid__c FROM CC_QAppt__Location__c where id In:locationIds];
        
    }
    
     public static List<CC_QAppt__Service__c> fetchSelectedServiceForAppointment(Set<Id> serviceIds){
           return [select Id,name,Description__c,Duration__c,CC_QAppt__Price__c from Service__c  where id In:serviceIds];    
    }
    public static List<Contact> fetchSelectedResourcesForAppointment(Set<Id> resourcesIDs){
         return [select Id,name,RecordType.Name,Capacity__c,Languages__c,Level__c,Phone,MailingCity,MailingCountry,
                    MailingState,MailingStreet,MailingPostalCode,location__c from contact where RecordType.Name IN ('Resource', 'Staff') And Id In: resourcesIDs]; 
    }
    
    /*
     fetch working Hours
    */
    
    @AuraEnabled
    public static List<CC_QAppt__Working_Hour__c> getWorkingHours(string appId) {
        
        return [SELECT CC_QAppt__Resource__r.name,CC_QAppt__Start_Date__c,CC_QAppt__End_Date__c,CC_QAppt__Active__c,CC_QAppt__End_Time__c,CC_QAppt__Start_Time__c FROM CC_QAppt__Working_Hour__c where CC_QAppt__Resource__c =: appId];
        
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of Appointment sObject according month.
    * @returns Map<String,Integer>  key is name month and value is total number of appointment of that month .
    */
    public static Map<String,Integer> monthlyAppointment(){
        Map<String,Integer> monthlyAppointment = new Map<String,Integer>();
        String [] month = new String[] {'January','February','March','April','May','June','July','August','September','October','Novemeber','Decemeber'};
            for(AggregateResult result : [select count(id) total,calendar_month(CC_QAppt__Start_Date_Time__c) month from CC_QAppt__Appointment__c where CC_QAppt__Status__c = 'Completed' GROUP BY calendar_month(CC_QAppt__Start_Date_Time__c)]){
                Integer m = (Integer)result.get('month') - 1;
                monthlyAppointment.put(month[m],(Integer)result.get('total'));
            }
        return monthlyAppointment;
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of Appointment sObject on daily basis.
    * @returns List<CC_QAppt__Appointment__c> .
    */
    public static List<CC_QAppt__Appointment__c> dailyAppointment(){
        return [select id, CC_QAppt__Start_Date_Time__c from CC_QAppt__Appointment__c where CC_QAppt__Start_Date_Time__c = TODAY order By CC_QAppt__Start_Date_Time__c];
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of rating from Appiontment Feedback sObject.
    * @returns Map<String,Integer>  key is name of rate like '5*' and value is total number of rating of that rate .
    */
    public static Map<String,Integer> getRating(){
       Map<String,Integer> ratingMap = new Map<String,Integer>();
        for(AggregateResult result : [select count(id) total, CC_QAppt__Rating__c from CC_QAppt__Appointment_Feedback__c Group By CC_QAppt__Rating__c]){
            if(result.get('CC_QAppt__Rating__c') != null){
                ratingMap.put((String)result.get('CC_QAppt__Rating__c'),(Integer)result.get('total'));
            }
        }
        return ratingMap;
    }
    
     /*******************************************************************************************************
    * @description This method is used for getting data of top ten Category.
    * @returns Map<String,Integer>  key is name of Category and value is total number of Appointment of that category .
    */
    public static Map<String,Integer> getTopCategory(){
       Map<String,Integer> categoryMap = new Map<String,Integer>();
        for(AggregateResult result : [select count(id) total, CC_QAppt__Appointment_Category__r.Name name from CC_QAppt__Appointment__c Group by CC_QAppt__Appointment_Category__r.Name order by count(id) DESC limit 10]){
            if(result.get('name') != Null)
                categoryMap.put((String)result.get('name'),(Integer)result.get('total'));
        }
        return categoryMap;
    }
    
     /*******************************************************************************************************
    * @description This method is used for getting data of top ten Customer.
    * @returns Map<String,Integer>  key is name of Customer and value is total number of Appointment of that Customer .
    */
    public static Map<String,Integer> getTopCustomer(){
        Map<String,Integer> customerMap = new Map<String,Integer>();
        for(AggregateResult result : [select count(CC_QAppt__Appointment__c) total,CC_QAppt__Participant_Name__r.Name name from CC_QAppt__Participant__c WHERE CC_QAppt__Appointment__r.CC_QAppt__Status__c = 'Completed' group by CC_QAppt__Participant_Name__r.Name order by count(CC_QAppt__Appointment__c) DESC LIMIT 10]){
            if(result.get('name') != Null)
                customerMap.put((String)result.get('name'),(Integer)result.get('total'));
            System.debug(customerMap);
        }
        return customerMap;
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of upcoming Appointment.
    * @returns List<CC_QAppt__Appointment__c> .
    */
    public static List<CC_QAppt__Appointment__c> getUpcomingAppointment(){
        return[SELECT Name,Resource_Service_Alignment__r.Location__r.name,Resource_Service_Alignment__r.Service__r.name,CC_QAppt__Start_Date_Time__c FROM CC_QAppt__Appointment__c WHERE CC_QAppt__Start_Date_Time__c >= TODAY];
    }
    
   /*******************************************************************************************************
    * @description This method is used for getting data of Customer of upcoming Appointment.
    * @returns List<CC_QAppt__Participant__c> .
    */
    public static List<CC_QAppt__Participant__c> getUpcomingCustomer(){
        return[select CC_QAppt__Appointment__r.Name ,CC_QAppt__Participant_Name__r.Name, CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c from CC_QAppt__Participant__c WHERE CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c >= TODAY];
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting total number of rate.
    * @returns Integer.
    */
    public static Integer totalRating(){
        list<CC_QAppt__Appointment_Feedback__c> rate = [select id, CC_QAppt__Rating__c from CC_QAppt__Appointment_Feedback__c where CC_QAppt__Rating__c != null];
        return rate.size();
    }
    public static List<CC_QAppt__Attendee__c> fetchAttendeeList(Set<id> selectedAttendeeIds){
        if(selectedAttendeeIds !=null){
        return [select id,Name from CC_QAppt__Attendee__c where id In:selectedAttendeeIds];
        }
        else{
         return [select id,Name from CC_QAppt__Attendee__c];
        }
    } 
      public static List<CC_QAppt__Asset__c> fetchAssetList(Set<Id> selectedAssetList){
        if(selectedAssetList !=null){
         return [select id,Name,CC_QAppt__Price__c from CC_QAppt__Asset__c where id In:selectedAssetList];
        }
          else{
            return [select id,Name,CC_QAppt__Price__c from CC_QAppt__Asset__c];
          }
    } 
    public static List<contact> selectedCustomerListForEditAppointment(String appId){
        Set<Id> customerids = new Set<Id>();
     List<Participant__c> PartList = [select Appointment__c,Participant_Name__c from Participant__c where Appointment__c =: appId];    
        for(Participant__c customerId : PartList){
            customerids.add(customerId.Participant_Name__c);
        }
       return [select Id,firstname,lastname,name,email,phone,Description,recordtype.name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode from contact where recordtype.name =: 'User' And Id In:customerids]; 
    }
       public static List<CC_QAppt__Appointment_Detail__c> appointmentDetailforAppointment(String appointmentid,String objName){
        String query ;
        if(objName=='Service'){
           query = 'select id,CC_QAppt__Appointment__c,CC_QAppt__LocationService__r.CC_QAppt__Location__c,CC_QAppt__LocationService__r.CC_QAppt__Service__c,CC_QAppt__LocationService__c,CC_QAppt__Price__c,CC_QAppt__Discount__c from CC_QAppt__Appointment_Detail__c where (CC_QAppt__Appointment__c=:appointmentid And CC_QAppt__LocationService__c != null) And (CC_QAppt__Asset__c = null And CC_QAppt__Resource__c = null)'; 
        }
        if(objName=='Resource'){
            query = 'select id,CC_QAppt__Appointment__c,CC_QAppt__Resource__r.Name,CC_QAppt__Resource__c,CC_QAppt__Price__c,CC_QAppt__Discount__c from CC_QAppt__Appointment_Detail__c where (CC_QAppt__Appointment__c=:appointmentid And CC_QAppt__Resource__c != null) And CC_QAppt__Asset__c = null'; 
        }   
        if(objName=='Asset'){
             query = 'select id,CC_QAppt__Appointment__c,CC_QAppt__Asset__r.Name,CC_QAppt__Asset__c,CC_QAppt__Price__c,CC_QAppt__Discount__c from CC_QAppt__Appointment_Detail__c where (CC_QAppt__Appointment__c=:appointmentid And CC_QAppt__Asset__c != null) And CC_QAppt__Resource__c = null'; 
        }   
       List<CC_QAppt__Appointment_Detail__c> applist = Database.query(query);
           return applist;
    }
    public static List<CC_QAppt__AppointmentTemplate__c> getUserTemplates(String templateId){
        if(templateId != null){
            return [select id,name,CC_QAppt__DisplayFieldJson__c from CC_QAppt__AppointmentTemplate__c where id =: templateId];
        }
        else{
            return [select id,name,CC_QAppt__DisplayFieldJson__c from CC_QAppt__AppointmentTemplate__c];
        }
    }



 }