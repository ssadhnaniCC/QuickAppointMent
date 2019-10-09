trigger DeleteRelatedRecordsOfResourceStaff  on Contact (before delete) {
    Set<Id> ResourceIds = new Set<Id>();
    if(Trigger.isDelete){
        for(Contact con : Trigger.old){
            ResourceIds.add(con.id);
        }
    }
    if(ResourceIds.Size() > 0)DeleteRelatedRecords.RelatedResourcestaff(ResourceIds);
}