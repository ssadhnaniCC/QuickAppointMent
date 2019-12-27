public class AppointmentEditConfiguartionController {
   @AuraEnabled
   public static List<CC_QAppt__Appointment_Category__c> getAppointmentCategory(Boolean isPublic){
        return QuickAppointmentSOQLManager.getAppointmentCategories(null, isPublic);
    }
    @AuraEnabled
    public static void saveUserTemplate(String appConfig){
        List<CC_QAppt__AppointmentTemplate__c>    lstofapptemp = [select id,name  from CC_QAppt__AppointmentTemplate__c];
        Integer lengthoflist = 0;
        if(lstofapptemp.size()>0){
         lengthoflist =  lstofapptemp.size();  
        } 
        lengthoflist = lengthoflist+1;
        String TemplateName = 'Template'+lengthoflist;
        CC_QAppt__AppointmentTemplate__c apptemplate = new CC_QAppt__AppointmentTemplate__c();
        apptemplate.Name = TemplateName;
        apptemplate.CC_QAppt__DisplayFieldJson__c	= appConfig;
        insert apptemplate;
        
    }
}