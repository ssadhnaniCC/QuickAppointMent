({
    /*******************************************************************************************************
     * @description This is the method to fetch Location and set Pagination
    */
    getLocation : function(component) {
        var action1 = component.get("c.getLocation");
        action1.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var resultData = response.getReturnValue();
                resultData.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                var pageSize = component.get("v.pageSize");
                if(resultData != null){
                    component.set("v.dataList",resultData);
                    component.set("v.locationList",resultData);
                    component.set("v.dataSize",resultData.length);
                    var pagecount= Math.ceil((resultData.length)/10);
                    component.set("v.totalPages",pagecount);
                    
                    this.pagination(component,0,pageSize,resultData);
                    
                    if(pagecount == 0){
                        component.set("v.pageNumber",0);
                    }
                    else{
                        component.set("v.pageNumber",1);
                    }
                    component.set("v.searchByAddress",'');
                    component.set("v.spinerLoaded",false);
                }
            }else if(state === "ERROR"){
                /* toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error in Getting Location Record."
                    });
                    toastEvent.fire();*/
            }
            
        });
        $A.enqueueAction(action1);
    },
    /*******************************************************************************************************
     * @description This is the method used to fetch columns
    */
    getColumnAndAction : function(component) {
        var actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'Appointment', name: 'appointment'},
            {label: 'View Calendar', name: 'calendar'},
        ];
        var action = component.get("c.getLocationFieldSet");
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                var resourceData = response.getReturnValue();
            console.log('fhj',JSON.stringify(resourceData));
                resourceData.splice(0, 1,{label: 'Location', fieldName: 'linkName',sortable: true, type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}});
                
                resourceData.push({type: 'action', typeAttributes: { rowActions: actions } });
                component.set('v.columns',resourceData);
            }
        });
        $A.enqueueAction(action);
    },
    /*******************************************************************************************************
     * @description This is the method used to search data
    */
    getByAddress : function(component,keyword) {
        var locationList = component.get("v.locationList");
        var pageSize = component.get("v.pageSize");
        var pagelist=[];
        var tmpList = [];
        var i;
        if(keyword.length >= 2){
            for(i = 0; i < locationList.length; i++){
                
                if((locationList[i].Name && locationList[i].Name.toUpperCase().indexOf(keyword.toUpperCase()) != -1)||
                   (locationList[i].CC_QAppt__Street__c && locationList[i].CC_QAppt__Street__c.toUpperCase().indexOf(keyword.toUpperCase())  != -1)||
                   (locationList[i].CC_QAppt__City__c && locationList[i].CC_QAppt__City__c.toUpperCase().indexOf(keyword.toUpperCase())  != -1)||
                   (locationList[i].CC_QAppt__State__c &&locationList[i].CC_QAppt__State__c.toUpperCase().indexOf(keyword.toUpperCase())  != -1)||
                   (locationList[i].CC_QAppt__Postal_Code__c && locationList[i].CC_QAppt__Postal_Code__c.toUpperCase().indexOf(keyword.toUpperCase())  != -1)||
                   (locationList[i].CC_QAppt__Country__c && locationList[i].CC_QAppt__Country__c.toUpperCase().indexOf(keyword.toUpperCase())  != -1)){
                    tmpList.push(locationList[i]);
                }
            }
        }
        else{
            tmpList = locationList;
        }
        component.set("v.dataList",tmpList); 
        
        this.pagination(component,0,pageSize,tmpList);
        
        var pagecount= Math.ceil((tmpList.length)/10);
        component.set("v.totalPages",pagecount);
        if(pagecount == 0){
            component.set("v.pageNumber",0);
        }
        else{
            component.set("v.pageNumber",1);
        }
    },
    /*******************************************************************************************************
     * @description This method contain logic of next button of pagination
    */
    next : function(component,helper){
        var resourceList = component.get("v.dataList");
        var start  = component.get("v.pageNumber")+1;
        var recordPerPage = component.get("v.pageSize")  
        var i = start * recordPerPage;
        component.set("v.pageNumber",start);
        
        this.pagination(component,i-recordPerPage,i,resourceList);
    },
    /*******************************************************************************************************
     * @description This method contain logic of previous button of pagination
    */
    previous : function(component,helper){
        var resourceList = component.get("v.dataList");
        var start  = component.get("v.pageNumber")-1;
        var recordPerPage = component.get("v.pageSize");  
        if(start>=1){
            var i = start * recordPerPage;
            component.set("v.pageNumber",start);
            
            this.pagination(component,i-recordPerPage,i,resourceList);
        }
    },
    /*******************************************************************************************************
     * @description This method contain logic of start button of pagination
    */
    start : function(component,helper){
        var resourceList = component.get("v.dataList");
        var recordPerPage = component.get("v.pageSize")
        component.set("v.pageNumber",1);
        var size = 1 * recordPerPage;
        
        this.pagination(component,0,size,resourceList);
    },
    /*******************************************************************************************************
     * @description This method contain logic of last button of pagination
    */
    last : function(component,helper){
        var resourceList = component.get("v.dataList");
        var lastPage  = component.get("v.totalPages");
        var recordPerPage = component.get("v.pageSize");
        var i = lastPage * recordPerPage;
        component.set("v.pageNumber",lastPage);
        
        this.pagination(component,i-recordPerPage,i,resourceList);
    },
    /*******************************************************************************************************
     * @description This method called on edit
    */
    editRecord : function(component,event){
        component.set("v.showCalendar",false);
        component.set("v.showRelatedAppointment",false);
        var row = event.getParam('row');
        console.log(JSON.stringify(row));
        component.set('v.editRow',row);
        component.set('v.newLocationModel',true);
    },
    /*******************************************************************************************************
     * @description This method called on edit
    */
    deleteRecord : function(component,event){
        var row = event.getParam('row');
        
        var action = component.get("c.deleteLocation");
        action.setParams({
            "dltId" : row.Id
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
              component.set("v.showRelatedAppointment",false);
              component.set("v.showCalendar",false);
                this.getLocation(component);
                /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record has been Deleted successfully."
                    });
                    toastEvent.fire();*/
            }else if(state === "ERROR"){
                /* toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error in Deleting Location Record."
                    });
                    toastEvent.fire();*/
            }
        });
        $A.enqueueAction(action);
    },
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.paginationList");
        var key = function(a) { return a[fieldName]; }
        var numkey = function(a){return Number(a[fieldName])};
        var reverse = sortDirection == 'asc' ? 1: -1;
        // to handel number/currency type fields 
        if(fieldName == 'CC_QAppt__Postal_Code__c'){ 
            data.sort(function(a,b){
                var a = numkey(a) ? numkey(a) : '';
                var b = numkey(b) ? numkey(b) : '';
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
        component.set("v.paginationList",data);
    },
    /*******************************************************************************************************
     * @description This method called by getLocation,getByAddress,next,last,start,previous
    */
    pagination : function(component,start,end,data){
        var pagelist = [];
        for(var i=start;i<end;i++){
            if(data[i])
                pagelist.push(data[i]);  
            else
                break;
        }
        component.set("v.paginationList",pagelist);
    },
    showRelatedAppointments : function(component,event,helper){
        component.set("v.showCalendar",false);
        var recordId = event.getParam('row').Id;
        var childCmp = component.find("childAppointment");
        var retnMsg = childCmp.relatedAppointments('CC_QAppt__Location__c',recordId);    
    },
       showRelatedCalendar : function(component,event,helper){
            component.set("v.showRelatedAppointment",false);
            var recordId = event.getParam('row').Id;
           var childCmp = component.find("childCalendar");
           var retnMsg = childCmp.relatedcalendar('CC_QAppt__Location__c',recordId);  
       },
})