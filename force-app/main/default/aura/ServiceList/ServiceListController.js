({
    /*For creating new Services*/
    createNewService : function(component, event, helper) {
        component.set('v.serviceId','');
        
        component.set('v.isNew',true);
        component.set('v.isModelOpen',true);
        component.set('v.selectedLocations',{});
        component.set('v.serviceRecord',{});
        
    },
    
    /*Initialise method*/
    doInit : function(component, event, helper) {    
        helper.getServiceRecords(component, helper);
        
        
    },
    
    
    /*******************************************************************************************************
    * @description This is the method which will handle the previous functionality 
   */
    onPrev:function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.pagination(component,event, helper);
    },
    
    
    /*******************************************************************************************************
    * @description This is the method which will handle the first page functionality 
   */
    onFirst:function (component, event, helper) {
        component.set("v.pageNumber", 1);        
        helper.pagination(component,event,helper);
    },
    
    
    /*******************************************************************************************************
    * @description This is the method which will handle the next functionality 
   */
    onNext:function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.pagination(component,event,helper);
    },
    
    
    /*******************************************************************************************************
    * @description This is the method which will handle the lastpage functionality 
   */
    onLast:function (component, event, helper) {  
        var pgNumber=Math.ceil(parseInt(component.get("v.dataSize"))/parseInt(component.get("v.pageSize")));
        component.set("v.pageNumber",pgNumber);
        helper.pagination(component,event,helper);
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
            case 'view':
                helper.viewRecord(component, event);
                break;
        }
    },
    
    
    /*******************************************************************************************************
    * @description This is the method which will handle the search functionality
   */
    searchTable : function(component,event,helper) {
        
        var strLength= component.get("v.fltValue").length;
        var searchFilter = component.get("v.fltValue");  
        if(strLength>=2 && !$A.util.isEmpty(searchFilter)){  
            var allRecords = component.get("v.data");
            var tpArray = [];
            var i;        
            for(i=0;i<allRecords.length;i++){
                if((allRecords[i].Name && allRecords[i].Name.toUpperCase().indexOf(searchFilter.toUpperCase()) != -1) ||
                   (allRecords[i].CC_QAppt__Description__c && allRecords[i].CC_QAppt__Description__c.toUpperCase().indexOf(searchFilter.toUpperCase()) != -1) ||
                   (allRecords[i].CC_QAppt__Price__c && allRecords[i].CC_QAppt__Price__c.toString().indexOf(searchFilter) != -1) ||
                   (allRecords[i].CC_QAppt__Duration__c && allRecords[i].CC_QAppt__Duration__c.toString().indexOf(searchFilter) != -1)
                  )
                {
                    tpArray.push(allRecords[i]);
                }
            }
            if(tpArray.length==0){
                component.set("v.filteredData",null);
                component.set("v.isLastPage",true);
                setTimeout(function(){ alert("no record found"); },300);              
                return;
            }
            
            component.set("v.searchList",tpArray);  
            component.set("v.onSearch",true);
            helper.pagination(component,event,helper);
        }  
        if(strLength<=1){
            component.set("v.onSearch",false);
            component.set("v.pageNumber",1);
            helper.pagination(component,event,helper);
        }
        
    },
    
    
    /*******************************************************************************************************
    * @description This is the method which will handle the sorting in datatable
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
    * @description This is the method which will handle the actions after inserting service
   */
    
    onSaveAndEdit : function(component,event,helper){
        component.set("v.pageNumber",1);
        component.set("v.serviceRecord",{});
        component.set('v.selectedLocations',{});
        component.set('v.fltValue',null);
        helper.getServiceRecords(component);
        
    },
    
    
})