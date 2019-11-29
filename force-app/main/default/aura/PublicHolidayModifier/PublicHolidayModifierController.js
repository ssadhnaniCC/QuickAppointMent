({
    /*******************************************************************************************************
    * @description This method is fired on component initialization.
    * @returns void.
    */
    doInit : function(component, event, helper) {
        
        helper.getPublicHolidays(component, event);
        
    },
    
    /*******************************************************************************************************
    * @description This method is fired to close model.
    * @returns void.
    */
    closeModel : function(component, event, helper){
        component.set("v.showHolidayLocationSelectorModal",true);
        component.set("v.showHolidayModal",false);      
        console.log('chk',component.get("v.showHolidayLocationSelectorModal")); 
    },
    /*******************************************************************************************************
    * @description This method is used to add row to slds table.
    * @returns void
    */
    addRow:function(component, event, helper){
        helper.createObjectData(component, event);
    }, 
    /*******************************************************************************************************
    * @description This method is used to delete row from slds table.
    * @returns void.
    */
    deleteRow:function(component, event, helper) {
        var index=event.target.id;
        var listToDelete=[];
        var AllRowsList = component.get("v.PublicHolidayList");
        if(AllRowsList[index].Id!=null){
            listToDelete.push(AllRowsList[index].Id);
        }
        AllRowsList.splice(index, 1);   
        component.set("v.PublicHolidayList", AllRowsList);
        if(listToDelete.length>0){
            var action = component.get("c.deletePublicHoliday");
            action.setParams({
                "recList": listToDelete
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
        helper.getPublicHolidays(component, event);
    },
    /*******************************************************************************************************
    * @description This method save the public holiday record to database.
    * @returns void.
    */
    onSave :function(component,event,helper) {  
        var controlAuraIds = ["HolidayName","HolidayDate"];
        var holidayList=component.get("v.PublicHolidayList");
        
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){           
            
            var inputCmp = component.find(controlAuraId);
            
            if(inputCmp.length>0){
                var arr = [];
                for(var j=0;j<inputCmp.length;j++){    
                    if(j==(inputCmp.length)-1 && inputCmp[j].reportValidity() && inputCmp[j].checkValidity())
                        return isValidSoFar && inputCmp[j].checkValidity();
                    else if(inputCmp[j].reportValidity() && inputCmp[j].checkValidity());      
                    continue;               
                }
            }
            else{
                inputCmp.reportValidity();            
                return isValidSoFar && inputCmp.checkValidity();
            }           
        },true);              
        if(isAllValid){            
            for(var i=0 ;i<holidayList.length;i++){
                /*if($A.util.isEmpty(holidayList[i].Name)||$A.util.isEmpty(holidayList[i].CC_QAppt__Holiday_Date__c)){
                    holidayList.splice(i, 1);  
                    continue;
                }*/
                holidayList[i].CC_QAppt__Location__c=component.get("v.LocationObj").Id;            
            }
            component.set("v.PublicHolidayList",holidayList);
            helper.Save(component,event,helper);
            helper.getPublicHolidays(component, event);
        }
    }
    ,
    /*******************************************************************************************************
    * @description This method save the public holiday record to database and close model.
    * @returns void.
    */
    OnSaveClose : function(component, event, helper) { 
        var controlAuraIds = ["HolidayName","HolidayDate"];
        var holidayList=component.get("v.PublicHolidayList");
        
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){           
            
            var inputCmp = component.find(controlAuraId);
            
            if(inputCmp.length>0){
                var arr = [];
                for(var j=0;j<inputCmp.length;j++){    
                    if(j==(inputCmp.length)-1 && inputCmp[j].reportValidity() && inputCmp[j].checkValidity())
                        return isValidSoFar && inputCmp[j].checkValidity();
                    else if(inputCmp[j].reportValidity() && inputCmp[j].checkValidity());      
                    continue;               
                }
            }
            else{
                inputCmp.reportValidity();            
                return isValidSoFar && inputCmp.checkValidity();
            }           
        },true);              
        if(isAllValid){            
            for(var i=0 ;i<holidayList.length;i++){
                /*if($A.util.isEmpty(holidayList[i].Name)||$A.util.isEmpty(holidayList[i].CC_QAppt__Holiday_Date__c)){
                    holidayList.splice(i, 1);  
                    continue;
                }*/
                holidayList[i].CC_QAppt__Location__c=component.get("v.LocationObj").Id;            
            }
            component.set("v.PublicHolidayList",holidayList);
            helper.Save(component, event, helper);
            
        }
        component.set("v.showHolidayModal",false);
        /*var holidayList=component.get("v.PublicHolidayList");
        for(var i=0 ;i<holidayList.length;i++){
           /* if($A.util.isEmpty(holidayList[i].Name)||$A.util.isEmpty(holidayList[i].CC_QAppt__Holiday_Date__c)){
                holidayList.splice(i, 1);  
                continue;
            }
            holidayList[i].CC_QAppt__Location__c=component.get("v.LocationObj").Id;            
        }
        component.set("v.PublicHolidayList",holidayList);
        helper.Save(component, event, helper);
        component.set("v.showHolidayModal",false);*/
    }
    
})