public without sharing class NewEditAppointmentController {
 
   @AuraEnabled
   public static List<CC_QAppt__Appointment_Category__c> getAppointmentCategory(Boolean isPublic){
        return QuickAppointmentSOQLManager.getAppointmentCategories(null, isPublic);
    }
    @AuraEnabled
    public static List<CC_QAppt__Location_Service__c> getDependentServices(List<Id> selectedLocationIds){
          Set<Id> locationIds = new Set<Id>();
        Set<Id> servicesId = new Set<Id>();
        locationIds.addAll(selectedLocationIds);
         return QuickAppointmentSOQLManager.getDependentService(locationIds);
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
    public static Map<Id,CC_QAppt__Resource_Service_Alignment__c> getResources(){
     Map<Id,CC_QAppt__Resource_Service_Alignment__c> mapOfResourceService = new Map<Id,CC_QAppt__Resource_Service_Alignment__c>(); 
   
        List<CC_QAppt__Resource_Service_Alignment__c> resourceServiceList  = QuickAppointmentSOQLManager.fetchResourceServiceAlignments();
         for(CC_QAppt__Resource_Service_Alignment__c resource : resourceServiceList){
            if(!mapOfResourceService.containsKey(resource.CC_QAppt__Resource_Staff__c)){
                mapOfResourceService.put(resource.CC_QAppt__Resource_Staff__c,resource);
            }
        }
        return mapOfResourceService;
        
    }
   // @AuraEnabled 
  /*  public static List<CC_QAppt__Attendee__c> getAttendee(){
         return QuickAppointmentSOQLManager.fetchAttendeeList(null);  
    }*/
    @AuraEnabled
    public static Map<Id,CC_QAppt__Resource_Service_Alignment__c> getResourceBasedOnService(List<Id> selectedServiceIds){
       Map<Id,CC_QAppt__Resource_Service_Alignment__c> mapOfResourceService = new Map<Id,CC_QAppt__Resource_Service_Alignment__c>(); 
        Set<Id> serviceIds = new Set<Id>();
        serviceIds.addAll(selectedServiceIds);
      List<CC_QAppt__Resource_Service_Alignment__c> resourceServiceList = QuickAppointmentSOQLManager.getDependentResourceStaff(serviceIds);
        for(CC_QAppt__Resource_Service_Alignment__c resource : resourceServiceList){
            if(!mapOfResourceService.containsKey(resource.CC_QAppt__Resource_Staff__c)){
                mapOfResourceService.put(resource.CC_QAppt__Resource_Staff__c,resource);
            }
        }
        return mapOfResourceService;
    }
    @AuraEnabled
    public static Map<Id,CC_QAppt__Resource_Service_Alignment__c>  getResourceBasedOnLocation(List<Id> selectedLocationIds){
      Map<Id,CC_QAppt__Resource_Service_Alignment__c> mapOfResourceService = new Map<Id,CC_QAppt__Resource_Service_Alignment__c>(); 
         Set<Id> locationIds = new Set<Id>();
        locationIds.addAll(selectedLocationIds);
       List<CC_QAppt__Resource_Service_Alignment__c> resourceServiceList =  QuickAppointmentSOQLManager.getResourceStaffBasedOnLocation(locationIds);
        for(CC_QAppt__Resource_Service_Alignment__c resource : resourceServiceList){
            if(!mapOfResourceService.containsKey(resource.CC_QAppt__Resource_Staff__c)){
                mapOfResourceService.put(resource.CC_QAppt__Resource_Staff__c,resource);
            }
        }
        return mapOfResourceService;
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
    public static void createAppointment(String appointmentId,String appointmentName,List<String> selectedResourceIds ,
                                        List<String> selectedAssetIds ,String selectedLocService, List<String> selectedLocationId , List<String> selectedServiceId,String statusOfAppointment , String startDate,
                                        String startTime, Integer duration ,String description , Decimal totalPrice, Id appointmentCategory,List<contact> selectedCustomer,List<wrappedPriceList> pricingOfList){  
       
      list<string> timeList = startTime.split(':');                                         
      list<string> dtList = startDate.split('-');
          try{
              date startdt = Date.newInstance(Integer.valueOf(dtList[0]),Integer.valueOf(dtList[1]),Integer.valueOf(dtList[2].trim()));
              Time myTime = Time.newInstance(Integer.valueOf(timeList[0].trim()),Integer.valueOf(timeList[1].trim()),0,0);
              set<id> resourceIds = new set<id>();
              CC_QAppt__Appointment__c app = new  CC_QAppt__Appointment__c();      
              app.Id  = appointmentId;
              app.Name   =  appointmentName;                               
              app.CC_QAppt__Duration__c =  duration;
              app.CC_QAppt__TotalPrice__c = totalPrice;                                
              app.CC_QAppt__Status__c    =  statusOfAppointment ;
              app.CC_QAppt__Description__c = description ;                                
              app.CC_QAppt__Start_Date_Time__c   = datetime.newInstance(startdt,myTime);  
              app.CC_QAppt__End_Date_Time__c =  datetime.newInstance(startdt,myTime).addMinutes(duration);   
              app.CC_QAppt__Appointment_Category__c =  appointmentCategory;                              
               upsert app;     
            
              List<Participant__c> tempListDelete = new List<Participant__c>();
              List<CC_QAppt__Appointment_Detail__c> deleteDetailList  = new List<CC_QAppt__Appointment_Detail__c>(); 
              if(appointmentId != ''){
                  tempListDelete =   [select Participant_Name__c,Appointment__c from Participant__c where Appointment__c =: appointmentId];  
                  if(tempListDelete.size()>0){
                      delete tempListDelete;
                  } 
                 deleteDetailList = [select id from CC_QAppt__Appointment_Detail__c where CC_QAppt__Appointment__c =: appointmentId];
                  if(deleteDetailList.size()>0){
                      delete deleteDetailList;
                  } 
              }  
              
           List<Participant__c> ParticipantList = new List<Participant__c>();
           List<CC_QAppt__Appointment_Detail__c> appointmentDetailList  = new List<CC_QAppt__Appointment_Detail__c>(); 
           //Insert Customers for Appointment
           for(contact customer   : selectedCustomer) {
              Participant__c participant = new Participant__c();
                participant.CC_QAppt__LocationService__c = selectedLocService;
                participant.Participant_Name__c = customer.id;
                participant.Appointment__c = app.id;
                ParticipantList.add(participant);                                   
             }  
              
              Integer AssetCount =  0;
              Integer ResourceCount = 0;
              
              for(Integer i=0 ;i<pricingOfList.size();i++){                 
                  
                  if(pricingOfList[i].ListType == 'Service'){
                   CC_QAppt__Appointment_Detail__c appdetail = new CC_QAppt__Appointment_Detail__c();
                   appdetail.CC_QAppt__LocationService__c = selectedLocService;
                   appdetail.CC_QAppt__Discount__c =   pricingOfList[i].Discount;
                   appdetail.CC_QAppt__Price__c =  pricingOfList[i].TotalPrice;
                   appdetail.CC_QAppt__Appointment__c = app.id;
                   appointmentDetailList.add(appdetail);                                   
                  }
                  
                  if(pricingOfList[i].ListType == 'Resource'){
                    //  while(ResourceCount < selectedResourceIds.size()){
                        CC_QAppt__Appointment_Detail__c appdetail = new CC_QAppt__Appointment_Detail__c();
                             appdetail.CC_QAppt__LocationService__c = selectedLocService;
                             appdetail.CC_QAppt__Appointment__c = app.id;
                             appdetail.CC_QAppt__Resource__c =  pricingOfList[i].Id; 
                             appdetail.CC_QAppt__Discount__c =   pricingOfList[i].Discount;
                             appdetail.CC_QAppt__Price__c =  pricingOfList[i].TotalPrice; 
                             appointmentDetailList.add(appdetail);  
                       //      ResourceCount++;
                     // }
                  }
                  
                  if(pricingOfList[i].ListType == 'Asset'){
                     // while(AssetCount < selectedAssetIds.size()){
                        CC_QAppt__Appointment_Detail__c appdetail = new CC_QAppt__Appointment_Detail__c();
                         appdetail.CC_QAppt__LocationService__c = selectedLocService;
                         appdetail.CC_QAppt__Appointment__c = app.id;
                         appdetail.CC_QAppt__Asset__c = pricingOfList[i].Id;
                         appdetail.CC_QAppt__Discount__c =   pricingOfList[i].Discount;
                         appdetail.CC_QAppt__Price__c =  pricingOfList[i].TotalPrice;  
                         appointmentDetailList.add(appdetail);     
                         //AssetCount++;
                   //   } 
                  }
                  
              }
                     
             if(ParticipantList.size()>0){
                insert ParticipantList;      
             }
              if(appointmentDetailList.size()>0){
                insert appointmentDetailList;      
              }
         
         }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
         }
    }
    
    
    
    @AuraEnabled
    public static WrappAppointmentEditForm editAppointment(String appointmentId){

       List<CC_QAppt__Appointment__c> selectedAppointment = QuickAppointmentSOQLManager.getAppointmentOnEdit(appointmentId); 
       List<CC_QAppt__Appointment_Category__c> selectedAppointmentCategory = QuickAppointmentSOQLManager.getAppointmentCategories(selectedAppointment[0].CC_QAppt__Appointment_Category__c, null); 
       List<contact> selectedcustomerList = QuickAppointmentSOQLManager.selectedCustomerListForEditAppointment(appointmentId);
        
       List<CC_QAppt__Appointment_Detail__c> appointmentdetailForService  =  QuickAppointmentSOQLManager.appointmentDetailforAppointment(appointmentId,'Service');
        
       List<CC_QAppt__Appointment_Detail__c> appointmentdetailForResource  =  QuickAppointmentSOQLManager.appointmentDetailforAppointment(appointmentId,'Resource');
        
       List<CC_QAppt__Appointment_Detail__c> appointmentdetailForAsset  =  QuickAppointmentSOQLManager.appointmentDetailforAppointment(appointmentId,'Asset');
       
        List<Id> selectedLocationList = new List<Id>();
        List<Id> selectedServicesList = new List<Id>();
        Set<Id> selectedServiceId = new Set<Id>();
        List<Id> selectedResourcesList = new List<Id>();
        List<Id> selectedAssetList = new List<Id>();
        
        selectedServiceId.add(appointmentdetailForService[0].CC_QAppt__LocationService__r.CC_QAppt__Service__c);
        
        List<CC_QAppt__Service__c> serviceDetail = QuickAppointmentSOQLManager.fetchSelectedServiceForAppointment(selectedServiceId);
        
        List<wrappedPriceList> wrapPriceList = new List<wrappedPriceList>();
        
        selectedLocationList.add(appointmentdetailForService[0].CC_QAppt__LocationService__r.CC_QAppt__Location__c);
        selectedServicesList.add(appointmentdetailForService[0].CC_QAppt__LocationService__r.CC_QAppt__Service__c);
        
        for(CC_QAppt__Appointment_Detail__c res : appointmentdetailForResource){
        selectedResourcesList.add(res.CC_QAppt__Resource__c);
        }
        for(CC_QAppt__Appointment_Detail__c asset : appointmentdetailForAsset){
        selectedAssetList.add(asset.CC_QAppt__Asset__c);
        }
        
        for(CC_QAppt__Appointment_Detail__c appdetailsForService : appointmentdetailForService){
            wrappedPriceList priceobj = new wrappedPriceList();
            priceobj.Id = appdetailsForService.CC_QAppt__LocationService__r.CC_QAppt__Service__c;
            priceobj.ListType ='Service';
            priceobj.Discount = appdetailsForService.CC_QAppt__Discount__c;
            priceobj.TotalPrice = appdetailsForService.CC_QAppt__Price__c;
            priceobj.Name = serviceDetail[0].Name; 
            wrapPriceList.add(priceobj);
        }
        for(CC_QAppt__Appointment_Detail__c appdetailsForResource : appointmentdetailForResource){
            wrappedPriceList priceobj = new wrappedPriceList();
            priceobj.Id = appdetailsForResource.CC_QAppt__Resource__c;
            priceobj.ListType ='Resource';
            priceobj.Discount = appdetailsForResource.CC_QAppt__Discount__c;
            priceobj.TotalPrice = appdetailsForResource.CC_QAppt__Price__c; 
            priceobj.Name = appdetailsForResource.CC_QAppt__Resource__r.Name; 
            wrapPriceList.add(priceobj);
        }
         for(CC_QAppt__Appointment_Detail__c appdetailsForAsset : appointmentdetailForAsset){
            wrappedPriceList priceobj = new wrappedPriceList();
            priceobj.Id = appdetailsForAsset.CC_QAppt__Asset__c;
            priceobj.ListType ='Asset';
            priceobj.Discount = appdetailsForAsset.CC_QAppt__Discount__c;
            priceobj.TotalPrice = appdetailsForAsset.CC_QAppt__Price__c; 
            priceobj.Name = appdetailsForAsset.CC_QAppt__Asset__r.Name; 
            wrapPriceList.add(priceobj);
        }

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
          wrappEdit.selectedcustomerList = selectedcustomerList;
          wrappEdit.selectedassetList = selectedAssetList;
           wrappEdit.wrappprice = wrapPriceList;
          wrappEdit.Status =   selectedAppointment[0].CC_QAppt__Status__c;
          wrappEdit.duration = selectedAppointment[0].CC_QAppt__Duration__c;
          wrappEdit.totalPrice = selectedAppointment[0].CC_QAppt__TotalPrice__c;
          wrappEdit.startDate = startdate;
          wrappEdit.startTime = timeofAppointment;
          wrappEdit.description = selectedAppointment[0].CC_QAppt__Description__c;
          wrappEdit.AppointmentName = selectedAppointment[0].Name;
        return wrappEdit;
        
    }
    @AuraEnabled
    public static List<NewEditAppointmentController.UserTemplate> getUserTemplate(String selectedTemplate) {
        List<CC_QAppt__AppointmentTemplate__c> lstapp = QuickAppointmentSOQLManager.getUserTemplates(selectedTemplate);
        List<NewEditAppointmentController.UserTemplate> resp = (List<NewEditAppointmentController.UserTemplate>) JSON.deserialize(lstapp[0].CC_QAppt__DisplayFieldJson__c, List<NewEditAppointmentController.UserTemplate>.class);
        return resp;
        
    }
    @AuraEnabled
    public static List<CC_QAppt__AppointmentTemplate__c> getTemplateList(){
         return QuickAppointmentSOQLManager.getUserTemplates(null);           
        
    }
    public class WrappAppointmentEditForm {
        @AuraEnabled public List<CC_QAppt__Appointment_Category__c> appointmentCategory;
        @AuraEnabled public List<Id> selectedlocationList;
        @AuraEnabled public List<Id> selectedserviceList;
        @AuraEnabled public List<Id>  selectedresourceList; 
        @AuraEnabled public List<Id> selectedassetList;
        @AuraEnabled public List<contact>  selectedcustomerList;
        @AuraEnabled public String AppointmentName;
        @AuraEnabled public string startDate;
        @AuraEnabled public string startTime;
        @AuraEnabled public Decimal totalPrice;
        @AuraEnabled public Decimal duration;
        @AuraEnabled public string Status;
        @AuraEnabled public string description;
        @AuraEnabled public List<wrappedPriceList> wrappprice;
    }
    
    public class ContactWrapper {
        @AuraEnabled public ID Id;
        @AuraEnabled public string Name;
        @AuraEnabled public string Email;
        @AuraEnabled public string Phone;
        @AuraEnabled public string MailingCity;
        @AuraEnabled public string MailingState;
        
        public ContactWrapper(){}
        
     /*   public ContactWrapper(ID Id, String Name, String Email, String Phone, String MailingCity, string MailingState){
            this.Id = Id;
            this.Name = Name;
            this.Email = Email;
            this.Phone = Phone;
            this.MailingCity = MailingCity;
            this.MailingState = MailingState;
        }*/
        
    }
    
    
    public class wrappedPriceList{
        @AuraEnabled  public string Id {get;set;}
        @AuraEnabled   public  Decimal Discount {get;set;}
        @AuraEnabled  public String ListType {get;set;}
        @AuraEnabled public String Name {get;set;}
        @AuraEnabled  public Decimal Price {get;set;}
        @AuraEnabled public Decimal TotalPrice {get;set;}
    }
    public class UserTemplate{
        @AuraEnabled public string sectionname;
        @AuraEnabled public List<fieldsList> fields;
    }
    public class fieldsList{
      @AuraEnabled  public String fieldName;
      @AuraEnabled  public String sortOrder;
      @AuraEnabled public String datatype;
        
    } 
}