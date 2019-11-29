public class DashboardControler {
    /*******************************************************************************************************
    * @description This method is used for getting data of Appointment sObject according month. And called by Dashboard Lightning Component
    * @returns Map<String,Integer>  key is name month and value is total number of appointment of that month .
    */
    @AuraEnabled
    public static Map<String,Integer> getBarChartMonthlyAppointment(){
        String [] month = new String[] {'January','February','March','April','May','June','July','August','September','October','Novemeber','Decemeber'};
            try{
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
            }catch(Exception exp){
                system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
            }
        return null;
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of Appointment sObject on daily basis. And called by Dashboard Lightning Component
    * @returns Map<String,Integer>  key is time interval and value is total number of appointment on that interval .
    */
    @AuraEnabled
    public static Map<String,Integer> getDailyBarchart(){
        String [] arrayOfHour = new String[]{'12:00 - 1:00 AM','1:00 - 2:00 AM','2:00 - 3:00 AM','3:00 - 4:00 AM','4:00 - 5:00 AM','5:00 - 6:00 AM','6:00 - 7:00 AM','7:00 - 8:00 AM','8:00 - 9:00 AM','9:00 - 10:00 AM','10:00 - 11:00 AM','11:00 - 12:00 AM','12:00 - 1:00 PM','1:00 - 2:00 PM','2:00 - 3:00 PM','3:00 - 4:00 PM','4:00 - 5:00 PM','5:00 - 6:00 PM','6:00 - 7:00 PM','7:00 - 8:00 PM','8:00 - 9:00 PM','9:00 - 10:00 PM','10:00 - 11:00 PM','11:00 - 12:00 PM'};
            try{
                    TimeZone tz = UserInfo.getTimeZone();
                    String currentTimeZone =  tz.getID();
                    Map<String,Integer> dailyAppointment = new Map<String,Integer>();
                    
                    list<CC_QAppt__Appointment__c> app = QuickAppointmentSOQLManager.dailyAppointment();
                    
                    if(!app.isEmpty()){
                    Integer tmphour = Integer.valueof(app[0].CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone).substringBetween(' ',':'));
                    String tmpTime = app[0].CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone).substringAfterLast(' ');
                    Integer total = 0;
                    
                    for(CC_QAppt__Appointment__c obj : app){
                        Integer hours = Integer.valueof(obj.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone).substringBetween(' ',':'));
                        String amOrpm = obj.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone).substringAfterLast(' ');
                        if(hours == tmphour && tmpTime == amOrpm){
                            total++;
                        }
                        else{
                            String timeString = tmphour + ':00 - '+ (tmphour+1) + ':00 ' + tmpTime;
                            dailyAppointment.put(timeString,total);
                            total = 1;
                            tmpTime = amOrpm;
                            tmphour = hours;
                        }
                    }
                    
                    String timeString = tmphour + ':00 - '+ (tmphour == 12 ? 1:tmphour+1) + ':00 '+ tmpTime;
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
                    }
                    else{
                        for(String h : arrayOfHour){
                            dailyAppointment.put(h,0);	
                        }
                    }
                    return dailyAppointment;
                }catch(Exception exp){
                system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
            }
        return null;
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of rating from Appiontment Feedback sObject.And called by Dashboard Lightning Component
    * @returns Map<String,Integer>  key is name of rate like '5*' and value is total number of rating of that rate .
    */
    @AuraEnabled
    public static Map<String,Integer> getRating(){
        try{
            Map<String,Integer> ratingMap = QuickAppointmentSOQLManager.getRating();
            Integer totalRating = QuickAppointmentSOQLManager.totalRating();
            for(integer i =5;i>0;i--){
                if(!ratingMap.containsKey(String.valueOf(i)))
                    ratingMap.put(String.valueOf(i)+' Star',0);
                else{
                    Integer value =  (Integer)Math.ceil((ratingMap.get(String.valueOf(i)) * 100)/totalRating);
                    ratingMap.remove(String.valueOf(i));
                    ratingMap.put(String.valueOf(i)+' Star',value);
                }
            }
            System.debug('rating'+ratingMap);
            return ratingMap;
        }catch(Exception exp){
                system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
            }
        return null;
    }
    /*******************************************************************************************************
    * @description This method is used for getting data of rating from Appiontment Feedback sObject.And get average rating
    * @returns list<Double>  
    */
    @AuraEnabled
    public static list<Double> getAverageRating(){
        try{
                Map<String,Integer> ratingMap = QuickAppointmentSOQLManager.getRating();
                Integer totalRating = QuickAppointmentSOQLManager.totalRating();
                integer sum = 0;
                list<Double> rate = new list<Double>();
                for(integer i =5;i>0;i--){
                    if(ratingMap.containsKey(String.valueOf(i)))
                        sum = sum + (ratingMap.get(String.valueOf(i)) * i);
                }
                rate.add(sum / totalRating);
                rate.add(totalRating);
                return rate;
            }catch(Exception exp){
                system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
            }
        return null;
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
    
    /*******************************************************************************************************
    * @description This method is used for getting data of upcoming appointment.And called by Dashboard lightning component
	* @returns List<AppointmentWrapper>.
	*/
    @AuraEnabled
    public static List<AppointmentWrapper> getUpcomingAppointment(){
        try{
                List<CC_QAppt__Appointment__c> upcominigAppointment = QuickAppointmentSOQLManager.getUpcomingAppointment();
                List<AppointmentWrapper> wrapperList = new List<AppointmentWrapper>();
                //Get User Time Zone
                TimeZone tz = UserInfo.getTimeZone();
                String currentTimeZone =  tz.getID();
                 if(!upcominigAppointment.isEmpty()){
                    for(CC_QAppt__Appointment__c obj : upcominigAppointment){
                        AppointmentWrapper wrapperObj = new AppointmentWrapper();
                        wrapperObj.Name = obj.Name;
                        wrapperObj.ServiceName = obj.Resource_Service_Alignment__r.Service__r.name;
                        wrapperObj.LocationName = obj.Resource_Service_Alignment__r.Location__r.name;
                        wrapperObj.StartDate = obj.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
                        wrapperList.add(wrapperObj);
                    }
                 }
                return wrapperList;
            }catch(Exception exp){
                system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
            }
        return null;
    }
    
    /*******************************************************************************************************
    * @description This method is used for getting data of upcoming appointment with customer name.And called by Dashboard lightning component
	* @returns List<AppointmentWrapper>.
	*/
    @AuraEnabled
    public static List<AppointmentWrapper> getUpcomingCustomer(){
        try{
                List<CC_QAppt__Participant__c> upcominigCustomer = QuickAppointmentSOQLManager.getUpcomingCustomer();
                List<AppointmentWrapper> wrapperList = new List<AppointmentWrapper>();
                //Get User Time Zone
                TimeZone tz = UserInfo.getTimeZone();
                String currentTimeZone =  tz.getID();
                if(!upcominigCustomer.isEmpty()){
                    for(CC_QAppt__Participant__c obj : upcominigCustomer){
                        AppointmentWrapper wrapperObj = new AppointmentWrapper();
                        wrapperObj.Name = obj.CC_QAppt__Appointment__r.Name;
                        wrapperObj.CustomerName = obj.CC_QAppt__Participant_Name__r.Name;
                        wrapperObj.StartDate = obj.CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c.format('MM/dd/yyyy h:mm a',currentTimeZone);
                        System.debug(wrapperObj.StartDate);
                        wrapperList.add(wrapperObj);
                    }
                }
                return wrapperList;
            }catch(Exception exp){
                system.debug('Error:' + exp.getMessage() + ' - ' + exp.getLineNumber());
            }
        return null;
    }
    
    /*******************************************************************************************************
    * this is wrapper class for appointment
    */
    public class AppointmentWrapper{
        @AuraEnabled public String Name;
        @AuraEnabled public String ServiceName;
        @AuraEnabled public String LocationName;
        @AuraEnabled public String CustomerName;
        @AuraEnabled public String StartDate;
    }
}