({
    doInit: function(component,event,helper) {
        if(component.get("v.recordId") != ''){
        helper.fetchRelatedAppointment(component,event,helper);
        }
    },
   /*******************************************************************************************************
    * @description This is the method which will fetch related Appointments
   */
    getRelatedAppointments : function(component,event,helper){
        var params = event.getParam('arguments');
        component.set("v.objName",params.objectName);
        component.set("v.recordId",params.Id);
        component.set("v.showToast",false);
        helper.fetchRelatedAppointment(component,event,helper);
    },
   /*******************************************************************************************************
    * @description This is the method which will hideMessage
   */
     closeAlert : function(component,event,helper){
        component.set("v.showToast",false);
    },
      /*******************************************************************************************************
    * @description This is the method which will handle the next functionality 
   */
    handleNext : function(component,event,helper){
        helper.next(component,event,helper);      
    },
    /*******************************************************************************************************
    * @description This is the method which will call the previous helper 
   */
    handlePrev : function(component,event,helper){
        helper.previous(component,event,helper); 
    },
    /*******************************************************************************************************
    * @description This is the method which will handle the First button pagination
   */
    handleFirst : function(component,event,helper){
        helper.handleFirstLast(component,event,helper,1);
    },
    /*******************************************************************************************************
    * @description This is the method which will handle the Last button pagination
   */
    handleLast : function(component,event,helper){
        helper.handleFirstLast(component,event,helper,component.get("v.totalPages"));
    },
    
   /*******************************************************************************************************
    * @description This is the method which will handle Sorting
   */
    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
        
    }
    
})