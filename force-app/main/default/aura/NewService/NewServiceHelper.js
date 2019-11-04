({
    
     
   /*******************************************************************************************************
    * @description This is the method which will handle save functionality
   */
    
	saveService : function(component, event, helper) {
        
     
		var serRecord = component.get("v.serviceRecord"); 
        console.log('serRecord@@',serRecord);
        var selLocations = component.get("v.selectedLocation");
        console.log('selLocations@@',selLocations);
        debugger;
        var action = component.get('c.saveServiceRecords');
        action.setParams({
            "serRecord":serRecord,
            "locValuesList": selLocations
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                alert('SUCCESS');
                
                 /*  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
               "title": "Success!",
               duration: '5000',
               "message": "Service Record Successfully saved"
               });
              toastEvent.fire();*/
            
                component.set('v.selectedLocation',{});
                component.set('v.serviceId',' ');
                component.set("v.isModalOpen", false);
                var refreshEvent = component.getEvent("refreshEvent");
                console.log(refreshEvent);
                refreshEvent.fire();
            }
        });
        $A.enqueueAction(action);
            
	},
    
     
   /*******************************************************************************************************
    * @description This is the method which will handle all locations
   */
    
    
    fetchAllLocations:function(component,event){
        var action = component.get('c.getAllLocation');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                console.log('response.getReturnValue()Loc',response.getReturnValue());
                var responseData = response.getReturnValue();
                var recArray = [];
              
                responseData.forEach(function(loc){
                    console.log('loc##',loc);
                    recArray.push({ value: loc.Id, label: loc.Name ,Id: loc.Id});
                });
             
                console.log('recArray==',recArray);
                
                component.set('v.options',recArray);
                
            }
        });
        $A.enqueueAction(action);
    },
    
     
   /*******************************************************************************************************
    * @description This is the method which will handle the all selected locations with service
   */
    
    
    fetchSelectedLocations : function(component,event,helper) {
        var action = component.get('c.getSelectedLocations');
        action.setParams({
            'recId' : component.get('v.recId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                alert('locationList');
                console.log('response==',response.getReturnValue());
                var responseData = response.getReturnValue();
                component.set('v.serviceRecord',responseData.serviceRecord);
                
                var tempArray = [];
                
                for(var i=0;i<responseData.locRecord.length;i++) {
                    tempArray.push(responseData.locRecord[i].Id);
                
                    }
                component.set('v.selectedLocation',tempArray);
                
            }
        });
        $A.enqueueAction(action);
    }
    
})