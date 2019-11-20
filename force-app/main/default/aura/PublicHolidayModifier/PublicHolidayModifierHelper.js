({
    getPublicHolidays: function(component, event) {
       console.log(component.get("v.PublicHolidayList"));
        var action = component.get("c.getPublicHolidays");
        action.setParams({
            "locationId": component.get("v.LocationObj").Id
        });
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // if response if success then reset/blank the 'contactList' Attribute 
                // and call the common helper method for create a default Object Data to Contact List 
                // component.set("v.contactList", []);
                // helper.createObjectData(component, event);
                if(response.getReturnValue().length>0){
                     component.set("v.PublicHolidayList",response.getReturnValue());
                     component.set("v.showToast",false);
                }
               
                else
                    component.set("v.showToast",true);
                    
               
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action);
    },
    createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.PublicHolidayList");
        RowItemList.push({            
            'sObjectType':'CC_QAppt__Public_Holidays__c', 
            'Name':'',
            'CC_QAppt__Holiday_Date__c':'',
            'CC_QAppt__Description__c':''
        });
        // set the updated list to attribute (contactList) again    
        component.set("v.PublicHolidayList", RowItemList);
    },
    Save: function(component, event, helper) { 
        console.log(component.get("v.PublicHolidayList"));
        var action = component.get("c.savePublicHolidays");
        action.setParams({
            "reclist": component.get("v.PublicHolidayList")
        });
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                    alert('record Save');
                
              
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action);
    }
    
})