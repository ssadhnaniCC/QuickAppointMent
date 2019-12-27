({
    /*******************************************************************************************************
    * @description This is the init method which will fetch Appointment category and fetch status of Appointment.
   */
    doInit : function(component, event, helper) {
        //var pageReference = component.get("v.pageReference");
        //console.log("###parameters=", pageReference);
        console.log("showModal",component.get("v.showModal"));
        console.log("aPPId",component.get("v.appointmentId"));
        helper.getTemplateList(component,event,helper);
        
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
                    console.log("@@ERROR", response.getError());
                }
            });
            $A.enqueueAction(action);
            helper.fetchStatusOfAppointment(component,event,helper);
        }
        if(component.get("v.appointmentId")){
            console.log("appointmentId"+component.get("v.appointmentId"));
            helper.editAppointment(component,event,helper);
        }  
    },
    
    
    
    /*******************************************************************************************************
    * @description This is the  method which will fetch Appointment form data based on appointment category selected
   */  
    onCategorySelect : function(component, event, helper) {
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
        
        if(component.get("v.selectedAppointmentCategory")){
            var selectedCategory = component.get("v.selectedAppointmentCategory");
            console.log('selectedCategory'+JSON.stringify(selectedCategory));
            var methodName;
            var mandatoryObj;
            
            if((selectedCategory.CC_QAppt__IsLocationMandatory__c == true))
            {
                mandatoryObj = 'Location'
                methodName = 'c.getLocations' 
                helper.handleOnCategorySelect(component,event,helper,selectedCategory,mandatoryObj,methodName); 
            }
            if(selectedCategory.CC_QAppt__IsLocationMandatory__c == false &&  selectedCategory.CC_QAppt__IsServiceMandatory__c == true){
                mandatoryObj = 'Service'
                methodName = 'c.getServices';
                helper.handleOnCategorySelect(component,event,helper,selectedCategory,mandatoryObj,methodName); 
            }
            
            if((selectedCategory.CC_QAppt__IsLocationMandatory__c == false &&  selectedCategory.CC_QAppt__IsServiceMandatory__c == false) 
               &&  (selectedCategory.CC_QAppt__IsResourceMandatory__c == true)){
                mandatoryObj = 'Resource'
                methodName = 'c.getResources'
                helper.handleOnCategorySelect(component,event,helper,selectedCategory,mandatoryObj,methodName); 
            }      
            
         /*   if(selectedCategory.CC_QAppt__IsAttendeeMandatory__c == true){
                helper.fetchAttendeeList(component,event,helper,selectedCategory);
            }*/
            if(selectedCategory.CC_QAppt__IsAssetMandatory__c == true){
                helper.fetchAssetList(component,event,helper,selectedCategory); 
            }
            helper.getColumnAndAction(component,event,helper);         
            helper.fetchCustomerList(component,event,helper); 
        }
    },
    
    onTemplateSelect : function(component,event,helper){
        var selectedObject =  component.get("v.selectedTemplate"); 
        helper.getTemplate(component,event,helper);
    },
    
    
    /*******************************************************************************************************
    * @description This is the  method which will handle selected location and fetch services based on selected location
   */     
    handleOnLocationSelect : function(component,event,helper){  
        var  selectedLocationList ;
        var selectedObject =  component.get("v.selectedAppointmentCategory"); 
        if(selectedObject.CC_QAppt__IsMultipleLocation__c == false){
            selectedLocationList      =  component.find('selectLocation').get('v.value');
        }
        else{
            selectedLocationList = event.getParam("value");
        }
        component.set("v.selectedLocation",selectedLocationList);
        component.set("v.showSpinner",true);
        if(selectedObject.CC_QAppt__IsServiceMandatory__c == true || component.get("v.isTemplateSelected")==true)
        {
            alert("location");
            helper.fetchServiceBasedOnLocations(component,event,helper);
        }
        if(selectedObject.CC_QAppt__IsServiceMandatory__c == false && selectedObject.CC_QAppt__IsResourceMandatory__c == true){
            helper.fetchResourcesBasedOnLocation(component,event,helper);
        }
    },
    
    
    /*******************************************************************************************************
    * @description This is the  method which will handle selected service and fetch resources based on selected service
   */     
    handleOnServiceSelect : function(component,event,helper){
        var  selectedServiceList ;
        var selectedObject =  component.get("v.selectedAppointmentCategory");
        var serviceList = component.get("v.availableServiceList");
        if(selectedObject.CC_QAppt__IsMultipleService__c == false){
            selectedServiceList      =  component.find('selectService').get('v.value');
        }
        else{
            selectedServiceList = event.getParam("value");
        }
        component.set("v.selectedService",selectedServiceList);
        component.set("v.showSpinner",true);
        if(selectedServiceList){
            
            //Pricing For Service Is Applicable
            if(selectedObject.CC_QAppt__PricingForService__c)
            var ListOfServicePrice = [];          
            var selectedServices = serviceList.filter(function(service){
                if(selectedServiceList.includes(service.Id)){
                    var price;
                    if(service.price == '' || service.price=='undefined'){
                        price = 0;
                    }
                    else{
                       price = service.price; 
                    }
                    var priceobj = {ListType:"Service",Id:service.Id,Name:service.Name,Price:price,Discount:0,TotalPrice:price};
                    ListOfServicePrice.push(priceobj); 
                }
            })
            var pricinglist = component.get("v.pricingList");
            if(pricinglist.length==0 || pricinglist=='undefined'){
               pricinglist = []; 
            }
            else{
                for(var i=0 ;i<pricinglist.length;i++){
                    if(pricinglist[i].ListType=='Service'){
                        pricinglist.splice(i,1);
                    }
                }
            }
            var totalPrice = 0;
             ListOfServicePrice.forEach(function(listService){
                pricinglist.push(listService);
            });
                   
            pricinglist.forEach(function(price){
                totalPrice = totalPrice +  price.TotalPrice; 
            });
            component.set("v.pricingList",pricinglist);
            component.set("v.totalAppointmentPrice",totalPrice);
        }
        if(selectedObject.CC_QAppt__IsResourceMandatory__c == true){
            helper.fetchResourceBasedOnService(component,event,helper);
        }    
        
    },
    
    
    /*******************************************************************************************************
    * @description This is the  method which will handle status select
   */     
    handleStatusSelect : function(component,event,helper){
        var selectstatus = component.find('selectStatus').get('v.value');
        component.set("v.selectedStatus",selectstatus);
    },
    
    
    /*******************************************************************************************************
    * @description This is the  method which will handle asset select
   */     
    handleOnAssetSelect : function(component,event,helper){
        var  selectedAssetList ;
        var selectedObject =  component.get("v.selectedAppointmentCategory"); 
        var availableAssetList = component.get("v.availableAssetList");
        if(selectedObject.CC_QAppt__IsMultipleAsset__c == false){
            selectedAssetList  =  component.find('selectAsset').get('v.value');
        }
        else{
            selectedAssetList = event.getParam("value");
        }
        if(selectedObject){
            if(selectedObject.CC_QAppt__PricingForAsset__c){
                var ListOfAssetPrice = [];          
                var selectedAsset = availableAssetList.filter(function(asset){
                    if(selectedAssetList.includes(asset.Id)){
                        var priceobj = {ListType:"Asset",Id:asset.Id,Name:asset.Name,Price:asset.Price,Discount:0,TotalPrice:asset.Price};
                        ListOfAssetPrice.push(priceobj); 
                    }
                })
                var pricinglist = component.get("v.pricingList");
                if(pricinglist.length==0 || pricinglist=='undefined'){
                    pricinglist = []; 
                }
             else{
                for(var i=0 ;i<pricinglist.length;i++){
                    if(pricinglist[i].ListType=='Asset'){
                        pricinglist.splice(i,1);
                    }
                }
            }
                var total = 0;
                ListOfAssetPrice.forEach(function(f){
                    pricinglist.push(f);
                });
                pricinglist.forEach(function(price){
                    total = total + price.TotalPrice;  
                });
                component.set("v.totalAppointmentPrice",total);
                console.log("PricingList"+pricinglist);
                component.set("v.pricingList",pricinglist);   
            }
        }
        component.set("v.selectedAssetList",selectedAssetList); 
    },
    
    /*******************************************************************************************************
    * @description This is the  method which will handle Resource select
   */         
    handleOnResourceSelect : function(component,event,helper){
        var  selectedResourceList ;
        var selectedObject =  component.get("v.selectedAppointmentCategory"); 
        var availableResources = component.get("v.availableResourceList");

        if(selectedObject.CC_QAppt__IsMultipleResource__c == false){
            selectedResourceList  =  component.find('selectResource').get('v.value');
        }
        else{
            selectedResourceList = event.getParam("value");
        }
        if(selectedObject){
            if(selectedObject.CC_QAppt__PricingForResource__c){
                var ListOfResourcePrice = [];          
                var selectedAsset = availableResources.filter(function(Resource){
                    if(selectedResourceList.includes(Resource.Id)){
                        console.log("Resource"+JSON.stringify(Resource));
                        var price;
                        if(Resource.price == '' || Resource.price=='undefined'){
                            price = 0;
                        }
                        else{
                            price = Resource.Price; 
                        }
                        var priceobj = {ListType:"Resource",Id:Resource.Id,Name:Resource.Name,Price:price,Discount:0,TotalPrice:price};
                        ListOfResourcePrice.push(priceobj); 
                    }
                })
                var pricinglist = component.get("v.pricingList");
                if(pricinglist.length==0 || pricinglist=='undefined'){
                    pricinglist = []; 
                }
                 else{
                for(var i=0 ;i<pricinglist.length;i++){
                    if(pricinglist[i].ListType=='Resource'){
                        pricinglist.splice(i,1);
                    }
                }
            }
                var total = 0;
                ListOfResourcePrice.forEach(function(f){
                    pricinglist.push(f);
                });
                pricinglist.forEach(function(price){
                    total = total + price.TotalPrice;  
                });
                component.set("v.totalAppointmentPrice",total);
                console.log("PricingList"+pricinglist);
                component.set("v.pricingList",pricinglist);   
            }
        }
        component.set("v.selectedResourceList",selectedResourceList); 
        
    },
    
    /*******************************************************************************************************
    * @description This is the  method which will handle Attendee select
   */         
    handleOnAttendeeSelect : function(component,event,helper){
        var  selectedAttendeeList ;
        var selectedObject =  component.get("v.selectedAppointmentCategory"); 
        if(selectedObject.CC_QAppt__IsMultipleAttendee__c == false){
            selectedAttendeeList  =  component.find('selectAttendee').get('v.value');
        }
        else{
            selectedAttendeeList = event.getParam("value");
        }
        component.set("v.selectedAttendeeList",selectedAttendeeList); 
    },
    
    closeModal : function(component, event, helper) {
        component.set("v.showModal", false);
    },
    
    
    /*******************************************************************************************************
    * @description This is the  method which will handle saveAppointment and handle the validation 
   */         
    saveAppointment : function(component,event,helper){
        var selectedObject = component.get("v.selectedAppointmentCategory");
        if(selectedObject){
            var locationId =     (selectedObject.CC_QAppt__IsMultipleLocation__c == true) ? "AvailableLocation" : "selectLocation";
            var serviceId =     (selectedObject.CC_QAppt__IsMultipleService__c == true) ? "AvailableService" : "selectService";
            var resourceId =     (selectedObject.CC_QAppt__IsMultipleResource__c == true) ? "AvailableResource" : "selectResource"; 
            var assetId =     (selectedObject.CC_QAppt__IsMultipleAsset__c == true) ? "AvailableAsset" : "selectAsset"; 
            var attendeeId =     (selectedObject.CC_QAppt__IsMultipleAttendee__c == true) ? "AvailableAttendee" : "selectAttendee"; 
            var controlAuraIds = ["startDateField","startTimeField","appName","DurationField"];
            let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
                //fetches the component details from the auraId
                var inputCmp = component.find(controlAuraId);
                //    console.log("inputCmpreport"+inputCmp.reportValidity());
                //displays the error messages associated with field if any
                inputCmp.reportValidity();
                //inputCmp.showHelpMessageIfInvalid();
                ////form will be invalid if any of the field's valid property provides false value.
                return isValidSoFar && inputCmp.checkValidity();
            },true);
            if(isAllValid){
                helper.saveAppointment(component,event,helper);
            }
        }
        //  helper.saveAppointment(component,event,helper);
        
    },
    
    /*******************************************************************************************************
    * @description This is the method which will calculate discount on services
   */         
    handleDiscount : function(component,event,helper){
        var selectedRowIndex = parseInt(event.target.dataset.index);
        var pricingList = component.get("v.pricingList");
        for(var i=0;i<pricingList.length;i++){
            if(i==selectedRowIndex){
                console.log("Price"+JSON.stringify(pricingList[i].Price));
                pricingList[i].TotalPrice = pricingList[i].Price - ((pricingList[i].Price * pricingList[i].Discount)/100);
            }
        }
        var totalPrice = 0;
        pricingList.forEach(function(price){
            totalPrice =  totalPrice + price.TotalPrice ;
        });
        component.set("v.pricingList",pricingList); 
        component.set("v.totalAppointmentPrice",totalPrice.toFixed(2)); 
    },
    
    
    /*******************************************************************************************************
    * @description This is the method which will set list for selected customer
   */         
    updateSelectedCustomer : function(component,event,helper){
        var selectedRows = event.getParam('selectedRows'); 
        console.log("selectedRows"+JSON.stringify(selectedRows));
        component.set("v.selectedCustomers",selectedRows);
    },
    
    /*******************************************************************************************************
    * @description This is the method which will handle next page pagination
   */         
    handleNext : function(component,event,helper){
        helper.next(component,event,helper);      
    },
    
    /*******************************************************************************************************
    * @description This is the method which will handle search in data lis
   */         
    handleSearch : function(component,event,helper){
        var searchData =  component.get("v.searchData");
        console.log("searchData"+searchData);
        helper.handleSearchCustomer(component,event,helper,searchData);
    },
    /*******************************************************************************************************
    * @description This is the method which will call the previous helper 
   */
    handlePrev : function(component,event,helper){
        helper.previous(component,event,helper); 
    },
    /*******************************************************************************************************
    * @description This is the method which will handle the First button pagination
   */
    handleFirst : function(component,event,helper){
        helper.handleFirstLast(component,event,helper,1);
    },
    /*******************************************************************************************************
    * @description This is the method which will handle the Last button pagination
   */
    handleLast : function(component,event,helper){
        helper.handleFirstLast(component,event,helper,component.get("v.totalPages"));
    },
    closeAlert : function(component,event,helper){
        component.set("v.isError",false);
    },
    dateValidation : function(component,event,helper){
        var inputCmp = component.find("startDateField");
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.startDate") != '' && component.get("v.startDate") < todayFormattedDate){
            inputCmp.setCustomValidity('Date should be in present or Future');
        }else{
            inputCmp.setCustomValidity('');
        }
        inputCmp.reportValidity();
    }
    
})