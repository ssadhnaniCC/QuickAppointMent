({
    /*******************************************************************************************************
    * @description This method is used get column headers of datatable.
    * @returns list of columns name.
    */
    getPublicHolidays: function(component, event) {
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
                    component.set("v.showTable",true);
                     component.set("v.showToast",false);                   
                }               
                else{
                    component.find("save").set("v.disabled",true);
                    component.find("saveClose").set("v.disabled",true);
                     component.set("v.showTable",false);
                     component.set("v.showToast",true);
                }
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action);
    },
    
        /*******************************************************************************************************
    * @description This method is used to add add new object to PublicHolidayList .
    * @returns list of columns name.
    */
    createObjectData: function(component, event) {
        // get the PublicHolidayList from component and add(push) New Object to List  
        if(component.get("v.showTable")==false){
            component.set("v.showTable",true)
            component.find("save").set("v.disabled",false);
            component.find("saveClose").set("v.disabled",false);
        }
        var RowItemList = component.get("v.PublicHolidayList");
        RowItemList.push({            
            'sObjectType':'CC_QAppt__Public_Holidays__c', 
            'Name':'',
            'CC_QAppt__Holiday_Date__c':'',
            'CC_QAppt__Description__c':''
        });
        // set the updated list to attribute (PublicHolidayList) again    
        component.set("v.PublicHolidayList", RowItemList);
    },
    
    /*******************************************************************************************************
    * @description This method is used to save records to database.
    * @returns list of columns name.
    */
    Save: function(component, event, helper) { 
        console.log('PublicHolidayList==',component.get("v.PublicHolidayList"));
        debugger;
        var action = component.get("c.savePublicHolidays");
        action.setParams({
            "reclist": component.get("v.PublicHolidayList")
        });
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action);
    }
    
})