/**
* @author QuickAppointment
* @date OCTOBER 2019
*
* @description This is the controller class of LightningListController and NewLocation Lightning Controler.
* @used to fetch, insert and delete records
**/
public class LocationLightningControler {
    
    /*******************************************************************************************************
    * @description This method is used for getting data of Location sObject.
    * @returns List of Location.
    */
    @AuraEnabled
    public Static List<CC_QAppt__Location__c> getLocation(){
        List<CC_QAppt__Location__c> locationList = QuickAppointmentSOQLManager.getLocation();
        try{
        if(locationList != null){
            return locationList;
        }
        else
            return null;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    /*******************************************************************************************************
    * @description This method is used for getting FieldSet.
    * @returns List of Object.
    */
    @AuraEnabled
    public static List<Object> getLocationFieldSet(){
        return QuickAppointmentUtils.getFieldFromFieldSet('CC_QAppt__Location__c','CC_QAppt__LocationListFieldSet');
    }
    
    /*******************************************************************************************************
    * @description This method is used to create new Location Or Edit Location record.
    * @returns Void.
    */
    @AuraEnabled
    public Static Void saveLocation(CC_QAppt__Location__c location){
          try{
               CC_QAppt__Location__c newLocation = new CC_QAppt__Location__c(Id = location.Id,
                                                                              name = location.Name,
                                                                              CC_QAppt__City__c = location.CC_QAppt__City__c,
                                                                              CC_QAppt__Country__c = location.CC_QAppt__Country__c,
                                                                              CC_QAppt__Postal_Code__c = location.CC_QAppt__Postal_Code__c,
                                                                              CC_QAppt__State__c = location.CC_QAppt__State__c,
                                                                              CC_QAppt__Street__c = location.CC_QAppt__Street__c);
                Upsert newLocation;
            System.debug(newLocation);
        }
        catch(exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    /*******************************************************************************************************
    * @description This method is used to Delete Location record.
    * @returns Void.
    */
    @AuraEnabled
    public Static Void deleteLocation(String dltId){
        try{
                CC_QAppt__Location__c dltLocation = new CC_QAppt__Location__c(Id = dltId);
                Delete dltLocation;
        }
        catch(exception e){
             throw new AuraHandledException(e.getMessage()); 
        }
    }
}