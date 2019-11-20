({
    createGraph : function(component, event, helper) {
        var temp = [];
        var action = component.get("c.getBarChartMonthlyAppointment");
        var action1 = component.get("c.getDailyBarchart");
        var action2 = component.get("c.getRating");
        var action3 = component.get("c.getTopCategory");
        var action4 = component.get("c.getTopCustomer");
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                helper.createBarChart(component,temp,'monthlyBarChart');
            }
        });
        action1.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                helper.createBarChart(component,temp,'dailyBarChart');
            }
        });
        action2.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                console.log(JSON.stringify(temp));
                helper.createHorizontalBarChart(component,temp);
            }
        });
        action3.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                console.log(JSON.stringify(temp));
                helper.createDoughnutChart(component,temp,'categoryDoughnutChart');
            }
        });
        action4.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                 temp = response.getReturnValue();
                console.log(JSON.stringify(temp));
                helper.createDoughnutChart(component,temp,'customerDoughnutChart');
            }
        })
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
        $A.enqueueAction(action2);
        $A.enqueueAction(action3);
        $A.enqueueAction(action4);
    },
    createBarChart : function(component, data,id){
        var dataMap = {"chartLabels": Object.keys(data),
                       "chartData": Object.values(data)
                      };
        var el = component.find(id).getElement();
        var ctx = el.getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: id == "dailyBarChart" ? "Today's Appointment":"Yearly Appointment",
                        backgroundColor: "rgb(48, 145, 241)",
                        data: dataMap.chartData
                    }
                ]
            }
        });
    },
    createHorizontalBarChart : function(component,data){
        var dataMap = {"chartLabels": Object.keys(data),
                       "chartData": Object.values(data)
                      };
        var el = component.find('ratingBarChart').getElement();	
        var ctx = el.getContext('2d');
        new Chart(ctx, {
            type: 'horizontalBar',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: "Rating",
                        backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
                        data: dataMap.chartData
                    }
                ]
            },
            options: {
                legend: { display: false },
                title: {
                    display: true,
                    text: 'Rating'
                }
            }
        });
    },
    createDoughnutChart : function(component,data,id){
        var dataMap = {"chartLabels": Object.keys(data),
                       "chartData": Object.values(data)
                      };
        var el = component.find(id).getElement();
        var ctx = el.getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: id == "categoryDoughnutChart" ? "Top Category":"Top Customer",
                        backgroundColor: ["#3e95cd", "#8e5ea2","#FF5733","#3cba9f","#FF33FC","#e8c3b9","#c45850","#FFDD33","#DAF7A6","#FF9C33"],
                        data: dataMap.chartData
                    }
                ]
            },
            options: {
                title: {
                    display: true,
                    text: 'Top ten Categories'
                }
            }
        });
    },
    upcomingAppointment : function(component,event){
        var action = component.get("c.getUpcomingAppointment");
        console.log('sd');
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
               var temp = response.getReturnValue();
                /*for(var i = 0;i < temp.length; i++){
                    var row = temp[i];
                    if(row.CC_QAppt__Resource_Service_Alignment__r){
                        row.ServiceName = row.CC_QAppt__Resource_Service_Alignment__r.CC_QAppt__Service__r.Name;
                        row.LocationName = row.CC_QAppt__Resource_Service_Alignment__r.CC_QAppt__Location__r.Name;
                    }
                }*/
                component.set('v.upcomingAppointment',temp);
            }
        });
        $A.enqueueAction(action);
    },
    upcomingAppointmentCustomer : function(component,event){
        var action = component.get("c.getUpcomingCustomer");
        console.log('sd');
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
               var temp = response.getReturnValue();
                /*for(var i = 0;i < temp.length; i++){
                    var row = temp[i];
                    if(row.CC_QAppt__Appointment__r){
                        row.AppointmentName = row.CC_QAppt__Appointment__r.Name;
                        row.StartDate = row.CC_QAppt__Appointment__r.CC_QAppt__Start_Date_Time__c;
                    }
                    if(row.CC_QAppt__Participant_Name__r)
                        row.CustomerName = row.CC_QAppt__Participant_Name__r.Name;
                }*/
                component.set('v.upcomingAppointmentCustomer',temp);
                console.log(JSON.stringify(temp));
            }
        });
        $A.enqueueAction(action);
    }
})