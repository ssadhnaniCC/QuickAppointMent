({
	openModel: function(component, event, helper) {
     
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
       var refreshEvent = component.getEvent("refreshEvent");
                console.log(refreshEvent);
                refreshEvent.fire();
       
   },
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.isModalOpen", false);
   },
    
     initialize: function (component, event, helper) {
        helper.getLocationData(component, event, helper);
        console.log('recordId=='+component.get('v.recordId'));
         //var data = JSON.stringify(component.get('v.dataToBeSend'));
         //var dataWithParse = JSON.parse(data);
         console.log('data=='+JSON.stringify(component.get('v.dataToBeSend')));
         if(component.get('v.recordId')!=undefined) {
             
         }
         /*if(component.get('v.isEdit')) {
             alert('dsfss');
         }*/
         
    },
    handleChange: function (cmp, event) {
        // Get the list of the "value" attribute on all the selected options
        var selectedOptionsList = event.getParam("value");
        var locArray = [];
        locArray.push(selectedOptionsList);
        console.log('locArray=',locArray);
        cmp.set('v.locValuesList',locArray);
        
    },
    
    saveRecord : function(component, event, helper) {
         var controlAuraIds = ["ServiceName","Duration","Price"];
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
           alert();
       helper.saveServiceRecord(component,event,helper);
     }
            
    },
    
    
    getSelectedLocation : function(component,event,helper) {
        var action = component.get('c.getSelectedLocations');
        action.setParams({
            'recId' : component.get('v.recId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                console.log('response==',response.getReturnValue());
                var selLocation = [];
                for(var i=0;i<response.getReturnValue().length;i++) {
                    selLocation.push(response.getReturnValue()[i].Name);
                
                    }
                component.set('v.values',selLocation);
                //console.log('values@@',component.get('v.values'));
            }
        });
        $A.enqueueAction(action);
    }
    
})