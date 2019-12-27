({
	saveWorkingHour : function(component,event,helper) {
		var workHourRecord = component.get('v.workingRecord');
       
        var ResourceId = component.get('v.resourceRecord');
        console.log('workHourRecord==',workHourRecord);
        console.log('ResourceId==',ResourceId.Id);
          var action = component.get("c.saveWorkingHour");
        action.setParams({
            "cqwh" :  workHourRecord,
            "mon" : component.get('v.monday'),
            "tue" : component.get('v.tuesday'),
            "wed" : component.get('v.wednesday'),
            "thur" : component.get('v.thursday'),
            "fri" : component.get('v.friday'),
            "sat" : component.get('v.saturday'),
            "isActive" : component.get('v.isActive'),
            "resId" : ResourceId.Id
        });
      action.setCallback(this,function(response) {
            var state = response.getState();
            console.log("state"+state);
            if (state === "SUCCESS") {
               
            /*  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
               "title": "Success!",
               duration: '5000',
               "message": "Successfully saved the Resource Staff ."
               });
              toastEvent.fire();*/
                component.set('v.monday',false);
                component.set('v.tuesday',false);
                component.set('v.wednesday',false);
                component.set('v.thursday',false);
                component.set('v.friday',false);
                component.set('v.saturday',false);
                component.set('v.isActive',false);
                component.set("v.isModelOpen",false);
                var refreshEvent = component.getEvent("refreshEvent");
                refreshEvent.fire();             
            }
          else{
              var errors = response.getError();                      
                            console.log("error",errors[0].message);

               /*  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                title : 'Error Message',
                type : 'error',
                duration: '5000',
               "message": "Error in saving the Resource Staff ."
               });
              toastEvent.fire();*/
          }
        });
       $A.enqueueAction(action);
	}
})