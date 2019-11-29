({
    /*******************************************************************************************************
    * @description This method is used get column headers of datatable.
    * @returns list of columns name.
    */
    getColumnAndAction : function(component) {
        var actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'Appointment', name: 'appointment'},
            {label: 'View Calendar', name: 'calendar'},
        ];
            var action = component.get("c.getFields");
            action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var resultData = response.getReturnValue();  
            resultData.splice(0, 1,{label: 'Appointment Category Name', fieldName: 'linkName',sortable: true, type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}});
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
    		} 	
    		else {
    				console.log("Unknown error");
			}
 			}
			});
	$A.enqueueAction(action);
	},   
    /*******************************************************************************************************
    * @description This method is used to get appointment category data to show in datatable.
    * @returns list of appointment category records.
    */
    getCategories : function(component,helper) {
        var action = component.get("c.getAppointmentCategories");
        action.setParams({
            'appointmentCategoryId':null
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                resultData.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                var dataSize=resultData.length;
                component.set("v.dataSize", resultData.length);
                component.set("v.allRecords",resultData);             
                
                var recSize=parseInt(component.get("v.pageSize"));
                var num=0;
                var pgNumber=0;
                var pagecount=0;
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
                
                component.set("v.showspinner",false);
                component.set("v.data",component.get("v.paginationList"));
                component.set("v.hideFooter",true);
                if(dataSize>0){
                    pagecount= Math.ceil(dataSize/10);
                    component.set("v.pageNumber",1);
                    pgNumber=component.get("v.pageNumber");
                    component.set("v.totalPages",pagecount);
                }
                else{
                    component.set("v.totalPages",0);
                    component.set("v.pageNumber",0);
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
    * @description This method is used to delete appointment categorys record.
    * @returns void.
    */
            deleteRecord : function(component, event,helper) {         
                var action = component.get("c.deleteCategory");       
                var rowId=event.getParam('row').Id;        
                action.setParams({
                    "Id":rowId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS" ) {     
                        component.set("v.showRelatedAppointment",false);
                        component.set("v.showCalendar",false);
                        /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully."
                });
                toastEvent.fire();              
               */
                        component.set("v.pageNumber",1);
                        this.getCategories(component,helper);
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
    * @description This method is edit appointment category record.
    * @returns void.
    */
        editRecord : function(component, event) {
            
            component.set("v.showCalendar",false);
            component.set("v.showRelatedAppointment",false);
            component.set("v.isModalOpen",true);
            var rowId = event.getParam('row').Id;
            
            // component.set("v.AppointmentCategoryRecord",row); 
            var NewAppointmentCategoryComponent = component.find("NewAppointmentCategory");
            NewAppointmentCategoryComponent.GetCategoryRecords(rowId);
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
                    component.set("v.totalPages",totalPages);
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
                component.set("v.data", tempArray);
            },
                /******************************************************************************************************
    * @description This method is used to do sorting on columns.
    * @returns void.*/
            
            sortData : function(component,fieldName,sortDirection){
                var data = component.get("v.data");
                //function to return the value stored in the field
                var key = function(a) { return a[fieldName]; }
                var reverse = sortDirection == 'asc' ? 1: -1;      
                // to handel number/currency type fields 
                if(fieldName == 'Name'){ 
                    data.sort(function(a,b){
                        var a = key(a) ? key(a) : '';
                        var b = key(b) ? key(b) : '';
                        return reverse * ((a>b) - (b>a));
                    }); 
                }
                /*  else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }*/
            //set sorted data to accountData attribute
            component.set("v.data",data);
        },
    showRelatedCalendar : function(component,event,helper){
        var rowId = event.getParam('row').Id;
        component.set("v.showRelatedAppointment",false);
        component.set('v.workingHours',false);
        component.set("v.showWorkingHoursList",false);
        var childCmp = component.find("childCalendar");
        var retnMsg = childCmp.relatedcalendar('CC_QAppt__Appointment_Category__c',rowId);  
    },
    showRelatedAppointments : function(component,event,helper){
        var rowId = event.getParam('row').Id;
        component.set("v.showCalendar",false);
        component.set('v.workingHours',false);
        component.set("v.showWorkingHoursList",false);
        var childCmp = component.find("childAppointment");
        var retnMsg = childCmp.relatedAppointments('CC_QAppt__Appointment_Category__c',rowId);    
    },

})