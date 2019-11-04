trigger EmailCase on Case (before insert) {   
    Map<String,Map<String,Case>> caseMap = new Map<String,Map<String,Case>>();
    for(Case c : Trigger.new){
       if ((c.SuppliedEmail  != null) && (System.Trigger.isInsert)) {
        if (!caseMap.containsKey(c.SuppliedEmail)) {
            caseMap.put(c.SuppliedEmail,new Map<String,Case>{c.subject => c});
        }
           else{
               for(String emailkey : caseMap.keySet()){
                   for(String subjectkey :  caseMap.get(emailkey).keySet()) {
                       
                   }  
               }
           }
    }
    }
}