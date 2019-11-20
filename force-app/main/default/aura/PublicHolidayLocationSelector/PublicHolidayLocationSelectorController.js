({
	init : function(component, event, helper) {
        component.set("v.isModalOpen",true);
		 var action = component.get("c.getLocations");
       // action.setParams({"CustomerId":null});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.locationList",response.getReturnValue());
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
    },
    onValueChange :function(component, event, helper){
        var locationLst = component.get("v.locationList");
        // console.log(component.find("Location").get("v.obj"));
        var Id = component.find("Location").get("v.value");
        for (var i=0; i < locationLst.length; i++) {
        if (locationLst[i].Id == Id) {
            console.log(locationLst[i]);
            component.set("v.LocationObj",locationLst[i]);
        }
    }
var a = locationLst.indexOf(component.find("Location").get("v.value"));
        console.log(a);
    },
    closeModel:function(component, event, helper){
        component.set("v.isModalOpen",false);
    },
    NextClick :function(component, event, helper){
    component.set("v.showPublicHolidayModal",true);
        component.set("v.isModalOpen",false);
    }
	
})