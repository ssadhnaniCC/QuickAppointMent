public class DashboardControler {
    /*******************************************************************************************************
    * @description This method is used for getting data of Appointment sObject according month. And called by Dashboard Lightning Component
    * @returns Map<String,Integer>  key is name month and value is total number of appointment of that month .
    */
    @AuraEnabled
    public static Map<String,Integer> getBarChartMonthlyAppointment(){
        String [] month = new String[] {'January','February','March','April','May','June','July','August','September','October','Novemeber','Decemeber'};
            Map<String,Integer> monthlyAppointment = QuickAppointmentSOQLManager.monthlyAppointment();    
        for(String mon : month){
            if(!monthlyAppointment.containsKey(mon)){
                monthlyAppointment.put(mon,0);	
            }
            else{
                integer value = monthlyAppointment.get(mon);
                monthlyAppointment.remove(mon);
                monthlyAppointment.put(mon,value);
            }
        }
        return monthlyAppointment;
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of Appointment sObject on daily basis. And called by Dashboard Lightning Component
    * @returns Map<String,Integer>  key is time interval and value is total number of appointment on that interval .
    */
    @AuraEnabled
    public static Map<String,Integer> getDailyBarchart(){
        String [] arrayOfHour = new String[]{'6:00 - 7:00','7:00 - 8:00','8:00 - 9:00','9:00 - 10:00','10:00 - 11:00','11:00 - 12:00','12:00 - 1:00','1:00 - 2:00','2:00 - 3:00','3:00 - 4:00','4:00 - 5:00','5:00 - 6:00','5:00 - 6:00','13:00 - 14:00','14:00 - 15:00','15:00 - 16:00','17:00 - 18:00','18:00 - 19:00','19:00 - 20:00','20:00 - 21:00','21:00 - 22:00','22:00 - 23:00','23:00 - 24:00'};
        TimeZone tz = UserInfo.getTimeZone();
        String currentTimeZone =  tz.getID();
        Map<String,Integer> dailyAppointment = new Map<String,Integer>();
        
        list<CC_QAppt__Appointment__c> app = QuickAppointmentSOQLManager.dailyAppointment();
        
        Integer tmphour = Integer.valueof(app[0].CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy HH:mm:ss',currentTimeZone).substringBetween(' ',':'));
        Integer total = 0;
        
        for(CC_QAppt__Appointment__c obj : app){
            Integer hours = Integer.valueof(obj.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy HH:mm:ss',currentTimeZone).substringBetween(' ',':'));
            if(hours == tmphour){
                total++;
            }
            else{
                String timeString = tmphour + ':00 - '+ (tmphour+1) + ':00';
                dailyAppointment.put(timeString,total);
                total = 1;
                tmphour = hours;
            }
        }
        
       // String timeString = tmphour + ':00 - '+ (tmphour == 12 ? 1:tmphour+1) + ':00';
       String timeString = tmphour + ':00 - '+ (tmphour+1) + ':00';
        dailyAppointment.put(timeString,total);
        
        for(String h : arrayOfHour){
            if(!dailyAppointment.containsKey(h)){
                dailyAppointment.put(h,0);	
            }
            else{
                integer value = dailyAppointment.get(h);
                dailyAppointment.remove(h);
                dailyAppointment.put(h,value);
            }
        }
        return dailyAppointment;
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of rating from Appiontment Feedback sObject.And called by Dashboard Lightning Component
    * @returns Map<String,Integer>  key is name of rate like '5*' and value is total number of rating of that rate .
    */
    @AuraEnabled
    public static Map<String,Integer> getRating(){
        Map<String,Integer> ratingMap = QuickAppointmentSOQLManager.getRating();
        for(integer i =5;i>0;i--){
            if(!ratingMap.containsKey(String.valueOf(i)))
                ratingMap.put(String.valueOf(i)+'*',0);
            else{
                integer value = ratingMap.get(String.valueOf(i));
                ratingMap.remove(String.valueOf(i));
                ratingMap.put(String.valueOf(i)+'*',value);
            }
        }
        return ratingMap;
    }
    
    /*******************************************************************************************************
	* @description This method is used for getting data of top ten Category.And call by DashBoard lightning component.
	* @returns Map<String,Integer>  key is name of Category and value is total number of Appointment of that category .
	*/
    @AuraEnabled
    public static Map<String,Integer> getTopCategory(){
        return QuickAppointmentSOQLManager.getTopCategory();
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of top ten Customer.And called by Dashboard lightning component
	* @returns Map<String,Integer>  key is name of Customer and value is total number of Appointment of that Customer .
	*/
    @AuraEnabled
    public static Map<String,Integer> getTopCustomer(){
        return QuickAppointmentSOQLManager.getTopCustomer();
    }
    
    @AuraEnabled
    public static List<AppointmentWrapper> getUpcomingAppointment(){
        List<CC_QAppt__Appointment__c> upcominigAppointment = QuickAppointmentSOQLManager.getUpcomingAppointment();
        List<AppointmentWrapper> wrapperList = new List<AppointmentWrapper>();
        //Get User Time Zone
        TimeZone tz = UserInfo.getTimeZone();
        String currentTimeZone =  tz.getID();
        
        for(CC_QAppt__Appointment__c obj : upcominigAppointment){
            AppointmentWrapper wrapperObj = new AppointmentWrapper();
            wrapperObj.Name = obj.Name;
            wrapperObj.ServiceName = obj.Resource_Service_Alignment__r.Service__r.name;
            wrapperObj.LocationName = obj.Resource_Service_Alignment__r.Location__r.name;
            wrapperObj.StartDate = obj.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
            wrapperList.add(wrapperObj);
        }
        return wrapperList;
    }
    @AuraEnabled
    public static List<AppointmentWrapper> getUpcomingCustomer(){
        List<CC_QAppt__Participant__c> upcominigCustomer = QuickAppointmentSOQLManager.getUpcomingCustomer();
        List<AppointmentWrapper> wrapperList = new List<AppointmentWrapper>();
        //Get User Time Zone
        TimeZone tz = UserInfo.getTimeZone();
        String currentTimeZone =  tz.getID();
        
        for(CC_QAppt__Participant__c obj : upcominigCustomer){
            AppointmentWrapper wrapperObj = new AppointmentWrapper();
            wrapperObj.Name = obj.CC_QAppt__Appointment__r.Name;
            wrapperObj.CustomerName = obj.CC_QAppt__Participant_Name__r.Name;
            wrapperObj.StartDate = obj.CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
            System.debug(wrapperObj.StartDate);
            wrapperList.add(wrapperObj);
        }
        return wrapperList;
    }
    public class AppointmentWrapper{
        @AuraEnabled public String Name;
        @AuraEnabled public String ServiceName;
        @AuraEnabled public String LocationName;
        @AuraEnabled public String CustomerName;
        @AuraEnabled public String StartDate;
    }
}