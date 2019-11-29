({
    /*******************************************************************************************************
    * @description This method runs after script loaded.
   */
    scriptsLoaded : function(component, event, helper){ 
        component.set("v.scriptLoaded",true);
        helper.getResponse(component,helper);
    },
    /*******************************************************************************************************
    * @description This method runs which shows related calendar show.
   */
    relatedCalendarShow : function(component,event,helper){
        var params = event.getParam('arguments');
        component.set("v.objName",params.objectName);
        component.set("v.recordId",params.Id);
        component.set("v.showToast",false);
        //If Script Loaded Successfully then only load helper
        if(component.get("v.scriptLoaded")){
            helper.getResponse(component,helper);
        }
        
    },
    /*******************************************************************************************************
    * @description This method closes the message  .
   */
    closeAlert : function(component,event,helper){
        component.set("v.showToast",false);
    },
    /*******************************************************************************************************
    * @description New Appointment List  .
   */    
    newAppointment : function(component, event, helper){
        component.set("v.editAppointmentId",null);
        component.set("v.showNewAppointment", true);
    },
    parentComponentEvent : function(component,event,helper){
         helper.getResponse(component,helper);  
         event.stopPropagation();
    },
})