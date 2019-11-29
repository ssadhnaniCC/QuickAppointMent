({
    doInit : function(component, event, helper) {
        
    },
    
    /*******************************************************************************************************
    * @description In this method we fetch resource name and list of working hours
   */
    
    getResourceStaffId : function(component, event, helper) {
        
        helper.fetchResourceName(component, event, component.get('v.resourceStaffId')); 
        helper.getColumnAndAction(component);
        helper.getWorkingHour(component,helper);
    },
    
     /*******************************************************************************************************
    * @description set boolean true to open child modal
   */
    
    OnAddNewWorkingHour : function(component,event,helper) {
        component.set('v.isModelOpen',true);
        
    },
    
    /*******************************************************************************************************
    * @description This is the method which will handle edit and delete functionality for table row
   */
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'edit':
                helper.editRecord(component, event);
                break;
            case 'delete':
                helper.deleteRecord(component, event);
                break;
                
        }
    },
    
    /*******************************************************************************************************
    * @description This is the method which will handle edit and delete functionality for table row
   */
    
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    } ,
    
    /*******************************************************************************************************
    * @description This is the method which set error message toast close
   */
    
    closeAlert : function(component,event,helper){
        component.set("v.showToast",false);
    },
    
    /*******************************************************************************************************
    * @description This is the method for handle refresh event after working hour record insert
   */
    
    onSaveAndEdit : function(component,event,helper) {
        component.set("v.pageNumber",1);
        component.set('v.workingRecord',{});
        
        helper.getWorkingHour(component,event,helper);
    }
    
})