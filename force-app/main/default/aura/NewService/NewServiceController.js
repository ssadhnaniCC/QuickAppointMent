({
    
    /*******************************************************************************************************
    * @description This is the method which will help in closing model box.
   */
	closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
     
       
   },
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.isModalOpen", false);
   },
    
   /*******************************************************************************************************
    * @description This is the init method which will fetch all the available Locations.
   */
    doInit : function(component,event,helper){
        helper.fetchAllLocations(component,helper);
    },
    
     
   /*******************************************************************************************************
    * @description This is the method which will handle duallistbox change
   */
    
    handleChange: function (cmp, event) {
        // Get the list of the "value" attribute on all the selected options
        var selectedOptionsList = event.getParam("value");
        
        cmp.set('v.selectedLocation',selectedOptionsList);
        
    },
    
     
   /*******************************************************************************************************
    * @description This is the method which will handle validation in all fields
   */
    
    saveRecord : function(component, event, helper) {
         var controlAuraIds = ["ServiceName","Duration","Price","AvailableLocation"];
       //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
           //fetches the component details from the auraId
            var inputCmp = component.find(controlAuraId);
           //displays the error messages associated with field if any
            inputCmp.reportValidity();
           //form will be invalid if any of the field's valid property provides false value.
            return isValidSoFar && inputCmp.checkValidity();
        },true);
        
       if(isAllValid){
          
       helper.saveService(component,event,helper);
     }
            
    },
    
    
     
   /*******************************************************************************************************
    * @description This is the method which will handle selected location 
   */
    
    getSelectedLocation : function(component,event,helper) {
        
        helper.fetchAllLocations(component,event);
        helper.fetchSelectedLocations(component,event,helper);
       
    }
    
})