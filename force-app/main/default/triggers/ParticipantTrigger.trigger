trigger ParticipantTrigger on CC_QAppt__Participant__c (after Insert) {
    
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            ParticipantTriggerHelper.handleOnAfterInsert(Trigger.new);
        }
    }
}