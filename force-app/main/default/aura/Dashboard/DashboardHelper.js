({
	createGraph : function(component, event, helper) {
        var temp = [];
        var action = component.get("c.getBarChartMonthlyAppointment");
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                temp = response.getReturnValue();
                helper.createBarChart(component,temp);
            }
        });
         $A.enqueueAction(action);
	},
    createBarChart : function(component, data){
        var dataMap = {"chartLabels": Object.keys(data),
                       "chartData": Object.values(data)
                      };
        var el = component.find('barChart').getElement();
        var ctx = el.getContext('2d');
         new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: "My Data",
                        backgroundColor: "rgba(153,255,51,0.4)",
                        data: dataMap.chartData
                    }
                ]
            }
        });
    }
})