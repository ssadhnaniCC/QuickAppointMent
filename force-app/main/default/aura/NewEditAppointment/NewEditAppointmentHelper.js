({
    /*******************************************************************************************************
    * @description This is the method which will handle which list should be displayed on basis of appointment category selection
   */         
    handleOnCategorySelect : function(component,event,helper,selectedCategory,mandatoryObj,methodName) {     
        var action = component.get(methodName);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.isLocationManditory",selectedCategory.CC_QAppt__IsLocationMandatory__c);
                component.set("v.isLocationMultipleSelect",selectedCategory.CC_QAppt__IsMultipleLocation__c);
                
                component.set("v.isServiceManditory",selectedCategory.CC_QAppt__IsServiceMandatory__c);
                component.set("v.isServiceMultipleSelect",selectedCategory.CC_QAppt__IsMultipleService__c);
                
                component.set("v.isResourceManditory",selectedCategory.CC_QAppt__IsResourceMandatory__c);
                component.set("v.isResourceMultipleSelect",selectedCategory.CC_QAppt__IsMultipleResource__c);
              //  component.set("v.isPricingApplicable",selectedCategory.CC_QAppt__IsPricingApplicable__c);
                
                if(mandatoryObj == 'Location'){
                    var AvailableLocations = response.getReturnValue();
                    var options = [];
                    AvailableLocations.forEach(function(Location){
                        options.push({ value: Location.Id, label: Location.Name ,Id: Location.Id , Name:Location.Name});
                    });
                    component.set("v.availableLocationList",options);
                }
                if(mandatoryObj == 'Service'){
                    var AvailableServices = response.getReturnValue();
                    var options = [];
                    AvailableServices.forEach(function(Service){
                        options.push({ value: Service.Id, label: Service.Name ,Id: Service.Id , Name:Service.Name ,price: Service.CC_QAppt__Price__c});
                    });
                    component.set("v.availableServiceList",options);
                }
                if(mandatoryObj == 'Resource'){
                    var resourceList = response.getReturnValue();
                    var options = [];
                    /* AvailableResources.forEach(function(Resource){
                        options.push({ value: Resource.Id, label: Resource.Name ,Id: Resource.Id , Name:Resource.Name});
                    });*/
                  for(var key in resourceList){
                    options.push({value: resourceList[key].CC_QAppt__Resource_Staff__c ,label:resourceList[key].CC_QAppt__Resource_Staff__r.Name, Name:resourceList[key].CC_QAppt__Resource_Staff__r.Name,value: resourceList[key].CC_QAppt__Resource_Staff__c , Id:resourceList[key].CC_QAppt__Resource_Staff__c , Price: resourceList[key].CC_QAppt__Price__c }); 
                   }
                    component.set("v.availableResourceList",options);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
   /*******************************************************************************************************
    * @description This is the method which will load status from appointment status field picklist
   */         
    fetchStatusOfAppointment : function(component,event,helper){
        var action = component.get('c.fetchStatusOfAppointment');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var statuses = response.getReturnValue();
                statuses.forEach(function(status){
                    if(status == 'Upcoming')
                    {                           
                    component.set("v.statusList",status);
                    component.set("v.selectedStatus",status);    
                    }
                })
            }
        });
        $A.enqueueAction(action);      
    },
    
    
   /*******************************************************************************************************
    * @description This is the method which will fetch Attendee List
   */         
    fetchAttendeeList :  function(component,event,helper,selectedCategory){
        var action = component.get('c.getAttendee');
        action.setParams({ 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.isAttendeeManditory",true);
                component.set("v.isAttendeeMultipleSelect",selectedCategory.CC_QAppt__IsMultipleAttendee__c);
                var  AttendeeList = response.getReturnValue();
                var options = [];
                AttendeeList.forEach(function(attendee){
                    options.push({value: attendee.Id , Id : attendee.Id , label: attendee.Name , Name : attendee.Name});
                });
                component.set("v.availableAttendeeList",options);
            }
        });
        $A.enqueueAction(action);     
        
    },
    
   /*******************************************************************************************************
    * @description This is the method which will fetch Asset List
   */         
    fetchAssetList :  function(component,event,helper,selectedCategory){
        var action = component.get('c.getAsset');
        action.setParams({ 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.isAssetManditory",true);
                component.set("v.isAssetMultipleSelect",selectedCategory.CC_QAppt__IsMultipleAsset__c);
                var AssetList =     response.getReturnValue();
                var options = [];
                AssetList.forEach(function(asset){
                   console.log("asset@@@@@"+JSON.stringify(asset));
                    options.push({value:asset.Id , Id: asset.Id , label: asset.Name , Name : asset.Name ,Price:asset.CC_QAppt__Price__c});
                });
             //   console.log("options@@@"+JSON.stringify(options));
                component.set("v.availableAssetList",options);
            }
        });
        $A.enqueueAction(action);     
        
    },
    /*******************************************************************************************************
    @description This method is used to fetch service based on Locations 
    */
    fetchServiceBasedOnLocations : function(component,event,helper){
        var action = component.get("c.getDependentServices");
        action.setParams({
            selectedLocationIds : component.get("v.selectedLocation")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var serviceList = response.getReturnValue();
                var options = [];
                serviceList.forEach(function(Service){
                console.log("Service"+JSON.stringify(Service));
                    options.push({ value: Service.CC_QAppt__Service__c, Name: Service.CC_QAppt__Service__r.Name,LocationService:Service.Id, label: Service.CC_QAppt__Service__r.Name ,Id: Service.CC_QAppt__Service__c , price: Service.CC_QAppt__Service__r.CC_QAppt__Price__c ,LocationService: Service.Id , LocationId: Service.CC_QAppt__Location__c});
                });
             component.set("v.availableServiceList",options);
            }
            else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*******************************************************************************************************
    @description This method is used to fetch service based on Locations 
    */
    fetchResourceBasedOnService : function(component,event,helper){
        var action = component.get("c.getResourceBasedOnService");
        action.setParams({
            selectedServiceIds : component.get("v.selectedService")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resourceList = response.getReturnValue();
                var options = [];
            /*    resourceList.forEach(function(resource){
                    options.push({ value: resource.Id , Name: resource.Name, label: resource.Name ,Id: resource.Id});
                });*/
                for(var key in resourceList){
                    options.push({value: resourceList[key].CC_QAppt__Resource_Staff__c ,label:resourceList[key].CC_QAppt__Resource_Staff__r.Name, Name:resourceList[key].CC_QAppt__Resource_Staff__r.Name,value: resourceList[key].CC_QAppt__Resource_Staff__c , Id:resourceList[key].CC_QAppt__Resource_Staff__c , Price: resourceList[key].CC_QAppt__Price__c }); 
                }
                component.set("v.availableResourceList",options);
            }
            else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
   /*******************************************************************************************************
    * @description This is the method which will fetch All Resources
   */         
    fetchAllResources : function(component,event,helper){
        var action = component.get("c.getResources");
          action.setParams({
            selectedServiceIds : component.get("v.selectedService")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resourceList = response.getReturnValue();
                var options = [];
                resourceList.forEach(function(resource){
                    options.push({value: resource.Id , Name: resource.Name ,label: resource.Name , Id: resource.Id})                     
                });
                component.set("v.availableResourceList",options);
            }
            else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    //Fetch Resources based on location
    fetchResourcesBasedOnLocation : function(component,event,helper){
        var action = component.get("c.getResourceBasedOnLocation");
         action.setParams({
            selectedLocationIds : component.get("v.selectedLocation")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                  var resourceList = response.getReturnValue();
                var options = [];
              /*  resourceList.forEach(function(resource){
                    options.push({ value: resource.Id,Name: resource.Name, label: resource.Name ,Id: resource.Id});
                });*/
                 for(var key in resourceList){
                    options.push({value: resourceList[key].CC_QAppt__Resource_Staff__c ,label:resourceList[key].CC_QAppt__Resource_Staff__r.Name, Name:resourceList[key].CC_QAppt__Resource_Staff__r.Name,value: resourceList[key].CC_QAppt__Resource_Staff__c , Id:resourceList[key].CC_QAppt__Resource_Staff__c , Price: resourceList[key].CC_QAppt__Price__c }); 
                }              
                component.set("v.availableResourceList",options);
            }
            else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);
        
    },
    /*******************************************************************************************************
    * @description This method is used get column headers of datatable.
    */
    getColumnAndAction : function(component) {
        var action = component.get("c.getFields");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.isCustomerList",true);
                component.set("v.columns", resultData);
            }       
            else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },   
    
   /*******************************************************************************************************
    * @description This is the method which will fetch Customer List
   */         
    fetchCustomerList : function(component,event,helper){
        console.log('@@@CustomerListCalled');
        var action = component.get("c.getCustomers");
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log("@@stateCust",state);
            if (state === "SUCCESS") {
                var customerList = response.getReturnValue();
                console.log("customerList"+JSON.stringify(customerList));
                component.set("v.availableCustomerList",customerList);
                component.set("v.pageNumber",1);
                component.set("v.dataSize",customerList.length);
                if(customerList != null){
                    var pagecount= Math.ceil((customerList.length)/10);
                    if(pagecount==0){
                        component.set("v.pageNumber",0);
                        component.set("v.totalPages",0);
                    }
                    else{
                        component.set("v.pageNumber",1);
                        component.set("v.totalPages",pagecount);
                    }
                    
                    this.handleFirstLast(component,event,helper,component.get("v.pageNumber"));
                }           
            }
            else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    /*******************************************************************************************************
     * @description    This is the method to handle first last page Pagination
    */    
    handleFirstLast : function(component,event,helper,pagenumber){
        var CustomerList = component.get("v.availableCustomerList");   
        var searchResourceList = component.get("v.searchCustomerList");
        if(searchResourceList.length){
            resourceList = searchResourceList;
        }
        var pagecount= Math.ceil((CustomerList.length)/10);
        if(pagecount==0){
            component.set("v.pageNumber",0);
            component.set("v.totalPages",0);
            component.set("v.paginationData",[]);
        }
        else{
            component.set("v.totalPages",pagecount);
            component.set("v.pageNumber",pagenumber);
            var recordPerPage = component.get("v.pageSize");    
            var endPagination = pagenumber * recordPerPage;
            this.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,CustomerList); 
        }
    },
    /*******************************************************************************************************
    * @description This is the method which will hanlde Pagination List
   */         
    handlePagination : function(component,event,helper,startPagination,end,CustomerList){
        var pageData = [];
        for(var i =startPagination;i<end ;i++){
            if(CustomerList[i] )
                pageData.push(CustomerList[i]);
            else
                break;
        } 
        component.set("v.paginationData",pageData);
    },
    /*******************************************************************************************************
     * @description This is the method to handle next page Pagination
    */
    next  : function(component,event,helper){
        var resourceList = component.get("v.availableCustomerList");
        var searchResourceList = component.get("v.searchCustomerList");
        if(searchResourceList.length){
            resourceList = searchResourceList;
        }
        var startPagination  = component.get("v.pageNumber")+1;
        component.set("v.pageNumber",startPagination);
        var recordPerPage = component.get("v.pageSize");
        var endPagination = startPagination * recordPerPage;
        helper.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,resourceList);
    },
    
    /*******************************************************************************************************
     * @description This is the method to handle previous page Pagination
    */     
    previous : function(component, event, helper) {
        var resourceList = component.get("v.availableCustomerList");
        var searchResourceList = component.get("v.searchCustomerList");
        if(searchResourceList.length){
            resourceList = searchResourceList;
        }
        var startPagination  = component.get("v.pageNumber")-1;
        component.set("v.pageNumber",startPagination);
        var recordPerPage = component.get("v.pageSize");
        var endPagination = startPagination * recordPerPage;
        helper.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,resourceList);
    },
    
    /*******************************************************************************************************
    * @description This is the method which will save appointment
   */          
    saveAppointment : function(component,event,helper){
        var selectedLocation = component.get("v.selectedLocation");
        var selectedService = component.get("v.selectedService");
        var LocationServiceList = component.get("v.availableServiceList");
        var LocationService = LocationServiceList.filter(function(locServ){
            if(locServ.LocationId == selectedLocation[0] && locServ.Id == selectedService[0]){
                return locServ.LocationService;
            }
        });
        console.log("pricingList"+JSON.stringify(component.get("v.pricingList")));
      var action = component.get("c.createAppointment");
        action.setParams({
            appointmentId       : component.get("v.appointmentId"), 
            appointmentName     : component.get("v.appointmentName"),
            selectedResourceIds :  component.get("v.selectedResourceList"),
            selectedAssetIds    :  component.get("v.selectedAssetList"),
            selectedLocService  : LocationService[0].LocationService,
            selectedLocationId  : component.get("v.selectedLocation"),
            selectedServiceId   : component.get("v.selectedService"),
            statusOfAppointment : component.get("v.selectedStatus"),
            startDate           : component.get("v.startDate"),
            startTime           : component.get("v.startTime"),
            duration            : component.get("v.Duration"),
            description         : component.get("v.description"),
            totalPrice          : component.get("v.totalAppointmentPrice"),
            appointmentCategory : component.get("v.selectedAppointmentCategory").Id,       
            selectedCustomer    : component.get("v.selectedCustomers"),
            pricingOfList       : component.get("v.pricingList")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
             //   alert("Success");
                var refreshEvent = component.getEvent("refreshEvent");
                refreshEvent.fire();   
                component.set("v.showModal",false);
                console.log("state"+state);
                
                //Show success notification on public site
                if(component.get("v.isPublic")){
                    component.set("v.overrideWithSuccessAlert", true);
                }
            }       
            else if (state=="ERROR"){
                   
                 var errorMsg = action.getError()[0];
             
                console.log("errorMsg"+JSON.stringify(errorMsg));
                console.log("errorMsg"+JSON.stringify(errorMsg.message));
                component.set("v.isError",true);
                component.set("v.errorMessage",errorMsg.message);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*******************************************************************************************************
    * @description This is the method which will handle search customer
   */         
    handleSearchCustomer : function(component,event,helper,searchData){
        var action = component.get("c.searchCustomer");
        action.setParams({
            customerName :searchData
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("searchcustomer"+response.getReturnValue());
                component.set("v.searchCustomerList",response.getReturnValue());
                 helper.handlePaginationOnSearch(component,event,helper,1); 
            }       
            else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);        
    },
    
   /*******************************************************************************************************
    * @description This is the method which will hanlde Pagination On search customer list
   */         
      handlePaginationOnSearch : function(component,event,helper,pagenumber){
        var searchResourceList = component.get("v.searchCustomerList");
        var pagecount= Math.ceil((searchResourceList.length)/10);
        if(pagecount==0){
            component.set("v.pageNumber",0);
            component.set("v.totalPages",0);
            component.set("v.paginationData",[]);
        }
        else{
            component.set("v.pageNumber",pagenumber);
            component.set("v.totalPages",pagecount);
            var recordPerPage = component.get("v.pageSize");      
            var endPagination = pagenumber * recordPerPage;
            helper.handlePagination(component,event,helper,endPagination-recordPerPage,endPagination,searchResourceList);
        }
    },
    
    editAppointment : function(component,event,helper){
        var action = component.get("c.editAppointment");      
        action.setParams({
            appointmentId : component.get("v.appointmentId")
        });   
        action.setCallback(this,function(response) {
            var state = response.getState();
            var relatedData = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.appointmentName", relatedData.AppointmentName);
                component.set("v.appointmentCatList",relatedData.appointmentCategory[0]);
                component.set("v.selectedApppointmentCat",relatedData.appointmentCategory[0]);
                component.set("v.startDate",relatedData.startDate);
                component.set("v.startTime",relatedData.startTime);
                component.set("v.description",relatedData.description);
                
                //This will enable the function to call for appointment category select
                component.set("v.selectedAppointmentCategory",relatedData.appointmentCategory[0]);
                
                //Set status of the appointment
                component.set("v.statusList",relatedData.Status);               
                component.set("v.selectedStatus",relatedData.Status);
                
                component.set("v.Duration",relatedData.duration);
                component.set("v.totalAppointmentPrice",relatedData.totalPrice);
                
                //Set Asset List
                var selectedAsset = [];
                relatedData.selectedassetList.forEach(function(asset){
                    selectedAsset.push(asset);
                })
                component.set("v.selectedAssetList",selectedAsset);
                
                
                 //component.set("v.selectedRowList",selectedRows);
                var fetchCategory = component.get('c.onCategorySelect');
                fetchCategory.setCallback(this,function(resp){
                    var selectedLocations = [];
                    relatedData.selectedlocationList.forEach(function(location){
                        selectedLocations.push(location);
                    })
                    component.set("v.selectedLocation",selectedLocations);
                    
                    //IF Service Is mandatory then we fetch services based on location
                    if(relatedData.appointmentCategory[0].CC_QAppt__IsLocationMandatory__c == true && relatedData.appointmentCategory[0].CC_QAppt__IsServiceMandatory__c == true){
                        this.fetchServiceBasedOnLocations(component,event,helper);
                        var selectedServices = [];
                        relatedData.selectedserviceList.forEach(function(service){
                            selectedServices.push(service);
                        })
                    }
                     component.set("v.selectedService",selectedServices);
                    
                    //Fetch Resources based on service if service is mandatory
                    if(relatedData.appointmentCategory[0].CC_QAppt__IsServiceMandatory__c == true && relatedData.appointmentCategory[0].CC_QAppt__IsResourceMandatory__c == true){
                        this.fetchResourceBasedOnService(component,event,helper);
                        var selectedResources = [];
                        relatedData.selectedresourceList.forEach(function(resource){
                            selectedResources.push(resource);
                        })
                        component.set("v.selectedResourceList",selectedResources);
                    }
                    
                    //Fetch Resources based on location if service is not mandatory
                    if(relatedData.appointmentCategory[0].CC_QAppt__IsLocationMandatory__c == true && relatedData.appointmentCategory[0].CC_QAppt__IsServiceMandatory__c == false){
                        if(relatedData.appointmentCategory[0].CC_QAppt__IsResourceMandatory__c == true){
                        this.fetchResourcesBasedOnLocation(component,event,helper);
                        var selectedResources = [];
                        relatedData.selectedresourceList.forEach(function(resource){
                            selectedResources.push(resource);
                        })
                        component.set("v.selectedResourceList",selectedResources);
                        }   
                    }
                    
                    var updatedpricinglist = [];
                    var pricinglist = relatedData.wrappprice.forEach(function(priceobj){
                        var PriceBeforeDiscount = 0;
                         PriceBeforeDiscount =  parseFloat(priceobj.TotalPrice) + ((parseFloat(priceobj.TotalPrice) * parseInt(priceobj.Discount))/100);
                        var pricecalculate = {Price:PriceBeforeDiscount};
                        Object.assign(priceobj,pricecalculate);
                        updatedpricinglist.push(priceobj);
                    });
                    
                    component.set("v.pricingList",updatedpricinglist);
                    
                    var selectedCustomerList = new Array();
                    relatedData.selectedcustomerList.forEach(function(customer){
                        selectedCustomerList.push(customer.Id);            
                    });
                        component.set("v.selectedRowList",selectedCustomerList);

                });
                $A.enqueueAction(fetchCategory);
            }       
            
        });
        $A.enqueueAction(action);        
    },
    
})