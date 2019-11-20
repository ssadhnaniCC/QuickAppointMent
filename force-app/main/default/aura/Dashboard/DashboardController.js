({
    generateChart : function(component, event, helper) {
        helper.createGraph(component, event, helper);
    },
    doInit : function(component, event, helper){
        component.set('v.appointmentColumns',[
             {label: 'Appointment name', fieldName: 'Name', type: 'text'},
             {label: 'Appointment Time', fieldName: 'StartDate', type: 'text'}
        ]);
        component.set('v.servicesColumns',[
             {label: 'Appointment name', fieldName: 'Name', type: 'text'},
             {label: 'Service name', fieldName: 'ServiceName', type: 'text'},
             {label: 'Appointment Time', fieldName: 'StartDate', type: 'text'}
        ]);
        component.set('v.locationColumns',[
             {label: 'Appointment name', fieldName: 'Name', type: 'text'},
             {label: 'Location name', fieldName: 'LocationName', type: 'text'},
             {label: 'Appointment Time', fieldName: 'StartDate', type: 'text'}
        ]);
        component.set('v.customerColumns',[
             {label: 'Appointment name', fieldName: 'Name', type: 'text'},
             {label: 'Customer name', fieldName: 'CustomerName', type: 'text'},
             {label: 'Appointment Time', fieldName: 'StartDate', type: 'text'}
        ]);
        helper.upcomingAppointment(component, event);
        helper.upcomingAppointmentCustomer(component, event);
    }
})