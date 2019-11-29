public class NewEditAppointmentController {
    @AuraEnabled
   public static List<CC_QAppt__Appointment_Category__c> getAppointmentCategory(){
        return QuickAppointmentSOQLManager.getAppointmentCategories(null);
    }
    @AuraEnabled
    public static List<CC_QAppt__Service__c> getDependentServices(List<Id> selectedLocationIds){
          Set<Id> locationIds = new Set<Id>();
        Set<Id> servicesId = new Set<Id>();
        locationIds.addAll(selectedLocationIds);
        List<CC_QAppt__Location_Service__c> locationservices = QuickAppointmentSOQLManager.getDependentService(locationIds);
        for(CC_QAppt__Location_Service__c locserv : locationservices){
            servicesId.add(locserv.CC_QAppt__Service__c);
        }
        return QuickAppointmentSOQLManager.fetchSelectedServiceForAppointment(servicesId);
    }
    @AuraEnabled
    public Static List<CC_QAppt__Location__c> getLocations(){
          return QuickAppointmentSOQLManager.getLocation();      
    }
    @AuraEnabled 
    public Static List<CC_QAppt__Service__c> getServices(){
          return QuickAppointmentSOQLManager.fetchAllServices();        
    }
    @AuraEnabled 
    public static List<contact> getResources(){
            return QuickAppointmentSOQLManager.fetchAllResourceStaff(null);        
    }
    @AuraEnabled 
    public static List<CC_QAppt__Attendee__c> getAttendee(){
         return QuickAppointmentSOQLManager.fetchAttendeeList(null);  
    }
    @AuraEnabled
    public static List<contact> getResourceBasedOnService(List<Id> selectedServiceIds){
         Set<Id> serviceIds = new Set<Id>();
        serviceIds.addAll(selectedServiceIds);
        return QuickAppointmentSOQLManager.getDependentResourceStaff(serviceIds);
        
    }
    @AuraEnabled
    public static List<contact>  getResourceBasedOnLocation(List<Id> selectedLocationIds){
         Set<Id> locationIds = new Set<Id>();
        locationIds.addAll(selectedLocationIds);
         return QuickAppointmentSOQLManager.getResourceStaffBasedOnLocation(locationIds);
    }
    @AuraEnabled
    public static List<String> fetchStatusOfAppointment(){
        List<String> lstPickvals = new List<String>();
        Schema.DescribeFieldResult appointmentStatus = CC_QAppt__Appointment__c.CC_QAppt__Status__c.getDescribe();
        List<Schema.PicklistEntry> appointmentStatusValues = appointmentStatus.getPicklistValues();
        for(Schema.PicklistEntry str : appointmentStatusValues){
            lstPickvals.add(str.getValue());
        }
        return lstPickvals;
    }
     @AuraEnabled
    public static list<Object> getFields(){
         return QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Contact','CC_QAppt__CustomerListFieldset');
    }
    @AuraEnabled
    public static List<Contact> getCustomers(){
          return QuickAppointmentSOQLManager.getRecentCustomers();
    }  
    @AuraEnabled 
    public static List<CC_QAppt__Asset__c> getAsset(){
         return QuickAppointmentSOQLManager.fetchAssetList(null);  
    }
    @AuraEnabled 
    public static List<contact> searchCustomer(String customerName){
          return QuickAppointmentSOQLManager.filterCustomers(customerName);
    }
    @AuraEnabled
    public static void createAppointment(String appointmentId,String appointmentName,String selectedLocationIds,String selectedServiceIds,String selectedResourceIds ,
                                        String selectedAssetIds , String selectedAttendeeIds , String statusOfAppointment , String startDate,
                                        String startTime, Integer duration ,String description , Decimal appointmentDiscount,Decimal totalPrice, Id appointmentCategory,List<contact> selectedCustomer){  
       
      list<string> timeList = startTime.split(':');                                         
      list<string> dtList = startDate.split('-');
      try
          {    
              date startdt = Date.newInstance(Integer.valueOf(dtList[0]),Integer.valueOf(dtList[1]),Integer.valueOf(dtList[2].trim()));
              Time myTime = Time.newInstance(Integer.valueOf(timeList[0].trim()),Integer.valueOf(timeList[1].trim()),0,0);
              set<id> resourceIds = new set<id>();
              CC_QAppt__Appointment__c app = new  CC_QAppt__Appointment__c();      
              app.Id  = appointmentId;
              app.Name   =  appointmentName;                               
              app.CC_QAppt__Locations__c  = selectedLocationIds;
              app.CC_QAppt__Services__c =   selectedServiceIds;
              app.CC_QAppt__Resources__c =  selectedResourceIds; 
              app.CC_QAppt__Assets__c  =  selectedAssetIds;
              app.CC_QAppt__Duration__c =  duration;
              app.CC_QAppt__TotalPrice__c = totalPrice;                                
              app.CC_QAppt__Attendees__c =  selectedAttendeeIds;
              app.CC_QAppt__Status__c    =  statusOfAppointment ;
              app.CC_QAppt__Description__c = description ;                                
              app.CC_QAppt__Start_Date_Time__c   = datetime.newInstance(startdt,myTime);  
              app.CC_QAppt__End_Date_Time__c =  datetime.newInstance(startdt,myTime).addMinutes(duration);   
              app.CC_QAppt__Discount__c =   appointmentDiscount;
              app.CC_QAppt__Appointment_Category__c =  appointmentCategory;                              
              upsert app;     
            
              List<Participant__c> tempListDelete = new List<Participant__c>();
              if(appointmentId != ''){
                  tempListDelete =   [select Participant_Name__c,Appointment__c from Participant__c where Appointment__c =: appointmentId];  
                  if(tempListDelete.size()>0){
                      delete tempListDelete;
                  }                                 
              }                             
           List<Participant__c> PList = new List<Participant__c>();
           for(contact customer   : selectedCustomer) {
              Participant__c participant = new Participant__c();
                participant.Participant_Name__c = customer.id;
                participant.Appointment__c = app.id;
                PList.add(participant);                                   
             }              
                                            
             if(PList.size()>0){
                  insert PList;      
             }
         }
          catch(Exception ex){
              throw new AuraHandledException(ex.getMessage());
           }
    }
    @AuraEnabled
    public static WrappAppointmentEditForm editAppointment(String appointmentId){
        
       Set<Id> selectedLocations = new Set<Id>();
       Set<Id> selectedServices = new Set<Id>();
       Set<Id> selectedResources = new Set<Id>();
       Set<Id> selectedAssets = new Set<Id>();
       Set<Id> selectedAttendees = new Set<Id>();
        
        
       List<CC_QAppt__Appointment__c> selectedAppointment = QuickAppointmentSOQLManager.getAppointmentOnEdit(appointmentId); 
       List<CC_QAppt__Appointment_Category__c> selectedAppointmentCategory = QuickAppointmentSOQLManager.getAppointmentCategories(selectedAppointment[0].CC_QAppt__Appointment_Category__c);  
        
        if(!String.isBlank(selectedAppointment[0].CC_QAppt__Locations__c)){
          List<Id> LocationsIds = selectedAppointment[0].CC_QAppt__Locations__c.split(',');
          selectedLocations.addAll(LocationsIds);
        }
        if(!String.isBlank(selectedAppointment[0].CC_QAppt__Services__c)){
         List<Id> servicesIds = selectedAppointment[0].CC_QAppt__Services__c.split(',');
         selectedServices.addAll(servicesIds);
        }
         if(!String.isBlank(selectedAppointment[0].CC_QAppt__Resources__c)){
           List<Id> resourceIds = selectedAppointment[0].CC_QAppt__Resources__c.split(',');
           selectedResources.addAll(resourceIds);  
          }
         if(!String.isBlank(selectedAppointment[0].CC_QAppt__Assets__c)){
              List<Id> assetIds = selectedAppointment[0].CC_QAppt__Assets__c.split(','); 
              selectedAssets.addAll(assetIds);
          }
          if(!String.isBlank(selectedAppointment[0].CC_QAppt__Attendees__c)){
            List<Id> attendeeIds = selectedAppointment[0].CC_QAppt__Attendees__c.split(',');
            selectedAttendees.addAll(attendeeIds);
          } 
        List<CC_QAppt__Location__c> selectedLocationList = QuickAppointmentSOQLManager.fetchSelectedLocationForAppointment(selectedLocations);
        List<CC_QAppt__Service__c> selectedServicesList = QuickAppointmentSOQLManager.fetchSelectedServiceForAppointment(selectedServices);
        List<contact> selectedResourcesList = QuickAppointmentSOQLManager.fetchSelectedResourcesForAppointment(selectedResources);
        List<CC_QAppt__Asset__c> selectedAssetList = QuickAppointmentSOQLManager.fetchAssetList(selectedAssets);
        List<CC_QAppt__Attendee__c> selectedAttendeeList =  QuickAppointmentSOQLManager.fetchAttendeeList(selectedAttendees);
        List<contact> selectedcustomerList = QuickAppointmentSOQLManager.selectedCustomerListForEditAppointment(appointmentId);
        
        Date myDate = date.newinstance(selectedAppointment[0].CC_QAppt__Start_Date_Time__c.year(),selectedAppointment[0].CC_QAppt__Start_Date_Time__c.month(),selectedAppointment[0].CC_QAppt__Start_Date_Time__c.day());
        String startdate  = String.valueOf(myDate);
        String startDateTime =  selectedAppointment[0].CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a');
        List<String> starttime =  startDateTime.split(' ');
         String timeofAppointment = starttime[1]+' '+starttime[2];
        NewEditAppointmentController.WrappAppointmentEditForm wrappEdit = new NewEditAppointmentController.WrappAppointmentEditForm();
          wrappEdit.appointmentCategory = selectedAppointmentCategory;
          wrappEdit.selectedlocationList = selectedLocationList;
          wrappEdit.selectedserviceList = selectedServicesList;
          wrappEdit.selectedresourceList = selectedResourcesList;
          wrappEdit.selectedattendeeList = selectedAttendeeList;
          wrappEdit.selectedcustomerList = selectedcustomerList;
          wrappEdit.selectedassetList = selectedAssetList;
          wrappEdit.discount = selectedAppointment[0].CC_QAppt__Discount__c;
          wrappEdit.Status =   selectedAppointment[0].CC_QAppt__Status__c;
          wrappEdit.duration = selectedAppointment[0].CC_QAppt__Duration__c;
          wrappEdit.totalPrice = selectedAppointment[0].CC_QAppt__TotalPrice__c;
          wrappEdit.startDate = startdate;
          wrappEdit.startTime = timeofAppointment;
          wrappEdit.description = selectedAppointment[0].CC_QAppt__Description__c;
          wrappEdit.AppointmentName = selectedAppointment[0].Name;
        return wrappEdit;
        
    }
    public class WrappAppointmentEditForm {
        @AuraEnabled public List<CC_QAppt__Appointment_Category__c> appointmentCategory;
        @AuraEnabled public List<CC_QAppt__Location__c> selectedlocationList;
        @AuraEnabled public List<CC_QAppt__Service__c> selectedserviceList;
        @AuraEnabled public List<contact>  selectedresourceList; 
        @AuraEnabled public List<CC_QAppt__Attendee__c> selectedattendeeList;
        @AuraEnabled public List<CC_QAppt__Asset__c> selectedassetList;
        @AuraEnabled public List<contact>  selectedcustomerList;
        @AuraEnabled public String AppointmentName;
        @AuraEnabled public Decimal discount;
        @AuraEnabled public string startDate;
        @AuraEnabled public string startTime;
        @AuraEnabled public Decimal totalPrice;
        @AuraEnabled public Decimal duration;
        @AuraEnabled public string Status;
        @AuraEnabled public string description;
    }
    
}