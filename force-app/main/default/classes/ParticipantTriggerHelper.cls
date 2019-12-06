public class ParticipantTriggerHelper {
    
    public static void handleOnAfterInsert(List<CC_QAppt__Participant__c> participantList) {
        
        set<Id> customerIds = NEW set<Id>();
        set<Id> appointmentIds = NEW set<Id>();
        List<String> storeEmail = NEW List<String>();
        Map<Id,Set<Id>> mapOfCustomer = New Map<Id,Set<Id>>();
        List<EmailTemplate> empList = [Select id from EmailTemplate where name ='Appointment Email Template' limit 1];
        
        for(CC_QAppt__Participant__c prcpnt : participantList) {
            
            customerIds.add(prcpnt.Participant_Name__c);
            appointmentIds.add(prcpnt.CC_QAppt__Appointment__c);
            
            if(!mapOfCustomer.containsKey(prcpnt.CC_QAppt__Appointment__c)){
                mapOfCustomer.put(prcpnt.CC_QAppt__Appointment__c, new Set<id>{prcpnt.Participant_Name__c});
            }
            else{
                mapOfCustomer.get(prcpnt.CC_QAppt__Appointment__c).add(prcpnt.Participant_Name__c);
            }
        }
        
        
        if(customerIds.size()>0) {
            List<Messaging.SingleEmailMessage> messages =   NEW List<Messaging.SingleEmailMessage>();
            
            for(contact con : [select Id,email from contact where Id In:customerids AND email != null]) {
                String appcategory ;
                for(Id ids :mapOfCustomer.keySet()){
                    Set<Id> idsofcustomer =   mapOfCustomer.get(ids);
                    if(idsofcustomer.contains(con.id)){
                        appcategory = ids; 
                    }
                  
                }
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(empList[0].id, con.id,appcategory);
                email.toAddresses = new List<string>{con.Email};
                email.subject = 'Congratulation Your Appointment has been Scheduled';
                email.setSaveAsActivity(false);
                email.setTemplateId(empList[0].id);
                
                
                messages.add(email);
                
            }
            
            
            if(messages.size()>0) {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if (results[0].success){
                    System.debug('The email was sent successfully.');
                } else{
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
            }
        }
        
    }
    
}