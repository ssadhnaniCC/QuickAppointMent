public class ServiceLightningController {

    //This is For fetching all Services and fieldset
    @AuraEnabled
    public static ServiceWrapperData getAllServices() {
        ServiceWrapperData wrp = NEW ServiceWrapperData();
        wrp.listOfServices = QuickAppointmentSOQLManager.fetchAllServices();
        wrp.listOfFieldSets = QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Service__c','CC_QAppt__ServiceListFieldSet');
        return wrp;
    }
    
    //Delete Service
    @AuraEnabled
    public static void deleteService(Service__c ser){
        Delete ser;
    } 
    
    @AuraEnabled
    public static List<location__c> getAllLocation(){
        return QuickAppointmentSOQLManager.getLocation();
    }
    
    @AuraEnabled
    public static void saveServiceRecords(CC_QAppt__Service__c serRecord, List<CC_QAppt__Location__c> locValuesList){
        
        system.debug('serRecord=='+serRecord);
        system.debug('locValuesList=='+locValuesList);
        
        CC_QAppt__Service__c appService = NEW CC_QAppt__Service__c();
      
        appService.Name = serRecord.Name;
        appService.CC_QAppt__Description__c = serRecord.CC_QAppt__Description__c;
        appService.CC_QAppt__Duration__c = serRecord.CC_QAppt__Duration__c;
        appService.CC_QAppt__Price__c = serRecord.CC_QAppt__Price__c;
       
        UPSERT appService;
        system.debug('appService@'+appService);
        
        List<Location_Service__c> locserList = NEW List<Location_Service__c>();
        if(locValuesList.size()>0) {
        for(integer i=0; i< locValuesList.size(); i++){
                Location_Service__c LS = NEW Location_Service__c();
                
                LS.Service__c = appService.id;
                LS.location__c = locValuesList[i].ID;
                locserList.add(LS);
            }
        }
        if(locserList.size()>0) {
            UPSERT locserList;
        }
        
    }
    
    @AuraEnabled
    public static List<location__c> getSelectedLocations(String recId) {
        system.debug('recId'+recId);
        //List<Location_Service__c> LocSer = [select location__c, service__c from Location_Service__c where service__c =: BussId];
        system.debug('Location@@'+QuickAppointmentSOQLManager.getSelectedLocationWithSer(recId));
        return QuickAppointmentSOQLManager.getSelectedLocationWithSer(recId);
    }
    
   
    
    //Wrapper Class for storing services and fieldsets
    public class ServiceWrapperData{
        @AuraEnabled public List<Service__c> listOfServices;
        @AuraEnabled public List<QuickAppointmentUtils.FieldSetProperties> listOfFieldSets;
    }
}