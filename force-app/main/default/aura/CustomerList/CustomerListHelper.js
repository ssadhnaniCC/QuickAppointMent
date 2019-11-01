({
	/*******************************************************************************************************
    * @description This method is used get column headers of datatable.
    * @returns void.
    */
    getColumnAndAction : function(component) {
        var actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'Appointment', name: 'Appointment'}
        ];
        var action = component.get("c.getFields");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();               
                resultData.push({type: 'action', typeAttributes: { rowActions: actions }});
                component.set("v.columns", resultData);
            }       
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },   
    /*******************************************************************************************************
    * @description This method is used to get customer data to show in datatable.
    * @returns void.
    */
    getCustomers : function(component,helper) {
        var action = component.get("c.getCustomers");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log('resultData=',resultData);
                var dataSize=resultData.length;
                component.set("v.dataSize", resultData.length);
                component.set("v.allRecords",resultData);             
                console.log(resultData);             
                var recSize=parseInt(component.get("v.pageSize"));
                var num=0;
        var customerRecords=[];
        var dataSize=component.get("v.allRecords").length;
        var recSize=component.get("v.pageSize");
        for(var i=0;i<dataSize;i++){
            if(num>=recSize){
                break;
            }
            if(component.get("v.allRecords")[i]!='undefined'){
                customerRecords.push(component.get("v.allRecords")[i]);
                num++;                    
            }                
        }
        component.set("v.paginationList",customerRecords);  
        console.log(component.get("v.paginationList")); 
                component.set("v.showspinner",false);
        component.set("v.data",component.get("v.paginationList"));
                component.set("v.hideFooter",true);
        var pagecount= Math.ceil(dataSize/10);
        var pgNumber=component.get("v.pageNumber");
        var totalPages= component.get("v.totalPages");
        component.set("v.totalPages",pagecount);
        if(totalPages==pgNumber){
            component.set("v.isLastPage", true);
        } else{
            component.set("v.isLastPage", false);
        }             
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    /*******************************************************************************************************
    * @description This method is fired on component initialization.
    * @returns void.
    
    viewRecord : function(component, event) {
        var row = event.getParam('row');       
        var recordId = row.Id;        
        var navEvt = $A.get("event.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },  */
    /*******************************************************************************************************
    * @description This method is used to delete customer record.
    * @returns void.
    */
    deleteRecord : function(component, event,helper) {         
        var action = component.get("c.deleteCustomer");       
        var rowId=event.getParam('row').Id;        
        action.setParams({
            "customerId":rowId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                alert('record deleted');                         
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully."
                });
                toastEvent.fire();              
               */
                component.set("v.pageNumber",1);
                this.getCustomers(component,helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },  
    /*******************************************************************************************************
    * @description This method is edit customer record.
    * @returns void.
    */
    editRecord : function(component, event) {
        component.set("v.isModalOpen",true);
        var row = event.getParam('row');
        component.set("v.customerRecord",row);        
    }, 
    /*******************************************************************************************************
    * @description This method is used  handle pagination in datatable.
    * @returns void.
    */
    pagination:function(component,event,helper){
        var allRecords=[];
        var totalPages=0;        
        if(component.get("v.onSearch")){
            allRecords=component.get("v.searchList");            
           
            component.set("v.pageNumber",1);
            totalPages=Math.ceil((allRecords.length)/10);
            component.set("v.onSearch",false);
        }
        else{
            allRecords = component.get("v.allRecords");
            totalPages= component.get("v.totalPages");}
        var total=allRecords.length;   
        var recSize=parseInt(component.get("v.pageSize"));
        var pgNumber=component.get("v.pageNumber");       
        var start=(parseInt(component.get("v.pageNumber"))-1)*parseInt(component.get("v.pageSize"));       
        var j=0;
        var tempArray=[];
        console.log('in pagination',allRecords);
        for(var i=start;i<total;i++){
            if(j>=recSize){
                break;  
            }
            if(allRecords[i]!='undefined'){
                console.log(i);
                tempArray.push(allRecords[i]);
                j++;               
            }            
        }
        console.log('in pagination',tempArray);        
        if(pgNumber==totalPages){
            component.set("v.isLastPage", true);
        } else{
            component.set("v.isLastPage", false);
        }
        console.log('after pagination',tempArray);
        component.set("v.paginationList",tempArray);
        component.set("v.data", tempArray);
    },
    /*******************************************************************************************************
    * @description This method is fired on component initialization.
    * @returns void.
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.accountData");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;      
        // to handel number/currency type fields 
        if(fieldName == 'NumberOfEmployees'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        //set sorted data to accountData attribute
        component.set("v.accountData",data);
    },*/
    /*******************************************************************************************************
    * @description This method is fired on component initialization.
    * @returns void.
    */
    assignRecordsToList:function(component,event,helper){
        var num=0;
        var customerRecords=[];
        var dataSize=component.get("v.allRecords").length;
        var recSize=component.get("v.pageSize");
        for(var i=0;i<dataSize;i++){
            if(num>=recSize){
                break;
            }
            if(component.get("v.allRecords")[i]!='undefined'){
                customerRecords.push(component.get("v.allRecords")[i]);
                num++;                    
            }                
        }
        component.set("v.paginationList",customerRecords);  
        console.log(component.get("v.paginationList"));               
        component.set("v.data",component.get("v.paginationList"));
        var pagecount= Math.ceil(dataSize/10);
        var pgNumber=component.get("v.pageNumber");
        var totalPages= component.get("v.totalPages");
        component.set("v.totalPages",pagecount);
        if(totalPages==pgNumber){
            component.set("v.isLastPage", true);
        } else{
            component.set("v.isLastPage", false);
        }
    }
})