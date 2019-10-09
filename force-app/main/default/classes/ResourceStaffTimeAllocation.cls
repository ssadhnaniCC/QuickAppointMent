public with sharing class ResourceStaffTimeAllocation{
    public string AlignmentId {get;set;}
    public string AllocationId{get;set;}
    public Resource_Service_Alignment__c Alignment{get;set;}
    public List<Resource_Staff_Time__c> resourceTimeList{get;set;}
    public Resource_Staff_Time__c resourceTime {get;set;}
    public ResourceStaffTimeAllocation(){
        AlignmentId = ApexPages.currentPage().getParameters().get('id');
        if(AlignmentId != null){
            Alignment = new Resource_Service_Alignment__c();
            if(Schema.sObjectType.Resource_Service_Alignment__c.fields.name.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible()
            && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible()
            && Schema.sObjectType.Service__c.fields.name.isAccessible() && Schema.sObjectType.Location__c.fields.name.isAccessible() && Schema.sObjectType.contact.fields.name.isAccessible()){
                Alignment = [select name,Service__r.name,Resource_Staff__r.name,Location__r.name from Resource_Service_Alignment__c where id =: AlignmentId];
            }
            resourceTimeList = new List<Resource_Staff_Time__c>();
            resourceTimeList =getResourceTimeList(AlignmentId);
        }
        System.debug('--- resourceList'+resourceTimeList);
    }
    public static List<Resource_Staff_Time__c> getResourceTimeList(string AlignmentId){
        if(Schema.sObjectType.Resource_Staff_Time__c.fields.name.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Start_Date_Time__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.End_Date_Time__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Resource_Business_Alignment__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Active__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Monday__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Tuesday__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Wednesday__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Thursday__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Friday__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Saturday__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Sunday__c.isAccessible()){
           return [select Name,Start_Date_Time__c,End_Date_Time__c, Resource_Business_Alignment__c,
                                   Active__c,Monday__c,Tuesday__c,Wednesday__c,Thursday__c,Friday__c,Saturday__c,Sunday__c 
                                   from Resource_Staff_Time__c where Resource_Business_Alignment__c =:AlignmentId];
       }
       return null;
    }
    public void goToNewEditMode(){
        if(AllocationId == ''){
            resourceTime = new Resource_Staff_Time__c();
        }else{
            if(Schema.sObjectType.Resource_Staff_Time__c.fields.name.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Start_Date_Time__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.End_Date_Time__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Resource_Business_Alignment__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Active__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Monday__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Tuesday__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Wednesday__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Thursday__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Friday__c.isAccessible()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Saturday__c.isAccessible() && Schema.sObjectType.Resource_Staff_Time__c.fields.Sunday__c.isAccessible()){
            
                resourceTime = [select Name,Start_Date_Time__c,End_Date_Time__c, Resource_Business_Alignment__c,
                                   Active__c,Monday__c,Tuesday__c,Wednesday__c,Thursday__c,Friday__c,Saturday__c,Sunday__c 
                                   from Resource_Staff_Time__c where id =:AllocationId];
           }
        }
    }
    
    public void saveAllocation(){
        if(AlignmentId == '')
            resourceTime.Resource_Business_Alignment__c = AlignmentId;
        if((Schema.sObjectType.Resource_Staff_Time__c.fields.name.isCreateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Start_Date_Time__c.isCreateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.End_Date_Time__c.isCreateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Resource_Business_Alignment__c.isCreateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Active__c.isCreateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Monday__c.isCreateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Tuesday__c.isCreateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Wednesday__c.isCreateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Thursday__c.isCreateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Friday__c.isCreateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Saturday__c.isCreateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Sunday__c.isCreateable())
            && (Schema.sObjectType.Resource_Staff_Time__c.fields.name.isUpdateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Start_Date_Time__c.isUpdateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.End_Date_Time__c.isUpdateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Resource_Business_Alignment__c.isUpdateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Active__c.isUpdateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Monday__c.isUpdateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Tuesday__c.isUpdateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Wednesday__c.isUpdateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Thursday__c.isUpdateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Friday__c.isUpdateable()
            && Schema.sObjectType.Resource_Staff_Time__c.fields.Saturday__c.isUpdateable() && Schema.sObjectType.Resource_Staff_Time__c.fields.Sunday__c.isUpdateable())){
            
            upsert resourceTime;
        }
        resourceTimeList =getResourceTimeList(AlignmentId);
        System.debug('--- resourceList'+resourceTimeList);
    }
}