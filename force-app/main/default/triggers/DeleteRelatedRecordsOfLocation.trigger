trigger DeleteRelatedRecordsOfLocation on Location__c (before delete) {
    
    Set<Id> LocIds = new Set<Id>();
    if(Trigger.isDelete){
        for(Location__c loc : Trigger.old){
            LocIds.add(loc.id);
        }
    }
    if(LocIds.Size() > 0)DeleteRelatedRecords.RelatedLocation(LocIds);
}