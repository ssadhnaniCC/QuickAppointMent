({
   /*******************************************************************************************************
    @description This method is used to save Resource staff and its alignment  
   */
	saveResourceStaff : function(component,event,helper) {
       var resourceRecord = component.get("v.resourceRecord"); 
        var selectedLocations = component.get("v.selectedLocation");
        var selectedServices = component.get("v.selectedService");
	    var action = component.get("c.saveNewResources");
        action.setParams({
            "resourceObj" :  resourceRecord,
            "selectedLocationList" : selectedLocations,
            "selectedServiceList"  : selectedServices
        });
      action.setCallback(this,function(response) {
            var state = response.getState();
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
                console.log('options##',options);
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
              component.set("v.showSpinner",false);
              var options = [];
                serviceList.forEach(function(Service){
                options.push({ value: Service.CC_QAppt__Service__c, label: Service.CC_QAppt__Service__r.Name ,Id: Service.CC_QAppt__Service__c});
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
                 var options = [];
                resourceservice.resourceServiceList.forEach(function(Service){
                options.push(Service.CC_QAppt__Service__c);
                });
                var options  = options.reduce(function(a,b){if(a.indexOf(b)<0)a.push(b);return a;},[]);
                 var listoptions = [];
                resourceservice.resourceServiceList.forEach(function(Location){                        
                listoptions.push(Location.CC_QAppt__Location__c);
                }); 
                 var listoptions  = listoptions.reduce(function(a,b){if(a.indexOf(b)<0)a.push(b);return a;},[]);  
                 var availableServiceoptions = [];
                resourceservice.availableResourceServiceList.forEach(function(AvailableService){
                availableServiceoptions.push({ value: AvailableService.CC_QAppt__Service__c, label: AvailableService.CC_QAppt__Service__r.Name ,Id: AvailableService.CC_QAppt__Service__c});
                });
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