({
	  fetchRelatedAppointment : function(component,event,helper){
            component.set('v.relatedAppointmentColumns', [
            {label: 'Appointment Name', fieldName: 'Name', type: 'text'},
            {label: 'Location', fieldName: 'Location', type: 'text'}, 
            {label: 'Service', fieldName: 'Service', type: 'text'},     
            {label: 'ResourceStaff', fieldName: 'ResourceStaff', type: 'text'},     
            {label: 'Start Date	', fieldName: 'StartDate', type: 'text'},     
            {label: 'End Date', fieldName: 'EndDate', type: 'text'},     
            {label: 'Status', fieldName: 'Status', type: 'text'},         
            ]);
        var action = component.get("c.relatedAppointment");
        action.setParams({
            "recordId" :  component.get("v.recordId")       
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
           if(response.getReturnValue() != null){
               var rows = response.getReturnValue();
               component.set("v.relatedAppointment",rows);
           }
            }
            else {
	                console.log('Failed with state: ' + state);
	            }               
        });
        $A.enqueueAction(action);  
      },
     
})