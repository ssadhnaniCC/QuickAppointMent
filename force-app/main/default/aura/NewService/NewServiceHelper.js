({
	saveServiceRecord : function(component, event, helper) {
		var data = component.get('v.locationListWithAllRec'); 
        var selData = component.get('v.locValuesList');
      debugger;
        console.log('data==',data);
        
        console.log('selData==',selData[0]);
        var sldt = selData[0];
            
        var selLocations = data.filter(function(dt){ 
            if(sldt.length>0){
        console.log('dsahdasdhasda==',dt);
            for(var i=0;i<sldt.length;i++) {
                if(dt.Name == sldt[i]) {
                    return dt;
                }
            }
                }
            else {
                return null;
            }
        });
        console.log('selLocations==',selLocations);
        var action = component.get('c.saveServiceRecords');
        action.setParams({
            "serRecord":component.get('v.dataToBeSend'),
            "locValuesList": selLocations
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                alert('SUCCESS');
                component.set("v.isModalOpen", false);
                component.set('v.dataToBeSend',"{}");
                //var refreshEvent = component.getEvent("refreshEvent");
                //console.log(refreshEvent);
                //refreshEvent.fire();
            }
        });
        $A.enqueueAction(action);
            
	},
    
    getLocationData:function(component,event){
        var action = component.get('c.getAllLocation');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                console.log('response.getReturnValue()',response.getReturnValue());
                var responseData = response.getReturnValue();
                component.set('v.locationListWithAllRec',responseData);
                var recArray = [];
                for(var i=0;i<responseData.length;i++) {
                    var item = {
                         "label": responseData[i].Name,
                         "value": responseData[i].Name,
                    }
                    recArray.push(item);
                }
                console.log('recArray==',recArray);
                
                component.set('v.options',recArray);
                
            }
        });
        $A.enqueueAction(action);
    }
    
})