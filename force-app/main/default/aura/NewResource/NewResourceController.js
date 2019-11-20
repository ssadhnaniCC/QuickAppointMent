({
   /*******************************************************************************************************
    * @description This is the init method which will fetch all the available Locations.
   */
    doInit : function(component,event,helper){
        helper.fetchAllAvailableLocations(component,helper);
    },
    /*******************************************************************************************************
    * @description This method closes the Modal.
   */
	closeNewResourceModel : function(component, event, helper) {
		component.set("v.openNewResourceModal",false);
        component.set('v.selectedLocation',{});
	},
    
    /*******************************************************************************************************
    * @description This method checks for required field validation and calls the helper to save resource .
   */
    saveNewResource : function(component,event,helper){
        var controlAuraIds = ["ResourceName","AvailableLocation"];
         let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
           //fetches the component details from the auraId
            var inputCmp = component.find(controlAuraId);
           //displays the error messages associated with field if any
            inputCmp.reportValidity();
           //form will be invalid if any of the field's valid property provides false value.
            return isValidSoFar && inputCmp.checkValidity();
        },true);
      if(isAllValid){
        helper.saveResourceStaff(component,event,helper);
      }
     },
    
   /*******************************************************************************************************
    * @description This method fetch services based on Location .
   */
    handleOnLocationSelect : function(component,event,helper){
        
       var selectedLocationList = event.getParam("value");
        component.set("v.selectedLocation",selectedLocationList);
        component.set("v.showSpinner",true);
        helper.fetchServiceBasedOnLocations(component,helper);
    },
   /*******************************************************************************************************
    * @description This method fills the selectedservices in duallistbox .
   */
    handleOnServiceSelect : function(component,event,helper){
       var selectedServiceList = event.getParam("value");
        console.log('selectedServiceList@@',selectedServiceList);
       component.set("v.selectedService",selectedServiceList);
    },
   /*******************************************************************************************************
    * @description This method is called by parent to refresh list.
   */
    callAction : function(component,event,helper){
     helper.fetchAllAvailableLocations(component,helper);    
     helper.fetchResources(component,helper);
    }
})