public class PublicHolidayLocationSelectorController {
   /* * @description This method is used to get  all locations .
    * @returns list of locations.
    */
    @auraEnabled
    public static list<CC_QAppt__Location__c>  getLocations(){
        return [select id,name from CC_QAppt__Location__c];
    }
}