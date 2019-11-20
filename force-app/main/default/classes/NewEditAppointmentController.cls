public class NewEditAppointmentController {
	@AuraEnabled
    public static List<CC_QAppt__Appointment_Category__c> getAppointmentCategory(){
    	return QuickAppointmentSOQLManager.getAppointmentCategories(null);
    } 
}