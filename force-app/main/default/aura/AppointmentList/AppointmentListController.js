({
    getRelatedAppointments : function(component,event,helper){
        var params = event.getParam('arguments');
        component.set("v.recordId",params.Id);
        helper.fetchRelatedAppointment(component,event,helper);
    },
})