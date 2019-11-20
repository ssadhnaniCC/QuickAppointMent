({
    /*******************************************************************************************************
    * @description This method is used to initialize NewCustomer component.
    * @returns void.
    */
    onInit : function(component, event, helper) {
        component.set("v.customerRecord",{});
    },
    /*******************************************************************************************************
    * @description This method is used to close ModalBox.
    * @returns void.
    */
    closeModel:function (component, event, helper) {     
        component.set("v.isModalOpen",false);      
        component.set("v.customerRecord",{});
    },
    /*******************************************************************************************************
    * @description This method is used to save Customer record in contact where RecordType is 'USER'.
    * @returns void.
    */
    onHolidaySave: function(component,event,helper){
        var controlAuraIds = ["holidayName","holidayLocation","holidayDate"];
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
            helper.saveHoliday(component,event,helper);
        }
    },
    getRecord : function(component, event, helper){
        var param1;
        var params = event.getParam('arguments');
        if (params) {
            param1 = params.recordId;
        }
        var action = component.get("c.getCustomers");       
        //var rowId=event.getParam('row').Id;              
        action.setParams({
            "recordId":param1
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                // alert('record deleted');                         
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully."
                });
                toastEvent.fire();              
               */
                //component.set("v.pageNumber",1);
                //this.getCategories(component,helper);               
                component.set("v.customerRecord",response.getReturnValue()[0]);
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