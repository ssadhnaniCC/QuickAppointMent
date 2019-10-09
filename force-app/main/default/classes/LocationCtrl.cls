public with sharing class LocationCtrl{
    public Location__c Loc{get;set;}
    public List<Location__c> locList{get;set;}
    public string locationId{get;set;}
    public boolean isEdatible {get;set;}
    public string locationIdForDelete{get;set;}
    public boolean errorDiv{get;set;}
    public boolean containtselement{get;set;}
    public string locationNameSearch{get;set;}
    
    public LocationCtrl(){
        isEdatible = false;
        errorDiv = false;
        Loc = new Location__c();
        locList = AppointmentHelper.fetchAllLocations();
         if(locList .size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
    }
    
    public void goToNewEditMode(){
         errorDiv = false;
        isEdatible = true;
        if(locationId == ''){
            Loc = new Location__c();
        }else{
            Loc = getLocationById(locationId);
        }
    }
    
    private Location__c getLocationById(string loc){
        if(Schema.sObjectType.Location__c.fields.name.isAccessible() && Schema.sObjectType.Location__c.fields.Street__c.isAccessible() && Schema.sObjectType.Location__c.fields.Country__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.City__c.isAccessible() && Schema.sObjectType.Location__c.fields.Postal_Code__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.Coordinates__Latitude__s.isAccessible() && Schema.sObjectType.Location__c.fields.Coordinates__Longitude__s.isAccessible()){
            return [select name,Street__c,State__c,Country__c,City__c,Postal_Code__c,valid__c,Coordinates__c,Coordinates__Latitude__s,Coordinates__Longitude__s from Location__c where id =: loc];
        }
        return null;
    }
    
    public void cancelNewEditMode(){
        isEdatible = false;
    }
    
    public PageReference saveLocation(){
        //errorDiv = false; 
        
        String address = '';
        if (loc.Street__c != null)
            address += loc.Street__c +', ';
        if (loc.city__c != null)
            address += loc.city__c +', ';
        if (loc.State__c != null)
            address += loc.State__c +' ';
        if (loc.Postal_Code__c != null)
            address += loc.Postal_Code__c +', ';
        if (loc.Country__c != null)
            address +=loc.Country__c;

        address = EncodingUtil.urlEncode(address, 'UTF-8');

        // build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBsK_aRuJ2vYqi6atsuWx2ZZ9s9BlX75EE&address='+address+'&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);

        try{
            // callout
             HttpResponse res= new HttpResponse();
            if(!test.isRunningTest())
                res = h.send(req);
            else
                res.setBody('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBsK_aRuJ2vYqi6atsuWx2ZZ9s9BlX75EE&address='+address+'&sensor=false');
            // parse coordinates from response
            String jsondata = res.getBody();
            String str1 = jsondata.substring( jsondata.indexOf('"geometry"')+'"geometry"'.length() , jsondata.indexOf('"location_type"')  );
            String str2 = str1.substring( str1.indexOf('"location" : {')+'"location" : {'.length() , str1.length()  );
            string lat = str2.substring( str2.indexOf('"lat" : ')+'"lat" : '.length() , str2.indexOf(',')  );
            string lng = str2.substring( str2.indexOf('"lng" : ')+'"lng" : '.length() , str2.indexOf('},')  );
            
            if (lat != null){
                Loc.Coordinates__Latitude__s = double.valueOf(lat.trim());
                Loc.Coordinates__Longitude__s = double.valueOf(lng.trim());   
            }

        } catch (Exception e) {
        }
        if(Loc.name == '' || Loc.name == null){
       
            errorDiv = true;
            
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Enter Location Name');
            ApexPages.addMessage(requirereasonMessage);
            System.debug('90');
            return null;
        }
        else if(Loc.Street__c == '' || Loc.Street__c == null){
             errorDiv = true;
             ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Enter Address');
            ApexPages.addMessage(requirereasonMessage);
            
        }
        /*else if(Loc.Coordinates__Latitude__s == null && Loc.Coordinates__Longitude__s == null){
            errorDiv = true;
            ApexPages.Message requirereasonMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please Enter Valid Address Details');
            ApexPages.addMessage(requirereasonMessage);
            return null;
        }*/
       else{
           errorDiv = false;
          
        }
        if(errorDiv == false){
            if((Schema.sObjectType.Location__c.fields.name.isCreateable() && Schema.sObjectType.Location__c.fields.Street__c.isCreateable() && Schema.sObjectType.Location__c.fields.Country__c.isCreateable()
               && Schema.sObjectType.Location__c.fields.City__c.isCreateable() && Schema.sObjectType.Location__c.fields.Postal_Code__c.isCreateable()
               && Schema.sObjectType.Location__c.fields.Coordinates__Latitude__s.isCreateable() && Schema.sObjectType.Location__c.fields.Coordinates__Longitude__s.isCreateable()) && (Schema.sObjectType.Location__c.fields.name.isUpdateable() && Schema.sObjectType.Location__c.fields.Street__c.isUpdateable() && Schema.sObjectType.Location__c.fields.Country__c.isUpdateable()
               && Schema.sObjectType.Location__c.fields.City__c.isUpdateable() && Schema.sObjectType.Location__c.fields.Postal_Code__c.isUpdateable()
               && Schema.sObjectType.Location__c.fields.Coordinates__Latitude__s.isUpdateable() && Schema.sObjectType.Location__c.fields.Coordinates__Longitude__s.isUpdateable())){
                upsert Loc;
            }
            locList = AppointmentHelper.fetchAllLocations();
         if(locList .size()>0){
    containtselement = true;
    }
    else{
     containtselement = false;
    }
       
            isEdatible = false;
            System.debug('110');
            /*PageReference pageRef = new PageReference('/apex/Location');
            pageRef.setRedirect(true);
            return pageRef;*/
            return null;
            //System.debug('110');
            //return new pagereference('/apex/Location');
        }
       
        return null;
        
    }
    public void DeleteLocation(){
        Location__c DeleteLoc = new Location__c();
        DeleteLoc = getLocationById(locationIdForDelete);
        if(Location__c.sObjectType.getDescribe().isDeletable()){
            Delete DeleteLoc;
        }
        locList = AppointmentHelper.fetchAllLocations();
           if(locList.size()>0){
        containtselement = true;
        }
        else{
         containtselement = false;
        }
    }
    public PageReference search(){
        String searchValue = '%'+locationNameSearch+'%';
        if(Schema.sObjectType.Location__c.fields.name.isAccessible() && Schema.sObjectType.Location__c.fields.Street__c.isAccessible() && Schema.sObjectType.Location__c.fields.Country__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.City__c.isAccessible() && Schema.sObjectType.Location__c.fields.Postal_Code__c.isAccessible()
           && Schema.sObjectType.Location__c.fields.Coordinates__Latitude__s.isAccessible() && Schema.sObjectType.Location__c.fields.Coordinates__Longitude__s.isAccessible()){
               if(searchValue != null || searchValue != ''){
                   
               locList = [select name,Street__c,State__c,Country__c,City__c,Postal_Code__c,valid__c,Coordinates__c,Coordinates__Latitude__s,Coordinates__Longitude__s from Location__c where street__c like : searchValue];
           }
               else{
               locList = AppointmentHelper.fetchAllLocations();
               }
               if(locList.size()>0){
                   containtselement = true;
               }
               else{
                   containtselement = false;
               }
        }
        return null;
    }
     public void spin() {
     system.debug('@@@@@');
        long now = datetime.now().gettime();
        
        while(datetime.now().gettime()-now<5000); // Busy loop for 5000 ms
    }
    
}