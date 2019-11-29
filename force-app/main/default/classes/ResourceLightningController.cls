/**
* @author Cloud Certitude
* @date OCTOBER 2019
* @description This class is used to display, edit & delete Contact records where RecordType is 'Resource'
*/
public class ResourceLightningController {   
   /*******************************************************************************************************
    * @description This is the method which returns All the Resources.
   * @returns Returns List of Contact resources on PageLoad.
   */
    @AuraEnabled
    public static List<Contact> getAllResources(){
        return QuickAppointmentSOQLManager.fetchAllResourceStaff(null);
    } 
   /*******************************************************************************************************
    * @description This  method is used to save new resource Information 
   * @returns Returns void 
   */
    @AuraEnabled
    public static void saveNewResources(Contact resourceObj,List<Id> selectedLocationList,List<Id> selectedServiceList){
       // system.debug('newResourceCon');
       Set<id> alignmentIds = new Set<Id>();
       List<Resource_Service_Alignment__c> saveResourceAlignment = new List<Resource_Service_Alignment__c>(); 
       String selectedType = 'Resource';
       Id TypeRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(selectedType).getRecordTypeId();
        Contact newResourceCon = new Contact();
        newResourceCon.Id = resourceObj.Id;
        newResourceCon.RecordTypeId = TypeRecordTypeId;
        if(resourceObj.Name.CONTAINS(' ')){
            list<string> tempList = resourceObj.Name.split(' ');
            newResourceCon.firstname = tempList[0];
            newResourceCon.lastname = tempList[1];
        }else{
            newResourceCon.lastname = resourceObj.Name;
        }
            newResourceCon.MailingStreet = resourceObj.MailingStreet;
            newResourceCon.MailingCity = resourceObj.MailingCity;
            newResourceCon.Mailingstate = resourceObj.MailingState;
            newResourceCon.MailingPostalCode = resourceObj.MailingPostalCode;
            newResourceCon.MailingCountry = resourceObj.MailingCountry;
            newResourceCon.Phone = resourceObj.Phone;            
        try{
            upsert newResourceCon;
          //  system.debug('newResourceCon'+newResourceCon.Id);
           }
        catch(Exception e){
        //    system.debug('Upsert Exception'+e);
        }
        // For Delete Alignments
      List<Resource_Service_Alignment__c> DeleteAlignments = new List<Resource_Service_Alignment__c>();
          DeleteAlignments   =     QuickAppointmentSOQLManager.previousResourceServiceAlignemnts(null,newResourceCon.Id);
        for(Resource_Service_Alignment__c ali : DeleteAlignments){
            alignmentIds.add(ali.id);
        }
        List<appointment__c> DeleteAppointment = new List<appointment__c>();
        if(alignmentIds.size() > 0){
             DeleteAppointment = QuickAppointmentSOQLManager.getAppointments(alignmentIds);
        }
      /******  Delete Previous Appointmnents     ******/
       if(DeleteAppointment.size()>0){
            if(appointment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteAppointment;
            }
        }
        /******  Delete Previous ResourceServicesAlignment     ******/
        if(DeleteAlignments.size() > 0){
            if(Resource_Service_Alignment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteAlignments;
            }
        }
        /****** List to fill  Resource Service Alignment ***/
         for(integer i=0; i< selectedLocationList.size(); i++){
            for(integer j=0; j<selectedServiceList.size(); j++){
                Resource_Service_Alignment__c Alignments = new Resource_Service_Alignment__c();
                Alignments.location__c = selectedLocationList[i];
                Alignments.service__c  = selectedServiceList[j];
                Alignments.Resource_Staff__c = newResourceCon.Id;
                saveResourceAlignment.add(Alignments);
            }
        }
        if(saveResourceAlignment.size()>0){
           try{
                insert saveResourceAlignment;
             }
            catch(Exception e){
          //      system.debug('Exception'+e);
            }
        }
    }
    /*******************************************************************************************************
    * @description This is the method which returns FieldSet for ResourceStaff.
    * @returns Returns List of fileds in fieldset on PageLoad.
    */
    @AuraEnabled
    public static List<Object> getResourceFieldSet(){
        return QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Contact','CC_QAppt__ResourceStaffFieldSet');
    }
     /*******************************************************************************************************
    * @description This is the method which returns All the available Locations.
   * @returns Returns List of Locations on PageLoad.
   */
    @AuraEnabled
    public static List<CC_QAppt__Location__c> getAllAvailableLocation(){
        return QuickAppointmentSOQLManager.getLocation();
    }
    @AuraEnabled
    public static List<CC_QAppt__Service__c> getServicesBasedOnLocation(List<Id> selectedLocationIds){
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
    public static void deleteResourceStaff(String resourceStaffId){
       List<contact> resourceList =  QuickAppointmentSOQLManager.fetchAllResourceStaff(resourceStaffId);
        if(resourceList.size()>0){
            try{
                delete resourceList[0];
            }
            catch(Exception ex){
            }
        }

    }
    /*******************************************************************************************************
    * @description This is the method which returns wrapper for Resources and its resource service alignments.
   * @returns Returns wrapper on Edit record Row Action.
   */   
    @AuraEnabled
    public static ResourceServiceWrapper getResourcesOnEdit(String selectedResourceId){
        Set<Id> selectedlocationIds = new Set<Id>();
      List<contact> resourceList     = QuickAppointmentSOQLManager.fetchAllResourceStaff(selectedResourceId);
       List<CC_QAppt__Resource_Service_Alignment__c> resourceService = QuickAppointmentSOQLManager.previousResourceServiceAlignemnts(null,selectedResourceId);
       for(CC_QAppt__Resource_Service_Alignment__c loclist   : resourceService){
          selectedlocationIds.add(loclist.CC_QAppt__Location__c);
       }
     List<CC_QAppt__Location_Service__c> availableServices = QuickAppointmentSOQLManager.getDependentService(selectedlocationIds);
        ResourceLightningController.ResourceServiceWrapper wrappResourceService = new ResourceLightningController.ResourceServiceWrapper(resourceList[0],resourceService,availableServices);
        return wrappResourceService;
        
     }
    
   
    public class ResourceServiceWrapper{
     @AuraEnabled
     public  contact resContact;
     @AuraEnabled
     public  List<CC_QAppt__Resource_Service_Alignment__c> resourceServiceList;
     @AuraEnabled
     public  List<CC_QAppt__Location_Service__c> availableResourceServiceList;
        public ResourceServiceWrapper(Contact resourceContact , List<CC_QAppt__Resource_Service_Alignment__c> resServiceList,List<CC_QAppt__Location_Service__c> availservice){
           resContact =  resourceContact;
           resourceServiceList =  resServiceList;
           availableResourceServiceList =  availservice;
        }
   
    }
}