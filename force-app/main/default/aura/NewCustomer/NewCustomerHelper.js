({
    /*******************************************************************************************************
    * @description This method is used to save Customer record in contact where RecordType is 'USER'.
    * @returns void.
    */
	saveCustomer : function(component,event,helper) {		
         var action = component.get("c.saveCustomer");
        action.setParams({
            customerRecord:component.get("v.customerRecord")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert('record inserted');
                 component.set("v.isModalOpen", false);
                var refreshEvent = component.getEvent("refreshEvent");
                console.log(refreshEvent);
                refreshEvent.fire();
               /*var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "message": "The record has been updated successfully."
    });
    toastEvent.fire();   */            
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
    }
})