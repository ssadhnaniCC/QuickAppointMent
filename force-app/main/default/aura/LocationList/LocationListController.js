({   
    /*******************************************************************************************************
    * @description This method is used to create new record.
    * @returns void.
    */
    handleNew : function(component, event, helper) {
        component.set("v.newLocationModel",true);
        component.set("v.editRow",{});
    },
    /*******************************************************************************************************
    *  @description This is the init method which will fetch Locations and columns of lightning data table from fieldset.
    */
    doInit : function(component, event, helper) {      
        component.set("v.spinerLoaded","True");
        helper.getColumnAndAction(component);
        helper.getLocation(component, helper);
    },
    /*******************************************************************************************************
    * @description This method is used for searching.
    */
    SearchByAddress : function(component, event, helper) {
        var keyword = event.getSource().get("v.value").toUpperCase();
        helper.getByAddress(component,keyword);
    },
    /*******************************************************************************************************
    * @description This method handles next page.
    */
    handleNext : function(component,event,helper){
        helper.next(component,helper);      
    },
    /*******************************************************************************************************
    * @description This method handles previous page.
    */
    handlePrevious : function(component,event,helper){
        helper.previous(component,helper);      
    },
    /*******************************************************************************************************
    * @description This method handles first page. 
    */
    handleStart : function(component,event,helper){
        helper.start(component,helper);      
    },
    /*******************************************************************************************************
    * @description This method handles last page
    * @returns void.
    */
    handleLast : function(component,event,helper){
        helper.last(component,helper);      
    },
    /*******************************************************************************************************
    * @description This method is handle ParentListRefresh event.
    */
    refreshList : function(component,event,helper){
        console.log('event fired');
        helper.getLocation(component, helper);
    },
    /*******************************************************************************************************
    * @description This method handle row action.
    */
    handleRowAction : function(component,event,helper){
        var action = event.getParam('action');
        switch (action.name) {
            case 'edit':
                helper.editRecord(component, event);
                break;
            case 'delete':
                helper.deleteRecord(component, event);
                break;
            case 'appointment':
                component.set("v.showRelatedAppointment",true);
                helper.showRelatedAppointments(component,event,helper);
                break;  
            case 'calendar':
                component.set("v.showCalendar",true);
                helper.showRelatedCalendar(component,event,helper);
                break;
        }
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
    },
    AddPublicHoliday : function(component,event,helper){
        component.set("v.isModalOpen",true);      
    },
    getselectedRow :function(component,event,helper){
       var selectedRows = event.getParam('selectedRows');
        console.log('selectedRow',JSON.stringify(selectedRows));
    },
})