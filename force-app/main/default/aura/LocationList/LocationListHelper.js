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
                var pageSize = component.get("v.pageSize");
                if(resultData != null){
                    component.set("v.dataList",resultData);
                    component.set("v.paginationList",resultData);
                    component.set("v.dataSize",resultData.length);
                    var pagecount= Math.ceil((resultData.length)/10);
                    component.set("v.totalPages",pagecount);
                    
                    this.pagination(component,0,pageSize,resultData);
                    
                    component.set("v.pageNumber",1);
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
            {label: 'Delete', name: 'delete'}
        ];
        var action = component.get("c.getLocationFieldSet");
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                var resourceData = response.getReturnValue();
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
        var locationList = component.get("v.dataList");
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
        component.set("v.paginationList",tmpList); 
        
        this.pagination(component,0,pageSize,tmpList);
        
        var pagecount= Math.ceil((tmpList.length)/10);
        component.set("v.totalPages",pagecount);
        component.set("v.pageNumber",1);
    },
    /*******************************************************************************************************
     * @description This method contain logic of next button of pagination
    */
    next : function(component,helper){
        var resourceList = component.get("v.paginationList");
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
        var resourceList = component.get("v.paginationList");
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
        var resourceList = component.get("v.paginationList");
        var recordPerPage = component.get("v.pageSize")
        component.set("v.pageNumber",1);
        var size = 1 * recordPerPage;
        
        this.pagination(component,0,size,resourceList);
    },
    /*******************************************************************************************************
     * @description This method contain logic of last button of pagination
    */
    last : function(component,helper){
        var resourceList = component.get("v.paginationList");
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
        component.set("v.locationList",pagelist);
    }
})