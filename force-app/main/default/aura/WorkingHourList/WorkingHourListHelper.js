({
    fetchAllWorkingHours : function(component,event,helper) {
        
    },
    
    /*******************************************************************************************************
    * @description Method for all column action
   */
    
    getColumnAndAction : function(component) {
        
        var action = component.get("c.getWorkingHourFieldSet");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();               
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
    * @description Method to fetch all working hour list
   */
    
    getWorkingHour : function(component,helper) {
        component.set('v.isSpinner',true);
        
        var action = component.get("c.getWorkingHour");
        action.setParams({"appId":component.get('v.resourceStaffId')});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                if(resultData.length>0) {
                    console.log('resultData'+JSON.stringify(resultData));
                    component.set('v.showToast',false);
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
                            console.log("recordsUPDATED"+JSON.stringify(component.get("v.allRecords")[i]));
                            var obj = {Id:component.get("v.allRecords")[i].Id,CC_QAppt__Active__c:component.get("v.allRecords")[i].Active,CC_QAppt__Start_Time__c:component.get("v.allRecords")[i].StartTime,CC_QAppt__End_Time__c:component.get("v.allRecords")[i].EndTime};
                           // console.log('startTime'+component.get("v.allRecords")[i].CC_QAppt__Start_Time__c);
                           // console.log('EndTime'+component.get("v.allRecords")[i].CC_QAppt__End_Time__c);
                          //  console.log($A.localizationService.formatDate(component.get("v.allRecords")[i].CC_QAppt__Start_Time__c, "MMMM dd yyyy, hh:mm:ss a"));
                            customerRecords.push(obj);
                            num++;                    
                        }                
                    }
                    component.set("v.paginationList",customerRecords);  
                    
                    component.set("v.isSpinner",false);
                    component.set("v.data",component.get("v.paginationList"));
                    component.set("v.hideFooter",true);
                    if(dataSize>0){
                        pagecount= Math.ceil(dataSize/10);
                        
                        
                        component.set("v.totalPages",pagecount);
                        component.set("v.pageNumber",1);
                        pgNumber=component.get("v.pageNumber");
                    }
                    else{
                        component.set("v.totalPages",0);
                        component.set("v.pageNumber",0);
                    }
                    var totalPages= component.get("v.totalPages");
                    if(totalPages==pgNumber){
                        component.set("v.isLastPage", true);
                    } else{
                        component.set("v.isLastPage", false);
                    }             
                }
                else {
                    
                    component.set('v.data',[]);
                    component.set('v.showToast',true);
                    component.set('v.isSpinner',false);
                    component.set('v.pageNumber',0);
                    component.set('v.totalPages',0);
                    
                    
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
    * @description Method to handle sorting in datatable
   */
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.data");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;      
        // to handel number/currency type fields 
        
        if(fieldName == 'Start Date'){ 
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
        component.set("v.data",data);
    },
    
    /*******************************************************************************************************
    * @description In this method we handle pagination
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
            totalPages=Math.ceil((allRecords.length)/10);
            component.set("v.totalPages",totalPages);
            //  totalPages= component.get("v.totalPages");
        }
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
        console.log('in pagination',tempArray);        
        if(pgNumber==totalPages){
            component.set("v.isLastPage", true);
        } else{
            component.set("v.isLastPage", false);
        }
        
        component.set("v.paginationList",tempArray);
        component.set("v.data", tempArray);
    },
    
    /*******************************************************************************************************
    * @description Method to fetch resource name
   */
    
    fetchResourceName : function(component,event,resourceId) {
        var action = component.get('c.getResourceName');
        action.setParams({
            "resId":component.get('v.resourceStaffId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                
                component.set('v.resourceRecord',response.getReturnValue());
                
                // alert('record deleted');                         
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully."
                });
                toastEvent.fire();              
               */
                //component.set("v.pageNumber",1);
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            
                        }
                    } else {
                        
                    }
                }
        });
        $A.enqueueAction(action);
    }
    
})