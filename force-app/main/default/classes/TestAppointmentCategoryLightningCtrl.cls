@isTest
public class TestAppointmentCategoryLightningCtrl {
       static list<CC_QAppt__Appointment_Category__c> appointmentCategoryList=new list<CC_QAppt__Appointment_Category__c>();
	/* method to make AppointmentCategoryRecord records for testing*/
   @testSetup
    static void setup(){
         appointmentCategoryList=TestDataFactory.AppointmentCategoryList(20);
        system.debug(appointmentCategoryList.size());
        insert appointmentCategoryList;
    }
    /* method to test if records are available to edit*/
    @istest
    static void getAppointmentCategoryRecordWhileEditing(){
       // insert appointmentCategoryList;
          CC_QAppt__Appointment_Category__c category=[select Name,CC_QAppt__IsAssetMandatory__c,CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsMultipleAttendee__c,CC_QAppt__IsMultipleLocation__c,CC_QAppt__IsMultipleResource__c,CC_QAppt__IsMultipleService__c,CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsPricingApplicable__c,CC_QAppt__IsServiceMandatory__c from CC_QAppt__Appointment_Category__c limit 1] ;
        Test.startTest();
        AppointmentCategoryLightningController.getFields();
       list<CC_QAppt__Appointment_Category__c> conlist= AppointmentCategoryLightningController.getAppointmentCategories(category.id);
        Test.stopTest();
        system.assertEquals(conlist.size(),1,'error while fetching record to edit');
         

    }
    /* method to test if records are showing in the datatable while component initialization*/
    @isTest
    static void fetchAppointmentCategoryRecordsWhileInitialization(){
        
       // system.debug(appointmentCategoryList.size());
       //  insert appointmentCategoryList;
        Test.startTest();
       
       
        list<CC_QAppt__Appointment_Category__c> conlist= AppointmentCategoryLightningController.getAppointmentCategories(null);
        Test.stopTest();
        system.assertEquals(conlist.size(),20,'error while fetching record on component initialization');
    }
    
    /*method to test insertion of records while clicking on save button*/
    @isTest
    static void saveAppointmentCategoryRecord(){
         
        //insert appointmentCategoryList;
        delete [select Name,CC_QAppt__IsAssetMandatory__c,CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsMultipleAttendee__c,CC_QAppt__IsMultipleLocation__c,CC_QAppt__IsMultipleResource__c,CC_QAppt__IsMultipleService__c,CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsPricingApplicable__c,CC_QAppt__IsServiceMandatory__c from CC_QAppt__Appointment_Category__c limit 1] ;
        Test.startTest();
        CC_QAppt__Appointment_Category__c obj=new CC_QAppt__Appointment_Category__c(Name='test',CC_QAppt__IsAssetMandatory__c=true,CC_QAppt__IsAttendeeMandatory__c=true	,CC_QAppt__IsAvaliablePublically__c=true,CC_QAppt__IsLocationMandatory__c=true,CC_QAppt__IsMultipleAsset__c=true,CC_QAppt__IsMultipleAttendee__c=true,CC_QAppt__IsMultipleLocation__c=true,CC_QAppt__IsMultipleResource__c=true,CC_QAppt__IsMultipleService__c=true,CC_QAppt__IsResourceMandatory__c=true,CC_QAppt__IsPricingApplicable__c=true,CC_QAppt__IsServiceMandatory__c=true);
        boolean result=AppointmentCategoryLightningController.saveCategory(obj);
        Test.stopTest();
        system.assert(result,'error while inserting records');
    }
   /* @isTest
    static void errorwhilesavingAppointmentCategoryRecord(){
        boolean result;
         //CC_QAppt__Appointment_Category__c con=[select Name,CC_QAppt__IsAssetMandatory__c,CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsMultipleAttendee__c,CC_QAppt__IsMultipleLocation__c,CC_QAppt__IsMultipleResource__c,CC_QAppt__IsMultipleService__c,CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsPricingApplicable__c,CC_QAppt__IsServiceMandatory__c from CC_QAppt__Appointment_Category__c limit 1] ;
       // con.name='';
        insert appointmentCategoryList;
        CC_QAppt__Appointment_Category__c appCategory=[select Name,CC_QAppt__IsAssetMandatory__c,CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsMultipleAttendee__c,CC_QAppt__IsMultipleLocation__c,CC_QAppt__IsMultipleResource__c,CC_QAppt__IsMultipleService__c,CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsPricingApplicable__c,CC_QAppt__IsServiceMandatory__c from CC_QAppt__Appointment_Category__c limit 1] ;
        Test.startTest();
        appointmentCategoryList[1].name='';
             result=AppointmentCategoryLightningController.saveCategory(appointmentCategoryList[1]);
       
        
            
            //system.assertEquals(e.getMessage(), actual, 'error while saving appointmentCategory record');
        
        
        Test.stopTest();
        system.assert(result,'error while inserting records');
    }*/
    /* method to test deletion of records while clicking of delete button*/
    @isTest
    static void deleteAppointmentCategoryRecords(){
       
        insert appointmentCategoryList;
        CC_QAppt__Appointment_Category__c categoryList=[select Name,CC_QAppt__IsAssetMandatory__c,CC_QAppt__IsAttendeeMandatory__c,CC_QAppt__IsAvaliablePublically__c,CC_QAppt__IsLocationMandatory__c,CC_QAppt__IsMultipleAsset__c,CC_QAppt__IsMultipleAttendee__c,CC_QAppt__IsMultipleLocation__c,CC_QAppt__IsMultipleResource__c,CC_QAppt__IsMultipleService__c,CC_QAppt__IsResourceMandatory__c,CC_QAppt__IsPricingApplicable__c,CC_QAppt__IsServiceMandatory__c  from CC_QAppt__Appointment_Category__c limit 1] ;
        system.debug('size'+categoryList);
        Test.startTest();
        boolean result=AppointmentCategoryLightningController.deleteCategory(categoryList.Id);
        Test.stopTest();
        system.assert(result,'error while delete records');
    }
    
}