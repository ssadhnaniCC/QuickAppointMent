({
   /*******************************************************************************************************
    * @description This is the init method which will fetch Resources and columns of lightning data table from fieldset.
   */
    doInit : function(component, event, helper) {
        
        helper.getColumnOfResource(component);
        helper.getResourceStaff(component);
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
        console.log("rowID",row.Id);
        component.set("v.resourceStaffId",row.Id);   
        switch (action.name) {
            case 'edit':
               helper.editResourceRecord(component, event,helper);
                break;
            case 'delete':
                helper.deleteResourceStaffRecord(component,event,helper);
                break;
            case 'appointment':
                helper.fun(component, event);
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
        var filterResourceDetails = data.filter(function(data){ 
            if((data.Name && data.Name.toLowerCase().indexOf(filter.toLowerCase()) >= 0) || (data.MailingCity && data.MailingCity.toLowerCase().indexOf(filter.toLowerCase()) >= 0)
              ||(data.MailingStreet && data.MailingStreet.toLowerCase().indexOf(filter.toLowerCase()) >= 0) || (data.MailingCountry && data.MailingCountry.toLowerCase().indexOf(filter.toLowerCase()) >= 0) 
              ||(data.MailingState && data.MailingState.toLowerCase().indexOf(filter.toLowerCase()) >= 0) ||
               (data.MailingPostalCode && data.MailingPostalCode.indexOf(filter) >= 0) || (data.Phone && data.Phone.indexOf(filter) >= 0)){
                return data;
            }
        });
        if(filterResourceDetails != null){
            var SearchList = [];
           component.set("v.searchResourceList",filterResourceDetails);
            for(var i=0 ; i<pageSize;i++){
                if(filterResourceDetails[i]){
                    SearchList.push(filterResourceDetails[i]);
                }
            }
            console.log("filterResourceDetails",filterResourceDetails);
            var pagecount= Math.ceil((filterResourceDetails.length)/10);
            component.set("v.pageNumber",1);
            component.set("v.totalPages",pagecount);
            component.set("v.dataSize",filterResourceDetails.length);
            component.set("v.paginationData",SearchList);
        }
    }, 
    updateColumnSorting: function (cmp, event, helper) {
       
    },
    /*******************************************************************************************************
    * @description This is the method which will handle the next functionality 
   */
    handleNext : function(component,event,helper){
        helper.next(component,helper);      
    },
    /*******************************************************************************************************
    * @description This is the method which will call the previous helper 
   */
    handlePrev : function(component,event,helper){
        helper.previous(component,helper); 
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
       helper.getResourceStaff(component);
    }
})