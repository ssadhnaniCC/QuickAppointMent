({
    
    /*******************************************************************************************************
    * @description This is the method which will populate headers of lightning data table.
   */
    getColumnOfResource : function(component) {
        var actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'Appointment', name: 'appointment'},
        ];
            var action = component.get("c.getResourceFieldSet");
            action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var resourceFields = response.getReturnValue();
            resourceFields.push({type: 'action', typeAttributes: { rowActions: actions }});
            component.set("v.columns",resourceFields);
            }
            }); 
            $A.enqueueAction(action);
       },
            
    /*******************************************************************************************************
     * @description This is the method to fetch Resource Staff
    */
   getResourceStaff : function(component){
            var action = component.get("c.getAllResources");
            action.setCallback(this,function(response) {
            var state = response.getState();
            var pageSize = component.get("v.pageSize");
            if (state === "SUCCESS") {
            var resourcedata = response.getReturnValue();
            component.set("v.resourceData",response.getReturnValue());
            component.set("v.showspinner",false);
            component.set("v.hideFooter",true);
            component.set("v.pageNumber",1);
            component.set("v.dataSize",resourcedata.length);
            var pagecount= Math.ceil((resourcedata.length)/10);
            component.set("v.totalPages",pagecount);
            var pagelist=[];
          for(var i=0;i<pageSize;i++){
            if(resourcedata[i])
                pagelist.push(resourcedata[i]);  
            else
                break;
        }
       component.set("v.paginationData",pagelist); 
    }
   });
   $A.enqueueAction(action);
},
    
    /*******************************************************************************************************
     * @description This is the method to handle next page Pagination
    */
  next  : function(component,helper){
      var resourceList = component.get("v.resourceData");
        var searchResourceList = component.get("v.searchResourceList");
      if(searchResourceList.length){//null || searchResourceList.length>0){
          console.log('ghh');
          resourceList = searchResourceList;
      }
             console.log("resourceListNext",resourceList);
      var start  = component.get("v.pageNumber")+1;
      var recordPerPage = component.get("v.pageSize");  
      var i = start * recordPerPage;
      component.set("v.pageNumber",start);
      var listpush =[];
      for(start = i-recordPerPage;start<i;start++){
          if(resourceList[start] )
              listpush.push(resourceList[start]);
          else
              break;
      }
      component.set("v.paginationData",listpush);    
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
      var start  = component.get("v.pageNumber")-1;
      var recordPerPage = component.get("v.pageSize")  
      if(start>=1){
          var i = start * recordPerPage;
          component.set("v.pageNumber",start);
          var listpush =[];
          for(start = i-recordPerPage;start<i;start++){
              if(resourceList[start] )
                  listpush.push(resourceList[start]);
              else
                  break;
          }
          component.set("v.paginationData",listpush);   
      }
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
      var recordPerPage = component.get("v.pageSize");  
      var i = pagenumber * recordPerPage;
      var listpush =[];
      console.log("PageNumber",pagenumber);
      component.set("v.pageNumber",pagenumber);
      for(var start = i-recordPerPage;start<i;start++){
          if(resourceList[start] )
              listpush.push(resourceList[start]);
          else
              break;
      }
      component.set("v.paginationData",listpush);   
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
             var row = event.getParam('row');  
             component.set("v.openNewResourceModal",true);   
             component.set("v.resourceStaffId",row.Id);  
             var childCmp = component.find("childCmp");
             var retnMsg = childCmp.childMethodCalled();           
       }
       
})