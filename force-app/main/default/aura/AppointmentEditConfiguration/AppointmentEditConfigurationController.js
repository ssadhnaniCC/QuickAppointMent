({
	doInit : function(component, event, helper) {
     if(component.get("v.appointmentId") == null || component.get("v.appointmentId") == ''){
            var action = component.get("c.getAppointmentCategory");
            action.setParams({
                isPublic : component.get("v.isPublic")
            });  
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    component.set("v.appointmentCatList", response.getReturnValue());
                }else if(state === 'ERROR'){
                }
            });
            $A.enqueueAction(action);
        }    	
	},
    onCategorySelect : function(component,event,helper){
        var appointmentCategoryList = component.get("v.appointmentCatList");
        var Id = component.find("CategoryId").get("v.value");
        
        //This Id is set in case of new appointment category select
        if(Id != null || Id != ''){
            for (var i=0; i < appointmentCategoryList.length; i++) {
                if (appointmentCategoryList[i].Id == Id) {
                    component.set("v.selectedAppointmentCategory",appointmentCategoryList[i]);
                }                
            }   
        }
        console.log("selectedAppointmentCategory"+JSON.stringify(component.get("v.selectedAppointmentCategory")));
        if(component.get("v.selectedAppointmentCategory")){
           var selectedCategory = component.get("v.selectedAppointmentCategory");
           component.set("v.isResourceMultipleSelect",selectedCategory.CC_QAppt__IsMultipleResource__c);
           component.set("v.isAssetMultipleSelect",selectedCategory.CC_QAppt__IsMultipleAsset__c);
  
        }

    },
    recordBoxdrag : function(component,event,helper){
        $("#outerDiv,#section1,#section2,#section3,#section4").sortable({
            connectWith: "#outerDiv,#section1,#section2,#section3,#section4",
            start: function (event, ui) {
                ui.item.toggleClass("highlight");
            },
            stop: function (event, ui) {
                ui.item.toggleClass("highlight");
            },
            receive : function (event, ui) {  
              if($(this).children('div').length > 2){
                  $(this).css({"border":"5px solid gray"});  
                 ui.sender.sortable("cancel");  
               }
            }
        });
        $("#outerDiv,#section1,#section2,#section3,#section4").disableSelection();
        $("#div2").css({'height':'700px'});
        $("#section1,#section2,#section3,#section4").droppable({
            accept: ".dragSection,.inside-drag",
            out : function(event,ui){
                  $(this).css({"border":"5px solid gray"});  
            },
            over: function(event,ui){
              //  console.log($(this).attr('id'));
                if($(this).children('div').length > 2){
                    $(this).css({"border":"5px solid red"});  
                }
                var draggableId  = $(ui.draggable).attr('id');
                var containsMultipleList ;
                if($(this).find('div#multipleresource').length !== 0 || $(this).find('div#multipleasset').length !== 0 ){
                  containsMultipleList = true; 
                }
                if(draggableId=='multipleresource' || draggableId=='multipleasset'){
                    $(this).css({"height":"350px"});  
                }
                else if(containsMultipleList) {
                    $(this).css({"height":"350px"});   
                }
                else{
                    $(this).css({"height":"100px"});       
                  }
            },
            drop: function( event, ui ) {
                $(this).addClass( "ui-state-highlight");
                ui.draggable.css("background-color","rgb(255, 255, 255)");
            }        
        });           
    },
    submit : function(component,event,helper){
        var jsonarr = [];
        $('#div2').children('div').each(function(index,item){
            var jsonobj = {};
            var fields= [];
            jsonobj['sectionname'] = $(item).attr('id');
            $(item).children('div').each(function(ind,items){
                var fieldObj = {};
                fieldObj['fieldName']=$(items).attr('id');
                fieldObj['sortOrder'] = ind;
                fieldObj['datatype'] = $(items).attr('data-datatype');
                fields.push(fieldObj);
            });
            jsonobj['fields'] = fields;
            jsonarr.push(jsonobj);
        });
        console.log('arr'+JSON.stringify(jsonarr));
        
        helper.saveUserPreference(component,event,helper,JSON.stringify(jsonarr));
    },
    cloneSection : function(component,event,helper){
        var selectedRowIndex = parseInt(event.target.dataset.index);
        var idOfSection = selectedRowIndex+1;
        var section = component.get("v.sectionCount");
        var size =    section.length+1;
        var sectionId = '#section'+idOfSection ; 
        var arr = [];
        section.forEach(function(f){
          arr.push(f) ; 
        });
        arr.push(size);
        component.set("v.sectionCount",arr);
    },
    removeSection : function(component,event,helper){
        var selectedRowIndex = parseInt(event.target.dataset.index);
        console.log('item'+selectedRowIndex);
        var idOfSection = selectedRowIndex;
        var sectionId = '#section'+idOfSection ; 
        var AllRowsList = component.get("v.sectionCount");
        $(sectionId).children('div').each(function(index,item){
            $('#outerDiv').append($(item));
        });
        if(AllRowsList.length > 1){
          AllRowsList.splice(selectedRowIndex, 1);    
        }
        console.log('sectionId'+sectionId);
       
       component.set("v.sectionCount", AllRowsList);
    }
    

})