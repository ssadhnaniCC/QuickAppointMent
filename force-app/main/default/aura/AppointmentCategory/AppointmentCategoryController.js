({
    /*******************************************************************************************************
    * @description This method is fired on component initialization.
    * @returns void.
    */
    init: function (component, event, helper) {
        helper.getColumnAndAction(component);
        helper.getCategories(component,helper);
    },
    /*******************************************************************************************************
    * @description This method is used to open ModalBox to fill appointment category details.
    * @returns void.
    */
    onAddCategoryClick:function (component, event, helper) {
        component.set("v.isModalOpen",true);        
    },
    /*******************************************************************************************************
    * @description This method is used to view previous page in datatable.
    * @returns void.
    */
    onPrev:function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.pagination(component,event, helper);
    },
    /*******************************************************************************************************
    * @description This method is used to view first page in datatable.
    * @returns void.
    */
    onFirst:function (component, event, helper) {
        component.set("v.pageNumber", 1);        
        helper.pagination(component,event,helper);
    },
    /*******************************************************************************************************
    * @description This method is used to view next page in datatable.
    * @returns void.
    */
    onNext:function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.pagination(component,event,helper);
    },
    /*******************************************************************************************************
    * @description This method is used to view last page in datatable.
    * @returns void.
    */
    onLast:function (component, event, helper) {       
        var pgNumber=Math.ceil(parseInt(component.get("v.dataSize"))/parseInt(component.get("v.pageSize")));
        component.set("v.pageNumber",pgNumber);
        helper.pagination(component,event,helper);
    },   
    /*******************************************************************************************************
    * @description This method is used to handle row action.
    * @returns void.
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
    /*******************************************************************************************************
    * @description This method is used to handle search functionality in datatable.
    * @returns void.
    */
    onSearch:function(component,event,helper){        
        
        //component.set("v.pageNumber",1);
        var strLength= component.get("v.searchString").length;
        var searchFilter = component.get("v.searchString");  
        if(strLength>=2 && !searchFilter.startsWith(' ')){  
            var allRecords = component.get("v.allRecords");
            var tpArray = [];
            var i;        
            for(i=0;i<allRecords.length;i++){
                if((allRecords[i].Name && allRecords[i].Name.toUpperCase().indexOf(searchFilter.toUpperCase()) != -1))
                    
                {
                    tpArray.push(allRecords[i]);
                }
            }
            if(tpArray.length==0){
                component.set("v.data",null);
                component.set("v.isLastPage",true);
                component.set("v.pageNumber",0);  
                component.set("v.totalPages",0);
                return;
            }
            
            component.set("v.searchList",tpArray);  
            component.set("v.onSearch",true);
            helper.pagination(component,event,helper);
        }  
        if(strLength<=1){
            component.set("v.onSearch",false);
            component.set("v.pageNumber",1);
            component.set("v.totalPages", Math.ceil(component.get("v.allRecords").length/10));
            helper.pagination(component,event,helper);
        }
    },
    /*******************************************************************************************************
    * @description This method is used to handle sorting in each column of datatable.
    * @returns void.
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
    * @description This method is used to refresh datatable after save or edit of customer record.
    * @returns void.
    */
    onSaveAndEdit: function(component,event,helper){
        component.set("v.pageNumber",1);
        component.set("v.AppointmentCategoryRecord",{});
        component.set("v.searchString",'');
        helper.getCategories(component,helper);
    }
})