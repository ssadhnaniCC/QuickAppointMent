({
   /*******************************************************************************************************
    @description This method is used to save Resource staff and its alignment  
   */
	saveResourceStaff : function(component,event,helper) {
        var resourceRecord = component.get("v.resourceRecord"); 
        var selectedLocations = component.get("v.selectedLocation");
        var selectedServices = component.get("v.selectedService");
        if(selectedLocations.length == 1){
            //If array contains [{}] then we have to empty the array
            if (Object.keys(selectedLocations[0]).length == 0){
                selectedLocations = [];
            }
        }
	    var action = component.get("c.saveNewResources");
        action.setParams({
            "resourceObj" :  resourceRecord,
            "selectedLocationList" : selectedLocations,
            "selectedServiceList"  : selectedServices,
            "Price" : component.get("v.resourcePrice")            
        });
      action.setCallback(this,function(response) {
            var state = response.getState();
           // console.log("state"+state);
            if (state === "SUCCESS") {
            /*  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
               "title": "Success!",
               duration: '5000',
               "message": "Successfully saved the Resource Staff ."
               });
              toastEvent.fire();*/
            
               component.set("v.openNewResourceModal",false);
                var refreshEvent = component.getEvent("refreshEvent");
                refreshEvent.fire();             
            }
          else{
              var errors = response.getError();                      
                            console.log("error",errors[0].message);

               /*  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                title : 'Error Message',
                type : 'error',
                duration: '5000',
               "message": "Error in saving the Resource Staff ."
               });
              toastEvent.fire();*/
          }
        });
       $A.enqueueAction(action);
    },
    
   /*******************************************************************************************************
    @description This method is used to fetch available Locations 
    */
    fetchAllAvailableLocations : function(component,event,helper){
    var action = component.get("c.getAllAvailableLocation");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var AvailableLocations = response.getReturnValue();
              var options = [];
                AvailableLocations.forEach(function(Location){
                    options.push({ value: Location.Id, label: Location.Name ,Id: Location.Id});
                });
              component.set("v.availableLocation",options);  
            }
            else {
	                console.log('Failed with state: ' + state);
	            }
        });
        $A.enqueueAction(action);
    },
    
   /*******************************************************************************************************
    @description This method is used to fetch service based on Locations 
    */
    fetchServiceBasedOnLocations : function(component,helper){
            var action = component.get("c.getServicesBasedOnLocation");
                action.setParams({
                    selectedLocationIds : component.get("v.selectedLocation")
                });
            action.setCallback(this,function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                var serviceList = response.getReturnValue();
                 console.log("serviceList"+JSON.stringify(serviceList));
              component.set("v.showSpinner",false);
              var options = [];
                serviceList.forEach(function(Service){
                    console.log("service"+JSON.stringify(Service));
                options.push({value: Service.Id, label: Service.Name ,Id: Service.Id});
                });
               component.set("v.availableService",options);
                 if(component.get("v.availableService").length==0){
                 component.set("v.disableServiceDualLstBox",false);   
                 }
                 else{
                  component.set("v.disableServiceDualLstBox",true);   
                 }
            }
            else {
	                console.log('Failed with state: ' + state);
	            }
        });
        $A.enqueueAction(action);
    },
    
   /*******************************************************************************************************
    @description This method is used to populate New Resource modal with record for edit  
    */
    fetchResources : function(component,helper){
     var action = component.get("c.getResourcesOnEdit");
          action.setParams({
                    selectedResourceId : component.get("v.editresourceRecordId")
                });
          action.setCallback(this,function(response) {
             var state = response.getState();
              if (state === "SUCCESS") {
                  var resourceservice = response.getReturnValue(); 
                  component.set("v.resourceRecord",resourceservice.resContact);
                  component.set("v.resourcePrice",resourceservice.resourceServiceList[0].CC_QAppt__Price__c); 
                  var options = [];
                  resourceservice.selectedService.forEach(function(Service){
                      options.push(Service);
                  });
                  var options  = options.reduce(function(a,b){if(a.indexOf(b)<0)a.push(b);return a;},[]);
                  var listoptions = [];
                  resourceservice.selectedlocation.forEach(function(Location){                        
                      listoptions.push(Location);
                  }); 
                  var listoptions  = listoptions.reduce(function(a,b){if(a.indexOf(b)<0)a.push(b);return a;},[]);  
                  var availableServiceoptions = [];
                  resourceservice.availableServices.forEach(function(AvailableService){
                      availableServiceoptions.push({ value: AvailableService.Id, label: AvailableService.Name ,Id: AvailableService.Id});
                  });
                   availableServiceoptions = availableServiceoptions.reduce(function(a,b){if(a.indexOf(b)<0)a.push(b);return a;},[]);
                  if(availableServiceoptions.length==0){
                      component.set("v.disableServiceDualLstBox",false);   
                  }
                  else{
                      component.set("v.disableServiceDualLstBox",true);
                  }
               component.set("v.availableService",availableServiceoptions);   
               component.set("v.selectedService",options); 
               component.set("v.selectedLocation",listoptions);  
            }
            else {
	                console.log('Failed with state: ' + state);
	            }
        });
        $A.enqueueAction(action);
 
    }
})