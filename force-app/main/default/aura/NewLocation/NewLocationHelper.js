({
    saveLocation : function(component) {
        var action = component.get("c.saveLocation");
        var editLocation = component.get("v.editLocation");
        var controlAuraIds = ["Name","Street"];
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            var inputCmp = component.find(controlAuraId);
            inputCmp.reportValidity();
            return isValidSoFar && inputCmp.checkValidity();
        },true);
        console.log(isAllValid);
        if(isAllValid){
            action.setParams({
                "location" : editLocation
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    console.log('success');
                    component.set("v.openModal", false);
                    var refreshEvent = component.getEvent("refreshEvent");
                    console.log(refreshEvent);
                    refreshEvent.fire();
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire();*/
                }else if(state === "ERROR"){
                    /* toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error in saving Location Record."
                    });
                    toastEvent.fire();*/
            }
            });
            $A.enqueueAction(action);
        }
    }
})