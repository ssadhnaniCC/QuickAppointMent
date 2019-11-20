({
    doInit : function(component, event, helper) {
        
    },
    getResourceStaffId : function(component, event, helper) {
        console.log('resourceStaffId@@',component.get('v.resourceStaffId'));
        helper.fetchResourceName(component, event, component.get('v.resourceStaffId')); 
        helper.getColumnAndAction(component);
        helper.getWorkingHour(component,helper);
    },
    
    OnAddNewWorkingHour : function(component,event,helper) {
        component.set('v.isModelOpen',true);
        
    },
    
    /*******************************************************************************************************
    * @description This is the method which will handle edit for delete functionality for table row
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
    closeAlert : function(component,event,helper){
        component.set("v.showToast",false);
    },
    
    onSaveAndEdit : function(component,event,helper) {
        component.set("v.pageNumber",1);
        component.set('v.workingRecord',{});
                
        helper.getWorkingHour(component,event,helper);
    }
    
})