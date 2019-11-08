({
    /*******************************************************************************************************
    * @description This is the method closed model box .
    */
    handleCloseModal: function(component, event, helper) {
        component.set("v.openModal", false);
    },
    /*******************************************************************************************************
    * @description This is the method save record .
    */
    handleSaveModal : function(component, event, helper) {
        helper.saveLocation(component);
        //this.handleCloseModal(component, event, helper);
    },
})