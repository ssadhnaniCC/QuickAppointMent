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
         var refreshEvent = component.getEvent("refreshEvent");
                console.log(refreshEvent);
                refreshEvent.fire();
    },
    /*******************************************************************************************************
    * @description This method is used to save Customer record in contact where RecordType is 'USER'.
    * @returns void.
    */
     onCustomerSave: function(component,event,helper){
          var controlAuraIds = ["CustomerFirstName","CustomerLastName"];
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
       helper.saveCustomer(component,event,helper);
     }
     }
})