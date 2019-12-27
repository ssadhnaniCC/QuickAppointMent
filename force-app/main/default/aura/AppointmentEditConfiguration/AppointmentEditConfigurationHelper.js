({
	saveUserPreference : function(component,event,helper,appointmentConfig) {
       var action = component.get("c.saveUserTemplate");
        action.setParams({"appConfig":appointmentConfig});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
              alert("Saved Successfully");
            }
        });
        $A.enqueueAction(action);       	
	}
})