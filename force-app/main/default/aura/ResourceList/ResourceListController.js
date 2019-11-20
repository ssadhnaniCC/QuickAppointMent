({
    /*******************************************************************************************************
    * @description This is the init method which will fetch Resources and columns of lightning data table from fieldset.
   */
    doInit : function(component, event, helper) {
        
        helper.getColumnOfResource(component);
        helper.getResourceStaff(component,event,helper);
    },
    /*******************************************************************************************************
    * @description This is the method which will open modal .
   */
    handleNewResourceCmp : function(component, event, helper) {
        component.set("v.openNewResourceModal",true);
        component.set("v.editresourceRecord",{});
        component.set("v.selectlocation",{});
        component.set("v.hideServiceList",false);
    },
    
    /*******************************************************************************************************
    * @description This is the method which will handle on row action .
   */
    handleResourceListAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');   
        component.set("v.resourceStaffId",row.Id);
        switch (action.name) {
            case 'edit':
                helper.editResourceRecord(component, event,helper);
                break;
            case 'delete':
                helper.deleteResourceStaffRecord(component,event,helper);
                break;
            case 'appointment':
                component.set("v.showRelatedAppointment",true);
                helper.showRelatedAppointments(component,event,helper);
                break;  
            case 'calendar':
                component.set("v.showCalendar",true);
                helper.showRelatedCalendar(component,event,helper);
                break;
            case 'Working Hours':
                component.set('v.showWorkingHoursList',true);
                helper.workingHourRecords(component,event,helper);
                break; 
        }
    },
    /*******************************************************************************************************
    * @description This is the method which will handle the seacrh functionality 
   */
    handleSearch : function(component,event,helper){
        var filter = component.get("v.searchResourceStaff");
        var data   = component.get("v.resourceData");
        var pageSize = component.get("v.pageSize");
        if(filter.length>=2 && !filter.startsWith(' ')) {
            var filterResourceDetails = data.filter(function(data){ 
                if((data.Name && data.Name.toLowerCase().indexOf(filter.toLowerCase()) >= 0) || (data.MailingCity && data.MailingCity.toLowerCase().indexOf(filter.toLowerCase()) >= 0)
                   ||(data.MailingStreet && data.MailingStreet.toLowerCase().indexOf(filter.toLowerCase()) >= 0) || (data.MailingCountry && data.MailingCountry.toLowerCase().indexOf(filter.toLowerCase()) >= 0) 
                   ||(data.MailingState && data.MailingState.toLowerCase().indexOf(filter.toLowerCase()) >= 0) ||
                   (data.MailingPostalCode && data.MailingPostalCode.indexOf(filter) >= 0) || (data.Phone && data.Phone.indexOf(filter) >= 0)){
                    return data;
                }
            });
        }
        if(filter.length<=1){
            component.set("v.hideFooter",true);
            component.set("v.searchResourceList",[]);
            helper.handleFirstLast(component,event,helper,1); 
        }
        if(filterResourceDetails != null && filter.length>=2){
           component.set("v.searchResourceList",filterResourceDetails);
           helper.handlePaginationOnSearch(component,event,helper,1); 
        }
    }, 
    updateColumnSorting: function (cmp, event, helper) {
        
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
    * @description This is the hanlder for method 
   */
    parentComponentEvent : function(component,event,helper){
        helper.getResourceStaff(component,event,helper);
    },
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