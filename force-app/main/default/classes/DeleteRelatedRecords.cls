global with sharing class DeleteRelatedRecords{

    public static void RelatedLocation( set<id> LocIds){
        List<Location_Service__c> DeleteLocSerList = new List<Location_Service__c>();
        List<Resource_Service_Alignment__c> DeleteResourceList = new List<Resource_Service_Alignment__c>();
        List<Appointment__c> DeleteAppList = new List<Appointment__c>();
        Set<Id> AlignmentIds = new Set<Id>();
        List<Notification__c> noti = new List<Notification__c>();
        set<Id>appIds= new Set<Id>();
        
        if(Schema.sObjectType.Location_Service__c.fields.Location__c.isAccessible() && Schema.sObjectType.Location_Service__c.fields.Service__c.isAccessible()){
            DeleteLocSerList = [select Location__c,Service__c from Location_Service__c where Location__c IN: LocIds];
        }
        if(DeleteLocSerList.size() > 0){
            if(Location_Service__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteLocSerList;
            }
        }
        
        if(Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible()
            && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible()){
            DeleteResourceList = [select Location__c,Resource_Staff__c,Service__c from Resource_Service_Alignment__c where Location__c IN: LocIds];
        }
        
        for(Resource_Service_Alignment__c ali : DeleteResourceList){
            AlignmentIds.add(ali.id);
        }
        if(Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c .isAccessible()){
            DeleteAppList = [select id,Resource_Service_Alignment__c from Appointment__c where Resource_Service_Alignment__c IN: AlignmentIds];
        }
        for(Appointment__c app: DeleteAppList){
            appIds.add(app.id);
        }
        if(Schema.sObjectType.Notification__c.fields.Appointment__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Contact__c.isAccessible()){
            noti = [select id,Appointment__c,Contact__c from Notification__c where Appointment__c IN: appIds];
        }
        if(noti.size() > 0){
            if(Notification__c.sObjectType.getDescribe().isDeletable()){
                delete noti;
            }
        }
        if(DeleteAppList.size() > 0){
            if(Appointment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteAppList;
            }
        }
        
        if(DeleteResourceList.size() > 0){
            if(Resource_Service_Alignment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteResourceList;
            }
        }
    }
    
    public static void RelatedService( set<id> SerIds){
        List<Location_Service__c> DeleteLocSerList = new List<Location_Service__c>();
        List<Resource_Service_Alignment__c> DeleteResourceList = new List<Resource_Service_Alignment__c>();
        List<Appointment__c> DeleteAppList = new List<Appointment__c>();
        Set<Id> AlignmentIds = new Set<Id>();
        List<Notification__c> noti = new List<Notification__c>();
        set<Id>appIds= new Set<Id>();
        
        if(Schema.sObjectType.Location_Service__c.fields.Location__c.isAccessible() && Schema.sObjectType.Location_Service__c.fields.Service__c.isAccessible()){
            DeleteLocSerList = [select Location__c,Service__c from Location_Service__c where Service__c IN: SerIds];
        }
        if(DeleteLocSerList.size() > 0){
            if(Location_Service__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteLocSerList;
            }
        }
        
        if(Schema.sObjectType.Resource_Service_Alignment__c.fields.Location__c.isAccessible() && Schema.sObjectType.Resource_Service_Alignment__c.fields.Service__c.isAccessible()
            && Schema.sObjectType.Resource_Service_Alignment__c.fields.Resource_Staff__c.isAccessible()){
            DeleteResourceList = [select Location__c,Resource_Staff__c,Service__c from Resource_Service_Alignment__c where Service__c IN: SerIds];
        }
        for(Resource_Service_Alignment__c ali : DeleteResourceList){
            AlignmentIds.add(ali.id);
        }
        
        if(Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c .isAccessible()){
            DeleteAppList = [select id,Resource_Service_Alignment__c from Appointment__c where Resource_Service_Alignment__c IN: AlignmentIds];
        }
        for(Appointment__c app: DeleteAppList){
            appIds.add(app.id);
        }
        if(Schema.sObjectType.Notification__c.fields.Appointment__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Contact__c.isAccessible()){
            noti = [select id,Appointment__c,Contact__c from Notification__c where Appointment__c IN: appIds];
        }
        if(noti.size() > 0){
            if(Notification__c.sObjectType.getDescribe().isDeletable()){
                delete noti;
            }
        }
        
        if(DeleteAppList.size() > 0){
            if(Appointment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteAppList;
            }
        }
        
        if(DeleteResourceList.size() > 0){
            if(Resource_Service_Alignment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteResourceList;
            }
        }
    }
    
    public static void RelatedResourcestaff( set<id> ResIds){
        List<Resource_Service_Alignment__c> DeleteResourceList = new List<Resource_Service_Alignment__c>();
        List<Appointment__c> DeleteAppList = new List<Appointment__c>();
        Set<Id> AlignmentIds = new Set<Id>();
        List<Notification__c> noti = new List<Notification__c>();
        set<Id>appIds= new Set<Id>();
        
        if(Schema.sObjectType.Location_Service__c.fields.Location__c.isAccessible() && Schema.sObjectType.Location_Service__c.fields.Service__c.isAccessible()){
            DeleteResourceList = [select Location__c,Resource_Staff__c,Service__c from Resource_Service_Alignment__c where Resource_Staff__c IN: ResIds];
        }
        for(Resource_Service_Alignment__c ali : DeleteResourceList){
            AlignmentIds.add(ali.id);
        }
        
        if(Schema.sObjectType.Appointment__c.fields.Resource_Service_Alignment__c .isAccessible()){
            DeleteAppList = [select id,Resource_Service_Alignment__c from Appointment__c where Resource_Service_Alignment__c IN: AlignmentIds];
        }
        for(Appointment__c app: DeleteAppList){
            appIds.add(app.id);
        }
        if(Schema.sObjectType.Notification__c.fields.Appointment__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Contact__c.isAccessible()){
            noti = [select id,Appointment__c,Contact__c from Notification__c where Appointment__c IN: appIds];
        }
        if(noti.size() > 0){
            if(Notification__c.sObjectType.getDescribe().isDeletable()){
                delete noti;
            }
        }
        
        
        if(DeleteAppList.size() > 0){
            if(Appointment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteAppList;
            }
        }
        
        if(DeleteResourceList.size() > 0){
            if(Resource_Service_Alignment__c.sObjectType.getDescribe().isDeletable()){
                delete DeleteResourceList;
            }
        }
    }
}