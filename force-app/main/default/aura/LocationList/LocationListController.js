({
	handleNew : function(component, event, helper) {
		component.set("v.newLocationModel",true);
        component.set("v.editRow",{});
	},
    doInit : function(component, event, helper) {      
        component.set("v.spinerLoaded","True");
        helper.getColumnAndAction(component);
        helper.getLocation(component, helper);
    },
    SearchByAddress : function(component, event, helper) {
        var keyword = event.getSource().get("v.value").toUpperCase();
        helper.getByAddress(component,keyword);
    },
    handleNext : function(component,event,helper){
                helper.next(component,helper);      
      },
    handlePrevious : function(component,event,helper){
                helper.previous(component,helper);      
      },
    handleStart : function(component,event,helper){
                helper.start(component,helper);      
      },
    handleLast : function(component,event,helper){
                helper.last(component,helper);      
      },
    refreshList : function(component,event,helper){
        console.log('event fired');
        helper.getLocation(component, helper);
    },
    handleRowAction : function(component,event,helper){
        var action = event.getParam('action');
        alert(action.name);
        switch (action.name) {
            case 'edit':
                helper.editRecord(component, event);
                break;
            case 'delete':
                helper.deleteRecord(component, event);
                break;
        }
    }
})