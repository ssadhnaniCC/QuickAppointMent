({
    /*******************************************************************************************************
    * @description This method fetches the appointment details to show on calendar.
   */
    getResponse : function(component,helper) {
        
        var action = component.get("c.fetchAppointments");
        action.setParams({
            "ObjectName" : component.get("v.objName"),
            "recordId" :  component.get("v.recordId")       
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.RelatedList",result);
                var eventArr = [];
                result.forEach(function(key) {
                    eventArr.push({
                        'Name':key.Name,
                        'id':key.Id,
                        'start':key.startDate,
                        'end':key.endDate,
                        'title':key.Name,
                        'status':key.Status,
                        'backgroundColor': key.eventColor
                    });
                });
             
              //FOR CALENDAR IN RELATED COMPONENTS
              if(component.get("v.recordId")!= null ){
                    component.set("v.isRelated",true);
                    if(eventArr.length){
                        component.set("v.showToast",false);  
                        $('#calendar').fullCalendar('destroy');  
                        $('#calendar').css("display","");  
                      
                        this.loadCalendar(component,eventArr,event,helper,false);    
                    }
                    else{
                        component.set("v.showToast",true);
                        $('#calendar').css("display","none");
                    }
                }
                else
                {
                    $('#calendar').css("display","");
                    $('#calendar').fullCalendar('destroy');                        
                    component.set("v.isRelated",false);
                    this.loadCalendar(component,eventArr,event,helper,true);
                }
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    /*******************************************************************************************************
    * @description This method loads the calendar with week,day,and month view.
   */
    loadCalendar :function(component,data,event,helper,isRelated){
        var m = moment();
         var self = this; 
        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            },
            defaultDate: m.format(),
            eventStartEditable : isRelated,
            editable: true,
            navLinks: true, // can click day/week names to navigate views
            weekNumbersWithinDays: true,
            weekNumberCalculation: 'ISO',
            eventLimit: true,
            timeFormat: 'HH(:mm) a',        
            events:data,    
            eventMouseover: function(data,event,helper) {
                var tooltip = '<div class="tooltipevent slds-popover slds-popover_tooltip slds-popover_medium slds-nubbin_left-top" role="tooltip" style="position:absolute;word-break: break-all;">'
                +'<div class="slds-popover__body">'
                +'<label class="slds-form-element__label" style="color:white;" for="unique-id-of-input">'+'Name:'+data.Name+'<label>'+'<br/>'+'<label style="color:white;" class="slds-form-element__label" for="unique-id-of-input">'+'Status:'+data.status+'<label>'
                +'<br/>'+'<label class="slds-form-element__label" style="color:white;" for="unique-id-of-input">'+'Start:'+data.start.format('MMMM Do YYYY h:mm a')+'<label>' +'<br/>'+'<label class="slds-form-element__label" style="color:white;" for="unique-id-of-input">'
                +'End:'+data.end.format('MMMM Do YYYY h:mm a')+'<label>'
                +'</div>'+ '</div>';
                $("body").append(tooltip);
                $(this).mouseover(function(e) {
                    $(this).css('z-index', 10000);
                    $('.tooltipevent').fadeIn('500');
                    $('.tooltipevent').fadeTo('10', 1.9);
                }).mousemove(function(e) {
                    $('.tooltipevent').css('top', e.pageY + 10 +'px');
                    $('.tooltipevent').css('left', e.pageX + 20 +'px');
                });
            },
            eventMouseout: function(data,event) {
                $(this).css('z-index', 8);
                $('.tooltipevent').remove();
            },
            eventClick : function(calEvent,event,helper) {     
               var appId = calEvent.id;
              component.set("v.editAppointmentId",appId);
              component.set("v.showNewAppointment",true);
              // self.handleEventClickSet(component,helper,true,appId);
            }, 
        });     
        //On Previous Disable Click
        $('.fc-past').addClass('disable');  
        //Adding SLDS Style to buttons
        $('.fc-month-button , .fc-prev-button , .fc-today-button , .fc-agendaWeek-button , .fc-next-button , .fc-agendaDay-button').addClass('slds-button slds-button_neutral custom_button');
        $('.fc-month-button , .fc-prev-button ,  .fc-today-button , .fc-agendaWeek-button , .fc-next-button , .fc-agendaDay-button').removeClass('fc-button fc-state-default fc-corner-left');
        //On Previous button Disable Click
        $('.fc-month-button , .fc-agendaWeek-button , .fc-prev-button , .fc-prev-button').click(function(){helper.disableHandler(helper);});
    },
    disableHandler : function(helper){
        $('.fc-past').addClass('disable'); 
    },  
  /*  handleEventClickSet : function(component,helper,isNewAppointment,appId){
        component.set("v.showNewAppointment",isNewAppointment);
        component.set("v.editAppointmentId",appId);
        console.log("isNewAppointment",component.get("v.showNewAppointment"));
        console.log("appointmentId",component.get("v.editAppointmentId"));
    }*/
})