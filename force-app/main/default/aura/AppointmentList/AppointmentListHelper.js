({
   /*******************************************************************************************************
    * @description This is the method which will fetch related Appointments from Apex
   */
    fetchRelatedAppointment : function(component,event,helper){
        component.set('v.relatedAppointmentColumns', [
            {label: 'Appointment Name', fieldName: 'Name', type: 'text' , sortable: true},
            {label: 'Location', fieldName: 'Location', type: 'text' , sortable: true}, 
            {label: 'Service', fieldName: 'Service', type: 'text' , sortable: true},     
            {label: 'Start Date	', fieldName: 'StartDate', type: 'text' , sortable: true},     
            {label: 'Status', fieldName: 'Status', type: 'text' , sortable: true},         
        ]);
            
            var action = component.get("c.relatedAppointment");
            action.setParams({
            "ObjectName" : component.get("v.objName"),
            "recordId" :  component.get("v.recordId")       
            });
            action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            if(response.getReturnValue() != null){
            var rows = response.getReturnValue();
            component.set("v.relatedAppointment",rows);
            if(rows.length == 0){
            component.set("v.showToast",true);
            }
            else{
            component.set("v.pageNumber",1);
            component.set("v.dataSize",rows.length);
            if(rows != null){
            var pagecount= Math.ceil((rows.length)/10);
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
            }
            }
            else {
            
            }               
            });
            $A.enqueueAction(action);  
     },
   /*******************************************************************************************************
     * @description This is the method to handle next page Pagination
    */
    next  : function(component,event,helper){
        var resourceList = component.get("v.relatedAppointment");
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
        var resourceList = component.get("v.relatedAppointment");
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
        var appointmentList = component.get("v.relatedAppointment");   
        var pagecount= Math.ceil((appointmentList.length)/10);
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
            this.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,appointmentList); 
        }
    }, 
    /*******************************************************************************************************
    * @description This is the method which will handle Pagination
   */  
     handlePagination : function(component,event,helper,startPagination,end,appointmentList){
        var pageData = [];
        for(var i =startPagination;i<end ;i++){
            if(appointmentList[i] )
                pageData.push(appointmentList[i]);
            else
                break;
        } 
        component.set("v.paginationData",pageData);
    },  
   /*******************************************************************************************************
    * @description This is the method which will handle Sorting on header clicks
   */    
      sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.paginationData");
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1; 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        component.set("v.paginationData",data);
    },  
 })