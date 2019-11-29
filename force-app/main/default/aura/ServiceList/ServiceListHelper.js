({
    
    /*******************************************************************************************************
    * @description This is the method which will handle delete service record row
   */
    deleteRecord : function(component, event) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        var action = component.get("c.deleteService");
        action.setParams({
            "ser": row
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                component.set("v.showRelatedAppointment",false);
                component.set("v.showCalendar",false);
                component.set("v.pageNumber",1);
                this.getServiceRecords(component);
                
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
    * @description This is the method which will handle edit functionality for table row
   */
    
    editRecord : function(component, event) {
        component.set("v.showCalendar",false);
        component.set("v.showRelatedAppointment",false);
        component.set('v.serviceId',' ');
        var row = event.getParam('row');  
        
        component.set("v.isModelOpen",true);   
        component.set("v.serviceId",row.Id);  
        var childCmp = component.find("childComp");
        var retnMsg = childCmp.getEditMethod();   
        
    },    
    
    /*******************************************************************************************************
    * @description This is the method which will handle the records to be show in datatable
   */
    
    getServiceRecords : function(component,event,helper) {
        component.set('v.isSpinner',true);
        var action = component.get('c.getAllServices');
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                
                var responseData = response.getReturnValue();
                
                this.getColumnOfServices(component,event,responseData.listOfFieldSets);
                 responseData.listOfServices.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set('v.data',responseData.listOfServices);
                var dataLength = component.get('v.data').length;
                var pageSize = component.get('v.pageSize');
                
                component.set("v.totalSize", dataLength);
                component.set("v.dataSize", dataLength);
                var recSize=parseInt(component.get("v.pageSize"));
                var num=0;
                var pgNumber=0;
                var pagecount=0;
                var customerRecords=[];
                for(var i=0;i<dataLength;i++){
                    if(num>=recSize){
                        break;
                    }
                    if(component.get("v.data")[i]!='undefined'){
                        customerRecords.push(component.get("v.data")[i]);
                        num++;                    
                    }                
                }
                
                component.set("v.paginationList",customerRecords);  
                
                component.set("v.isSpinner",false);
                component.set("v.filteredData",component.get("v.paginationList"));
                component.set("v.hideFooter",true);
                var pagecount= Math.ceil(dataLength/10);
                /*ar pgNumber=component.get("v.pageNumber");
                var totalPages= component.get("v.totalPages");
                component.set("v.totalPages",pagecount);
                
                if(totalPages==pgNumber){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }*/
                if(dataLength>0){
                    pagecount= Math.ceil(dataLength/10);
                    
                    
                    component.set("v.totalPages",pagecount);
                    component.set("v.pageNumber",1);
                    pgNumber=component.get("v.pageNumber");
                }
                else{
                    component.set("v.totalPages",0);
                }
                var totalPages= component.get("v.totalPages");
                if(totalPages==pgNumber){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }          
                
                
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
    * @description This is the method which will handle edit, delete functionality for table row
   */    
    getColumnOfServices : function(component,event,columnList) {
        var actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'Appointment', name: 'appointment'},
            {label: 'View Calendar', name: 'calendar'}, 
        ];
            
            var colNames = columnList;
            colNames.splice(0, 1,{label: 'Service Name', fieldName: 'linkName',sortable: true, type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}});
            colNames.push({type: 'action', typeAttributes: { rowActions: actions }});
            component.set('v.columns',colNames);
            },
            
            /*******************************************************************************************************
    * @description This is the method which will handle the pagination functionlity for datatable
   */
             
             pagination:function(component,event,helper){
             //alert();
             var allRecords=[];
        var totalPages=0;        
        if(component.get("v.onSearch")){
            allRecords=component.get("v.searchList");            
            
            component.set("v.pageNumber",1);
            totalPages=Math.ceil((allRecords.length)/10);
            component.set("v.onSearch",false);
        }
        else{
            allRecords = component.get("v.data");
            totalPages= component.get("v.totalPages");}
        var total=allRecords.length;   
        var recSize=parseInt(component.get("v.pageSize"));
        var pgNumber=component.get("v.pageNumber");       
        var start=(parseInt(component.get("v.pageNumber"))-1)*parseInt(component.get("v.pageSize"));       
        var j=0;
        var tempArray=[];
        
        for(var i=start;i<total;i++){
            if(j>=recSize){
                break;  
            }
            if(allRecords[i]!='undefined'){
                
                tempArray.push(allRecords[i]);
                j++;               
            }            
        }
        
        if(pgNumber==totalPages){
            component.set("v.isLastPage", true);
        } else{
            component.set("v.isLastPage", false);
        }
        
        component.set("v.paginationList",tempArray);
        component.set("v.filteredData", tempArray);
    },
    
    
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.filteredData");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;      
        
        if(fieldName == 'CC_QAppt__Duration__c' || fieldName == 'CC_QAppt__Price__c'){ 
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
        component.set("v.filteredData",data);
    },
    showRelatedAppointments : function(component,event,helper){
        component.set("v.showCalendar",false);
        var recordId = event.getParam('row').Id;
        var childCmp = component.find("childAppointment");
        var retnMsg = childCmp.relatedAppointments('CC_QAppt__Service__c',recordId);    
    },
    showRelatedCalendar : function(component,event,helper){
        component.set("v.showRelatedAppointment",false);
        var recordId = event.getParam('row').Id;
        var childCmp = component.find("childCalendar");
        var retnMsg = childCmp.relatedcalendar('CC_QAppt__Service__c',recordId);  
    },
    
    
})