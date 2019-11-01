({
	handleCloseModal: function(component, event, helper) {
        component.set("v.openModal", false);
    },
    handleSaveModal : function(component, event, helper) {
        helper.saveLocation(component);
        //this.handleCloseModal(component, event, helper);
    },
})