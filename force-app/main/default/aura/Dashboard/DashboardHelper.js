({
    /* this function creates all chart
     * used for serevr side calling
     */
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
                if(temp != null)
                helper.createBarChart(component,temp,'monthlyBarChart');
            }
        });
        action1.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                if(temp != null)
                helper.createBarChart(component,temp,'dailyBarChart');
            }
        });
        action2.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                if(temp != null)
                helper.createHorizontalBarChart(component,temp);
            }
        });
        action3.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                if(temp != null)
                helper.createDoughnutChart(component,temp,'categoryDoughnutChart');
            }
        });
        action4.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                if(temp != null)
                helper.createDoughnutChart(component,temp,'customerDoughnutChart');
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
        $A.enqueueAction(action2);
        $A.enqueueAction(action3);
        $A.enqueueAction(action4);
    }, 
    /* this function used for creating daily and monthly bar chart.
     */
    createBarChart : function(component, data,id){
        var dataMap = {"chartLabels": Object.keys(data),
                       "chartData": Object.values(data)
                      };
        var el = component.find(id).getElement();
        console.log('el==',el);
        var ctx = el.getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: "No.of Appointment",
                        backgroundColor: "rgb(48, 145, 241)",
                        data: dataMap.chartData
                    }
                ]
            },
            options: {
                        legend: { display: false },
                        title: {
                            display: true,
                            text: id == "dailyBarChart" ? "Today's Appointment":"Yearly Appointment",
                        }
                    }
        });
    },
    /* this function used for Rating bar chart.
     */
    createHorizontalBarChart : function(component,data){
        var dataMap = {"chartLabels": Object.keys(data),
                       "chartData": Object.values(data)
                      };
        console.log('rating',JSON.stringify(data));
        var action = component.get("c.getAverageRating");
        var result = [];
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                result = response.getReturnValue();
                var el = component.find('ratingBarChart').getElement();	
                var ctx = el.getContext('2d');
                new Chart(ctx, {
                    type: 'horizontalBar',
                    data: {
                        labels: dataMap.chartLabels,
                        datasets: [
                            {
                                label: 'Rating Percent',
                                backgroundColor: ["#009900", "#99cc00","#cccc00","#ccff33","#ff9900"],
                                data: dataMap.chartData
                            }
                        ]
                    },
                    options: {
                        legend: { display: false },
                        title: {
                            display: true,
                            text: result[0] + ' Out of 5  '+ result[1] + ' Customer Ratings',
                        }
                    }
                });
            }
        })
        
        $A.enqueueAction(action);
    },
    /* this function used for creating Doughnut chart.
     */
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
                        label:" ",
                        backgroundColor: ["#3e95cd", "#8e5ea2","#FF5733","#3cba9f","#FF33FC","#e8c3b9","#c45850","#FFDD33","#DAF7A6","#FF9C33"],
                        data: dataMap.chartData
                    }
                ]
            }
        });
    },
    /* this function used for server side calling for getting data of upcoming appointment report.
     */
    upcomingAppointment : function(component,event){
        var action = component.get("c.getUpcomingAppointment");
        console.log('sd');
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                var temp = response.getReturnValue();
                component.set('v.upcomingAppointment',temp);
            }
        });
        $A.enqueueAction(action);
    },
    /* this function used for server side calling for getting data of upcoming appointment report according customer.
     */
    upcomingAppointmentCustomer : function(component,event){
        var action = component.get("c.getUpcomingCustomer");
        console.log('sd');
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                var temp = response.getReturnValue();
                component.set('v.upcomingAppointmentCustomer',temp);
            }
        });
        $A.enqueueAction(action);
    }
})