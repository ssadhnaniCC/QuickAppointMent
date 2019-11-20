public class PublicHolidayLocationSelectorController {

    @auraEnabled
    public static list<CC_QAppt__Location__c>  getLocations(){
        return [select id,name from CC_QAppt__Location__c];
    }
}