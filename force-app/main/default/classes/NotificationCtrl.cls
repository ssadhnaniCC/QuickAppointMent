global with sharing class NotificationCtrl{
    
    public NotificationCtrl(){
        
    }
    
    global class Notifications{
        public string notificationId{get;set;}
        public string description{get;set;} 
        public boolean read{get;set;}
        public boolean view{get;set;}
        public string contactId{get;set;}
    }
    
    @RemoteAction
    global static Integer getNotificationCount(){
        Integer notificationCount;
        list<AggregateResult> lstAgg=new list<AggregateResult>();
        if(Schema.sObjectType.Notification__c.fields.view__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Contact__c.isAccessible()){
            lstAgg=[SELECT  Count(id) notiCount,view__c v,contact__c con FROM Notification__c WHERE view__c = false And read__c = false GROUP BY contact__c,view__c] ;  
        }
        if(lstAgg.size() > 0){
            for (AggregateResult ar : lstAgg){
                notificationCount = (Integer)ar.get('notiCount');
            } 
        }
        return notificationCount;
    }
    
    @RemoteAction
    global static List<Notifications> getNotification(){
        Notifications noti;
        List<Notifications> notificationModel = new List<Notifications>();
        List<Notification__c> notificationList = new List<Notification__c>();
        if(Schema.sObjectType.Notification__c.fields.view__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Contact__c.isAccessible()
            && Schema.sObjectType.Notification__c.fields.read__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Description__c.isAccessible()){
            notificationList = [SELECT id,read__c,Description__c, view__c,contact__c  FROM Notification__c where contact__c  != null And read__c = false order by createddate desc];
        }
        
        for(Notification__c n: notificationList){
            noti = new Notifications();
            noti.description = n.Description__c;
            noti.read = n.read__c;
            noti.view = n.view__c;
            noti.notificationId = n.id;
            noti.contactId = n.contact__c;
            notificationModel.add(noti);
        }
        return notificationModel;
    } 
    
    @RemoteAction
    global static void CheckAllNotification(){
        List<Notification__c> notiList = new List<Notification__c>();
        List<Notification__c> notiListTemp = new List<Notification__c>();
        if(Schema.sObjectType.Notification__c.fields.view__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Contact__c.isAccessible()
            && Schema.sObjectType.Notification__c.fields.read__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Description__c.isAccessible()){
            
            notiList = [SELECT id,read__c,Description__c, view__c,contact__c  FROM Notification__c WHERE view__c = false and read__c = false];
        }
        for(Notification__c n: notiList){
            n.view__c = true;
            notiListTemp.add(n); 
        }
        if(notiListTemp.size()>0){
            if((Schema.sObjectType.Notification__c.fields.view__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Contact__c.isCreateable()
            && Schema.sObjectType.Notification__c.fields.read__c.isCreateable() && Schema.sObjectType.Notification__c.fields.Description__c.isCreateable()) && (Schema.sObjectType.Notification__c.fields.view__c.isUpdateable() && Schema.sObjectType.Notification__c.fields.Contact__c.isUpdateable()
            && Schema.sObjectType.Notification__c.fields.read__c.isUpdateable() && Schema.sObjectType.Notification__c.fields.Description__c.isUpdateable())){
            
                update notiListTemp;
            }
        }
    }
    
    @RemoteAction
    global static void CheckReadNotification(string notiId){
        System.debug('Notification Ids'+ notiId);
        List<Notification__c> notiList = new List<Notification__c>();
        List<Notification__c> notiListTemp = new List<Notification__c>();
        if(Schema.sObjectType.Notification__c.fields.view__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Contact__c.isAccessible()
            && Schema.sObjectType.Notification__c.fields.read__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Description__c.isAccessible()){
            
            notiList = [SELECT id,read__c,Description__c, view__c,contact__c  FROM Notification__c WHERE id =: notiId];
        }
        for(Notification__c n: notiList){
            n.read__c = true;
            notiListTemp.add(n); 
        }
        if(notiListTemp.size()>0){
            if(Schema.sObjectType.Notification__c.fields.read__c.isUpdateable()){
                 system.debug('Update');
                 try{
                update notiListTemp;
                }
                catch(Exception e){
                 system.debug('Exception'+e);
                }
            }
        }
    }
    
    
    @RemoteAction
    global static void ClearAllNotification( string conId){
        List<Notification__c> notiList = new List<Notification__c>();
        if(Schema.sObjectType.Notification__c.fields.view__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Contact__c.isAccessible()
            && Schema.sObjectType.Notification__c.fields.read__c.isAccessible() && Schema.sObjectType.Notification__c.fields.Description__c.isAccessible()){
            
            notiList = [SELECT id,read__c,Description__c, view__c,contact__c  FROM Notification__c WHERE contact__c =: conId];
        }
        if(Notification__c.sObjectType.getDescribe().isDeletable()){
            delete notiList;
        }
    }
    
}