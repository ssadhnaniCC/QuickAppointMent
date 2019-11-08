({
   /*******************************************************************************************************
    * @description This method runs after script loaded.
   */
    scriptsLoaded : function(component, event, helper){ 
      helper.getResponse(component,helper);
     },
    relatedCalendarShow : function(component,event,helper){
      var params = event.getParam('arguments');
        component.set("v.objName",params.objectName);
        component.set("v.recordId",params.Id);
        helper.getResponse(component,helper);
    },
    closeAlert : function(component,event,helper){
        component.set("v.showToast",false);
    }
})