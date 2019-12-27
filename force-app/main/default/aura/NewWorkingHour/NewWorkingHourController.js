({
	doInit : function(component, event, helper){
        
    },
    
    saveWorkingHourRecord : function(component,event,helper) {
         var controlAuraIds = ["StartTime","EndTime"];
         let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
           //fetches the component details from the auraId
            var inputCmp = component.find(controlAuraId);
           //displays the error messages associated with field if any
            inputCmp.reportValidity();
           //form will be invalid if any of the field's valid property provides false value.
            return isValidSoFar && inputCmp.checkValidity();
        },true);
      if(isAllValid){
        helper.saveWorkingHour(component,event,helper);
      }
    },
    
    
    closeModel : function(component,event,helper){
        component.set('v.isModelOpen',false);
        component.set('v.workingRecord',{});
        component.set('v.monday',false);
        component.set('v.tuesday',false);
        component.set('v.wednesday',false);
        component.set('v.thursday',false);
        component.set('v.friday',false);
        component.set('v.saturday',false);
        component.set('v.isActive',false);
    },
    
    onchangeMonday : function(component,event,helper){
        var monVal = component.find('monId').get('v.checked');
        console.log('Monday@@',component.get('v.monday'));
        component.set('v.monday',monVal);
        console.log('Monday==',monVal);
        console.log('Monday@@',component.get('v.monday'));
        
    },
    
    onchangeTuesday : function(component,event,helper){
        var tueVal = component.find('monId').get('v.checked');
        component.set('v.tuesday',monVal);
        console.log('tuesday==',monVal);
        
    },
    onchangeWednesday : function(component,event,helper){
        var wedVal = component.find('monId').get('v.checked');
        component.set('v.wednesday',monVal);
        console.log('CC_QAppt__IsAvailableOnMonday__c',monVal);
        
    },
    onchangeThursday : function(component,event,helper){
        var thurVal = component.find('monId').get('v.checked');
        component.set('v.thursday',monVal);
        console.log('CC_QAppt__IsAvailableOnMonday__c',monVal);
        
    },
    onchangeFriday : function(component,event,helper){
        var friVal = component.find('monId').get('v.checked');
        component.set('v.friday',monVal);
        console.log('CC_QAppt__IsAvailableOnMonday__c',monVal);
        
    },
    onchangeSaturday : function(component,event,helper){
        var satVal = component.find('monId').get('v.checked');
        component.set('v.saturday',monVal);
        console.log('CC_QAppt__IsAvailableOnMonday__c',monVal);
        
    },
    
})