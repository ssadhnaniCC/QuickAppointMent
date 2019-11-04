({
    /*******************************************************************************************************
    * @description This method is used to initialize NewCustomer component.
    * @returns void.
    */
	onInit : function(component, event, helper) {
        component.set("v.AppointmentCategoryRecord",{});
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
         
       helper.saveAppointmentCategory(component,event,helper);
     
     }
})