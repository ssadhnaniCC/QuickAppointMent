/**
* @author Cloud Certitude
* @date OCTOBER 2019
* @description This class is used to display, edit & delete Service records
*/
public class ServiceLightningController {

    /*******************************************************************************************************
    * @description This is the method which returns All the Services.
   * @returns Returns Wrapper of Sevices with fieldsets.
   */
    @AuraEnabled
    public static ServiceWrapperData getAllServices() {
        ServiceWrapperData wrp = NEW ServiceWrapperData();
        wrp.listOfServices = QuickAppointmentSOQLManager.fetchAllServices();
        wrp.listOfFieldSets = QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Service__c','CC_QAppt__ServiceListFieldSet');
        return wrp;
    }
    
    /*******************************************************************************************************
    * @description This is the method which used for deleting service record.
     */
    @AuraEnabled
    public static void deleteService(Service__c ser){
        Delete ser;
    } 
    
     /*******************************************************************************************************
    * @description This is the method which returns All the Location.
   * @returns Returns List of Locations.
   */
    @AuraEnabled
    public static List<location__c> getAllLocation(){
        return QuickAppointmentSOQLManager.getLocation();
    }
    
    
     /*******************************************************************************************************
    * @description This is the Method to save new service records with location in location/service.
    */
    @AuraEnabled
    public static void saveServiceRecords(CC_QAppt__Service__c serRecord, List<Id> locValuesList){
        
        system.debug('serRecord=='+serRecord);
        system.debug('locValuesList=='+locValuesList);
        
        CC_QAppt__Service__c appService = NEW CC_QAppt__Service__c();
      
        appService.Id = serRecord.Id;
        appService.Name = serRecord.Name;
        appService.CC_QAppt__Description__c = serRecord.CC_QAppt__Description__c;
        appService.CC_QAppt__Duration__c = serRecord.CC_QAppt__Duration__c;
        appService.CC_QAppt__Price__c = serRecord.CC_QAppt__Price__c;
       
        try{
        UPSERT appService;
            }
        catch(Exception e){
                    system.debug('Exception'+e);                 
                }
        
       List<Location_Service__c> locServiceList = NEW List<Location_Service__c>();
       for(integer i=0; i< locValuesList.size(); i++){
            
                Location_Service__c locService = new Location_Service__c();
                locService.location__c = locValuesList[i];
                locService.service__c  = appService.Id;
                
                locServiceList.add(locService);
            
        }
        if(locServiceList.size()>0){
           try{
                UPSERT locServiceList;
               system.debug('locServiceList=='+locServiceList[0].id);
             }
            catch(Exception e){
                system.debug('Exception'+e);
            }
        }
        
    }
    
    
     /*******************************************************************************************************
    * @description This is the Method for getting selected locations based on service Id.
   */
    @AuraEnabled
    public static ServiceWrapperData getSelectedLocations(String recId) {
        system.debug('recId'+recId);
        ServiceWrapperData swd = NEW ServiceWrapperData();
        Service__c serRecord = [select name,Description__c,Duration__c,Price__c from Service__c where id=:recId];
        swd.serviceRecord = serRecord;
        swd.locRecord = QuickAppointmentSOQLManager.getSelectedLocationWithSer(recId);
        system.debug('Location@@'+QuickAppointmentSOQLManager.getSelectedLocationWithSer(recId));
        return swd;
    }
    
   
    
    //Wrapper Class for storing services and fieldsets
    public class ServiceWrapperData{
        @AuraEnabled public List<Service__c> listOfServices;
        @AuraEnabled public List<QuickAppointmentUtils.FieldSetProperties> listOfFieldSets;
        @AuraEnabled public Service__c serviceRecord;
        @AuraEnabled public List<location__c> locRecord;
    }
}