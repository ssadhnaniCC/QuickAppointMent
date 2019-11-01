({
    /*getColumnAndAction : function(component) {
        var actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'View', name: 'view'}
        ];
        
        var columns = component.get('v.columns');
        console.log('columnsbef==',columns);
        columns.push({type: 'action', typeAttributes: { rowActions: actions } } );
        component.set('v.columns',columns);
        console.log('columns==',component.get('v.columns'));
        
    },*/
    
    /*getServiceRecords : function(component, helper) {
        var action = component.get("c.getAllServices");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
         
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log('resultData==',resultData);
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultData.length);
                component.set("v.data", resultData);
                component.set("v.totalRecords", component.get("v.data").length);
                component.set("v.startPage",0);
                component.set("v.endPage",pageSize-1);
                component.set("v.filteredData", resultData);
                
            }
        });
        $A.enqueueAction(action);
    },*/
    
    viewRecord : function(component, event) {
        var row = event.getParam('row');
        var recordId = row.Id;
        var navEvt = $A.get("event.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    
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
    
    editRecord : function(component, event) {
        
        
        var data = component.get('v.data');
        var row = event.getParam('row');
        component.set('v.dataToBeSend',row);
        /*component.set('v.serName',row.Name);
        component.set('v.des',row.CC_QAppt__Description__c);
        component.set('v.price',row.CC_QAppt__Price__c);*/
        
        console.log('row==',row);
        var recordId = row.Id;
        alert(recordId);
        component.set('v.recordId',recordId);
        component.set('v.isEdit',true);
        component.set('v.isModelOpen',true);
        
        //this.getLocationData(component,event);
        var childComponent = component.find("childComp");
        childComponent.getEditMethod();
       
    },    
    
    getServiceRecords : function(component) {
       component.set('v.isSpinner',true);
        var action = component.get('c.getAllServices');
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
              
                console.log('response@@',response.getReturnValue());
                var responseData = response.getReturnValue();
                
                this.getColumnOfServices(component,event,responseData.listOfFieldSets);
                
                if(responseData.listOfServices.length > 0) {
                    component.set('v.data',responseData.listOfServices);
                    var dataLength = component.get('v.data').length;
                    var pageSize = component.get('v.pageSize');
                   component.set("v.totalSize", dataLength);

                    component.set("v.firstPage",0);

                     component.set("v.lastPage",pageSize-1);

                     var paginationList = [];
                    for(var i=0; i< pageSize; i++)
                        
                    {
                        if(responseData.listOfServices[i])
                        paginationList.push(responseData.listOfServices[i]);
                        else{
                            break;
                        }
                        
                    }
                    
                    component.set('v.filteredData', paginationList);
                    console.log('filteredData@',component.get('v.filteredData'));
                    component.set('v.isSpinner',false);
                    component.set('v.hideFooter',true);
                }
                else {
                    var str = 'No Service Found';
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
    
    getColumnOfServices : function(component,event,columnList) {
         var actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'Appointment', name: 'appointment'},
        ];
             
             var colNames = columnList;
             colNames.push({type: 'action', typeAttributes: { rowActions: actions }});
             component.set('v.columns',colNames);
    },
    
    /*
     * Method will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next : function(component, event){
         var searchList = component.get("v.data");
        var searchServiceList = component.get("v.searchList");
      if(searchServiceList.length){//null || searchServiceList.length>0){
          console.log('ghh');
          searchList = searchServiceList;
      }
             console.log("searchServiceList",searchList);
      var start  = component.get("v.pageNumber")+1;
      var recordPerPage = component.get("v.pageSize");  
      var i = start * recordPerPage;
      component.set("v.pageNumber",start);
      var listpush =[];
      for(start = i-recordPerPage;start<i;start++){
          if(searchList[start] )
              listpush.push(searchList[start]);
          else
              break;
      }
      component.set("v.filteredData",listpush); 
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        var searchList = component.get("v.data");
      var searchServiceList = component.get("v.searchList");
        if(searchServiceList.length){
          searchList = searchServiceList;
      }
      var start  = component.get("v.pageNumber")-1;
      var recordPerPage = component.get("v.pageSize")  
      if(start>=1){
          var i = start * recordPerPage;
          component.set("v.pageNumber",start);
          var listpush =[];
          for(start = i-recordPerPage;start<i;start++){
              if(searchList[start] )
                  listpush.push(searchList[start]);
              else
                  break;
          }
          component.set("v.filteredData",listpush);   
      }
    },
    
    startPage : function(component,event,helper) {
        //alert();
        var data = component.get("v.data");
        
        var pageSize = component.get("v.pageSize");
        
        var paginationList = [];
        
        for(var i=0; i< pageSize; i++)
            
        {
            if(data[i])
            paginationList.push(data[i]);
            else {
                break;
            }
                
            
        }
        
        component.set('v.filteredData', paginationList);
    },
    
    lastPage : function(component,event,helper){
        var data = component.get("v.data");
        
        var pageSize = component.get("v.pageSize");
        
        var totalSize = component.get("v.totalSize");
        
        var paginationList = [];
        
        for(var i=totalSize-pageSize+1; i< totalSize; i++)
            
        {
            if(data[i])
            paginationList.push(data[i]);
            
            else {
                break;
            }
            
        }
        
        component.set('v.filteredData', paginationList);
        console.log('filteredData@@',component.get('v.filteredData'));
    },
    
    nextPage : function(component, event, helper)

    {
        
        var data = component.get("v.data");
        
        var end = component.get("v.lastPage");
        
        var start = component.get("v.firstPage");
        
        var pageSize = component.get("v.pageSize");
        
        var paginationList = [];
        
        var counter = 0;
        
        for(var i=end+1; i<end+pageSize+1; i++)
            
        {
            
            if(data.length > end)
                
            {
                if(data[i]) {
                paginationList.push(data[i]);
                    
                counter ++ ;
                }
                 else {
                    break;
                }
                
            }
            
        }
        
        start = start + counter;
        
        end = end + counter;
        
        component.set("v.firstPage",start);
        
        component.set("v.lastPage",end+1);
        
        component.set('v.filteredData', paginationList);

},
    
    previousPage : function(component, event, helper)
    
    {
        
        var data = component.get("v.data");
        
        var end = component.get("v.lastPage");
        
        var start = component.get("v.firstPage");
        
        var pageSize = component.get("v.pageSize");
        
        var paginationList = [];
        
        var counter = 0;
        
        for(var i= start-pageSize; i < start ; i++)
            
        {
            
            if(i > -1)
                
            {
                if(data[i]) {
                paginationList.push(data[i]);
                
                counter ++;
                }
                else {
                    break;
                }
                
            }
            
            else {
                
                start++;
                
            }
            
        }
        
        start = start - counter;
        
        end = end - counter;
        
        component.set("v.firstPage",start);
        
        component.set("v.lastPage",end);
        
        component.set('v.filteredData', paginationList);

},

    handleFirstLast : function(component,event,helper,pagenumber){
        debugger;
       var resourceList = component.get("v.data");
      var searchResourceList = component.get("v.searchList");
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
      component.set("v.filteredData",listpush);   
        
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.filteredData");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.filteredData", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    firstPage : function(component, event){
        var sObjectList = component.get("v.data");
        console.log('data==',component.get('v.data'));
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        console.log('pageSize==',pageSize);
        var Paginationlist = [];
        
        for(var i=1; i<=pageSize; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.filteredData', Paginationlist);
        console.log('filteredData==',component.get('v.filteredData'));
    },
    
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
            allRecords = component.get("v.data");
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
        component.set("v.filteredData", tempArray);
    },
    
    getLocationData:function(component,event){
        var action = component.get('c.getAllLocation');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                console.log('response.getReturnValue()',response.getReturnValue());
                var responseData = response.getReturnValue();
                component.set('v.locationListWithAllRec',responseData);
                var recArray = [];
                for(var i=0;i<responseData.length;i++) {
                    var item = {
                         "label": responseData[i].Name,
                         "value": responseData[i].Name,
                    }
                    recArray.push(item);
                }
                console.log('recArray==',recArray);
                
                component.set('v.locationList',recArray);
                
            }
        });
        $A.enqueueAction(action);
    }
    
})