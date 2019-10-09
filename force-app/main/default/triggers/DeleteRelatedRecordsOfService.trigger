trigger DeleteRelatedRecordsOfService  on Service__c (before delete) {
    Set<Id> SerIds = new Set<Id>();
    if(Trigger.isDelete){
        for(Service__c ser : Trigger.old){
            SerIds.add(ser.id);
        }
    }
    if(SerIds.Size() > 0)DeleteRelatedRecords.RelatedService(SerIds);
}