({
    /*******************************************************************************************************
    * @description This method is fired on component initialization.
    * @returns void.
    */
	init : function(component, event, helper) {
       // component.set("v.isModalOpen",true);
		 var action = component.get("c.getLocations");
       // action.setParams({"CustomerId":null});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
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
    /*******************************************************************************************************
    * @description This method is is used to assign selected picklist  value to location object.
    * @returns void.
    */
    onValueChange :function(component, event, helper){
        var locationLst = component.get("v.locationList");       
        var Id = component.find("Location").get("v.value");
        for (var i=0; i < locationLst.length; i++) {
        if (locationLst[i].Id == Id) {
            component.set("v.LocationObj",locationLst[i]);
        }
    }
var a = locationLst.indexOf(component.find("Location").get("v.value"));      
    },
    /*******************************************************************************************************
    * @description This method is used to close.
    * @returns void.
    */
    closeModel:function(component, event, helper){
        component.set("v.showPublicHolidayLocationSelectorModal",false);
    },
    /*******************************************************************************************************
    * @description This method is used show holiday modifier modal.
    * @returns void.
    */
    NextClick :function(component, event, helper){
    component.set("v.showPublicHolidayModal",true);
 
    }
	
})