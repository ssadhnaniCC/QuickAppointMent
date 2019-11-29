({
    
    /*******************************************************************************************************
    * @description This is the method which will populate headers of lightning data table.
   */
    getColumnOfResource : function(component) {
        var actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'Appointment', name: 'appointment'},
            {label: 'View Calendar', name: 'calendar'},
            {label: 'Working Hours', name: 'Working Hours'}
        ];
        var action = component.get("c.getResourceFieldSet");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resourceFields = response.getReturnValue();
                resourceFields.splice(0, 1,{label: 'Resource', fieldName: 'linkName',sortable: true, type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}});
                resourceFields.push({type: 'action', typeAttributes: { rowActions: actions }});
                component.set("v.columns",resourceFields);
            }
        }); 
        $A.enqueueAction(action);
    },
    
    /*******************************************************************************************************
     * @description This is the method to fetch Resource Staff
    */
    getResourceStaff : function(component,event,helper){
        var action = component.get("c.getAllResources");
        action.setCallback(this,function(response) {
            var state = response.getState();
            var pageSize = component.get("v.pageSize");
            if (state === "SUCCESS") {
                var resourcedata = response.getReturnValue();
                resourcedata.forEach(function(resource){
                    resource.linkName = '/'+resource.Id;
                })
                component.set("v.resourceData",resourcedata);
                component.set("v.showspinner",false);
                component.set("v.hideFooter",true);
                component.set("v.pageNumber",1);
                component.set("v.dataSize",resourcedata.length);
                if(resourcedata != null){
                    var pagecount= Math.ceil((resourcedata.length)/10);
                    if(pagecount==0){
                        component.set("v.pageNumber",0);
                        component.set("v.totalPages",0);
                    }
                    else{
                        component.set("v.pageNumber",1);
                        component.set("v.totalPages",pagecount);
                    }
                    
                    this.handleFirstLast(component,event,helper,component.get("v.pageNumber"));
                }        
            }
        });
        $A.enqueueAction(action);
    },
    
    /*******************************************************************************************************
     * @description This is the method to handle next page Pagination
    */
    next  : function(component,event,helper){
        var resourceList = component.get("v.resourceData");
        var searchResourceList = component.get("v.searchResourceList");
        if(searchResourceList.length){
            resourceList = searchResourceList;
        }
        var startPagination  = component.get("v.pageNumber")+1;
        component.set("v.pageNumber",startPagination);
        var recordPerPage = component.get("v.pageSize");
        var endPagination = startPagination * recordPerPage;
        helper.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,resourceList);
    },
    
    /*******************************************************************************************************
     * @description This is the method to handle previous page Pagination
    */     
    previous : function(component, event, helper) {
        var resourceList = component.get("v.resourceData");
        var searchResourceList = component.get("v.searchResourceList");
        if(searchResourceList.length){
            resourceList = searchResourceList;
        }
        var startPagination  = component.get("v.pageNumber")-1;
        component.set("v.pageNumber",startPagination);
        var recordPerPage = component.get("v.pageSize");
        var endPagination = startPagination * recordPerPage;
        helper.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,resourceList);
    },
    
    /*******************************************************************************************************
     * @description    This is the method to handle first last page Pagination
    */    
    handleFirstLast : function(component,event,helper,pagenumber){
        var resourceList = component.get("v.resourceData");   
        var searchResourceList = component.get("v.searchResourceList");
        if(searchResourceList.length){
            resourceList = searchResourceList;
        }
        var pagecount= Math.ceil((resourceList.length)/10);
        if(pagecount==0){
            component.set("v.pageNumber",0);
            component.set("v.totalPages",0);
            component.set("v.paginationData",[]);
        }
        else{
            component.set("v.totalPages",pagecount);
            component.set("v.pageNumber",pagenumber);
            var recordPerPage = component.get("v.pageSize");    
            var endPagination = pagenumber * recordPerPage;
            this.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,resourceList); 
        }
    },
    
    /*******************************************************************************************************
     * @description This is the method to handle delete resource staff
    */      
    deleteResourceStaffRecord : function(component,event,helper){
        var resourceId = component.get("v.resourceStaffId");
        var action = component.get("c.deleteResourceStaff");
        action.setParams({
            "resourceStaffId" :  component.get("v.resourceStaffId")       
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set("v.showRelatedAppointment",false);
              component.set("v.showCalendar",false);
              this.getResourceStaff(component);
            }
            else {
                console.log('Failed with state: ' + state);
            }               
        });
        $A.enqueueAction(action);  
    },
    
    /*******************************************************************************************************
     * @description  This method call aura method of child to refresh resource list 
    */   
    editResourceRecord :  function(component,event,helper){
        component.set("v.showCalendar",false);
         component.set("v.showRelatedAppointment",false);
        component.set("v.showWorkingHoursList",false);
        var row = event.getParam('row');  
        component.set("v.openNewResourceModal",true);   
        component.set("v.resourceStaffId",row.Id);  
        
        var childCmp = component.find("childCmp");
        var retnMsg = childCmp.childMethodCalled();           
    },
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.paginationData");
        var key = function(a) { return a[fieldName]; }
        var numkey = function(a){return Number(a[fieldName])};
        var reverse = sortDirection == 'asc' ? 1: -1;
        // to handel number/currency type fields 
        if(fieldName == 'Phone' || fieldName=='MailingPostalCode'){ 
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
        component.set("v.paginationData",data);
    },
    
    handlePaginationOnSearch : function(component,event,helper,pagenumber){
        var searchResourceList = component.get("v.searchResourceList");
        console.log("searchResourceListIMP"+JSON.stringify(searchResourceList));
        var pagecount= Math.ceil((searchResourceList.length)/10);
        console.log("pagecount"+pagecount);
        if(pagecount==0){
            component.set("v.pageNumber",0);
            component.set("v.totalPages",0);
            component.set("v.paginationData",[]);
        }
        else{
            component.set("v.pageNumber",pagenumber);
            component.set("v.totalPages",pagecount);
            var recordPerPage = component.get("v.pageSize");      
            var endPagination = pagenumber * recordPerPage;
            helper.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,searchResourceList);
        }
    },
    
    handlePagination : function(component,event,helper,startPagination,end,resourceData){
        var pageData = [];
        for(var i =startPagination;i<end ;i++){
            if(resourceData[i] )
                pageData.push(resourceData[i]);
            else
                break;
        } 
        component.set("v.paginationData",pageData);
    },
    showRelatedCalendar : function(component,event,helper){
        component.set("v.showRelatedAppointment",false);
        component.set('v.workingHours',false);
        component.set("v.showWorkingHoursList",false);
        var childCmp = component.find("childCalendar");
        var retnMsg = childCmp.relatedcalendar('Contact',component.get("v.resourceStaffId"));  
    },
    showRelatedAppointments : function(component,event,helper){
        component.set("v.showCalendar",false);
        component.set('v.workingHours',false);
        component.set("v.showWorkingHoursList",false);
        var childCmp = component.find("childAppointment");
        var retnMsg = childCmp.relatedAppointments('Contact',component.get("v.resourceStaffId"));    
    },
    
    showWorkingHours : function(component,event,helper) {
       component.set("v.showRelatedAppointment",false);
        component.set("v.showCalendar",false);
        component.set('v.workingHours',true);
    },
    workingHourRecords :  function(component,event,helper){
        component.set("v.showRelatedAppointment",false);
        component.set("v.showCalendar",false);
        var row = event.getParam('row');  
        component.set("v.resourceStaffId",row.Id);    
        var worMethod = component.find('workHour').getWorkingMethod(row.name);
    },
    
    
})