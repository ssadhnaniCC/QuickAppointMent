({
    /*For creating new Services*/
	createNewService : function(component, event, helper) {
		component.set('v.isNew',true);
        component.set('v.isModelOpen',true);
        
        helper.getLocationData(component,event);
	},
    
    /*Initialise method*/
    doInit : function(component, event, helper) {    
        helper.getServiceRecords(component, helper);
       
        
    },
     
    /*method for previous page*/
    onPrev:function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.pagination(component,event, helper);
    },
    onFirst:function (component, event, helper) {
        component.set("v.pageNumber", 1);        
        helper.pagination(component,event,helper);
    },
    onNext:function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.pagination(component,event,helper);
    },
    onLast:function (component, event, helper) {  
        var pgNumber=Math.ceil(parseInt(component.get("v.dataSize"))/parseInt(component.get("v.pageSize")));
        component.set("v.pageNumber",pgNumber);
        helper.pagination(component,event,helper);
    },
 
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
    
     filter: function(component, event, helper) {
         alert('In');
        var data = component.get("v.data"),
            term = component.get("v.filter"),
            results = data, regex;
        try {
            alert('InTry');
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            results = data.filter(row=>regex.test(row.name));
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.data", results);
         console.log('data==',component.get('v.data'));
    },
    
    searchTable : function(cmp,event,helper) {
        
        var filter = component.get("v.fltValue");
        var data   = component.get("v.data");
        var pageSize = component.get("v.pageSize");
        var filterServiceDetails = data.filter(function(data){ 
            if((allRecords[i].Name && allRecords[i].Name.toUpperCase().indexOf(searchFilter.toUpperCase()) != -1) ||
              (allRecords[i].CC_QAppt__Description__c && allRecords[i].CC_QAppt__Description__c.toUpperCase().indexOf(searchFilter.toUpperCase()) != -1) ||
              (allRecords[i].CC_QAppt__Price__c && allRecords[i].CC_QAppt__Price__c.toString().indexOf(searchFilter) != -1) ||
               (allRecords[i].CC_QAppt__Duration__c && allRecords[i].CC_QAppt__Duration__c.toString().indexOf(searchFilter) != -1)
              ){
                return data;
            }
        });
        
        console.log('filterServiceDetails@@',filterServiceDetails);
        
        if(filterServiceDetails != null){
            var SearchList = [];
           component.set("v.searchList",filterServiceDetails);
            for(var i=0 ; i<pageSize;i++){
                if(filterServiceDetails[i]){
                    SearchList.push(filterServiceDetails[i]);
                }
            }
            console.log("filterServiceDetails",filterServiceDetails);
            var pagecount= Math.ceil((filterServiceDetails.length)/10);
            component.set("v.pageNumber",1);
            component.set("v.totalPages",pagecount);
            component.set("v.dataSize",filterServiceDetails.length);
            component.set("v.filteredData",SearchList);
        }
		
},
    
    handleSort : function(component,event,helper){
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onSaveAndEdit : function(component,event,helper){
        component.set("v.pageNumber",1);
        component.set("v.dataToBeSend",{});
        component.set('v.fltValue',null);
        helper.getServiceRecords(component);
        
    },
    
     /*******************************************************************************************************
    * @description This is the method which will handle the next functionality 
   */
    handleNext : function(component,event,helper){
        helper.nextPage(component,event,helper);      
    },
    /*******************************************************************************************************
    * @description This is the method which will call the previous helper 
   */
    handlePrev : function(component,event,helper){
        helper.previousPage(component,event,helper); 
    },
   /*******************************************************************************************************
    * @description This is the method which will handle the First button pagination
   */
    handleFirst : function(component,event,helper){
        helper.startPage(component,event,helper);
    },
   /*******************************************************************************************************
    * @description This is the method which will handle the Last button pagination
   */
    handleLast : function(component,event,helper){
        helper.lastPage(component,event,helper);
    },
    
    
})