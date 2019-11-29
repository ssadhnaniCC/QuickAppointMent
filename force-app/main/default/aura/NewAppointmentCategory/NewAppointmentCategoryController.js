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
        /* var refreshEvent = component.getEvent("refreshEvent");
                console.log(refreshEvent);
                refreshEvent.fire();*/
        component.set("v.AppointmentCategoryRecord",{});
    },
    /*******************************************************************************************************
    * @description This method is used to save Customer record in contact where RecordType is 'USER'.
    * @returns void.
    */
     onCategorySave: function(component,event,helper){
         
       helper.saveAppointmentCategory(component,event,helper);
         
     
     },
    
    onLocationCheckBoxChange : function(component, event, helper) {   
    var checkBoxReference=component.get("v.AppointmentCategoryRecord.CC_QAppt__IsLocationMandatory__c");      
        var value=component.find("multipleLocation");      
    if(checkBoxReference){
    value.set("v.disabled",false);
}
 else{
      value.set("v.checked",false);
    value.set("v.disabled",true);
}
},
 onServiceCheckBoxChange : function(component, event, helper) {
    var checkBoxReference=component.get("v.AppointmentCategoryRecord.CC_QAppt__IsServiceMandatory__c");      
        var value=component.find("multipleService");      
    if(checkBoxReference){
    value.set("v.disabled",false);
}
 else{
      value.set("v.checked",false);
    value.set("v.disabled",true);
}
},
    onAttendeeCheckBoxChange : function(component, event, helper) {
    var checkBoxReference=component.get("v.AppointmentCategoryRecord.CC_QAppt__IsAttendeeMandatory__c");      
        var value=component.find("multipleAttendee");      
    if(checkBoxReference){
    value.set("v.disabled",false);
}
 else{
      value.set("v.checked",false);
    value.set("v.disabled",true);
}
},
    onAssetCheckBoxChange : function(component, event, helper) {
    var checkBoxReference=component.get("v.AppointmentCategoryRecord.CC_QAppt__IsAssetMandatory__c");      
        var value=component.find("multipleAsset");      
    if(checkBoxReference){
    value.set("v.disabled",false);
}
 else{
     value.set("v.checked",false);
    value.set("v.disabled",true);
}
},
    onResourceCheckBoxChange : function(component, event, helper) {
    var checkBoxReference=component.get("v.AppointmentCategoryRecord.CC_QAppt__IsResourceMandatory__c");      
        var value=component.find("multipleResource");      
    if(checkBoxReference){
    value.set("v.disabled",false);
}
 else{
      value.set("v.checked",false);
    value.set("v.disabled",true);
}
},
    getRecord : function(component, event, helper){
        var param1;
         var params = event.getParam('arguments');
            if (params) {
             param1 = params.recordId;
        }
       var action = component.get("c.getAppointmentCategories");                       
        action.setParams({
            'appointmentCategoryId':param1
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {                         
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully."
                });
                toastEvent.fire();              
               */
                //component.set("v.pageNumber",1);
                //this.getCategories(component,helper);                            
                var recdetails=response.getReturnValue()[0];
                Object.keys(recdetails).forEach((key,index)=>{                    
                    switch(key) {
  case 'CC_QAppt__IsAssetMandatory__c':                   
    helper.hideOrShowCheckbox(component, event, helper,'multipleAsset',recdetails[key]);
    break;
  case 'CC_QAppt__IsAttendeeMandatory__c':
    // code block
     helper.hideOrShowCheckbox(component, event, helper,'multipleAttendee',recdetails[key]);
    break;

    case 'CC_QAppt__IsResourceMandatory__c':
                    // code block
                    helper.hideOrShowCheckbox(component, event, helper,'multipleResource',recdetails[key]);
    break;
                    case 'CC_QAppt__IsLocationMandatory__c':
                    // code block
                    helper.hideOrShowCheckbox(component, event, helper,'multipleLocation',recdetails[key]);
    break;                  
                    case 'CC_QAppt__IsServiceMandatory__c':
                    // code block
                  helper.hideOrShowCheckbox(component, event, helper,'multipleService',recdetails[key]);
    break;
                                                                           
  default:
    // code block
     return;
}
                    
               
                for(var i=0;i<recdetails.length;i++){
                   
                  //  hideOrShowCheckbox(component, event, helper,recdetails)
                }              
                component.set("v.AppointmentCategoryRecord",response.getReturnValue()[0]);
            });
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
    
})