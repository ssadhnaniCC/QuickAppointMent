({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAppointmentCategory");
        action.setCallback(this, function(response){
        	var state = response.getState();
            if(state === 'SUCCESS'){
            	component.set("v.apppointmentCatList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        component.set("v.showModal", false);
	},
    
    onCategorySelect : function(component, event, helper) {
		component.set("v.showModal", false);
	},
    
    closeModal : function(component, event, helper) {
		component.set("v.showModal", false);
	}
})