public class DashboardControler {
    @AuraEnabled
    public static Map<String,Integer> getBarChartMonthlyAppointment(){
        Map<String,Integer> monthlyAppointment = new Map<String,Integer>();
        for(AggregateResult result : [select count(id) total,calendar_month(CC_QAppt__Start_Date_Time__c) month from CC_QAppt__Appointment__c where CC_QAppt__Status__c = 'Completed' GROUP BY calendar_month(CC_QAppt__Start_Date_Time__c)]){
            monthlyAppointment.put((String)result.get('month'),(Integer)result.get('total'));
        }
        return monthlyAppointment;
    }
}