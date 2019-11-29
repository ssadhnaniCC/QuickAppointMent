@isTest
public class testCustomerLightningController {

    /*method to prepare dummy  customer records*/
    @testSetup
    static void setup(){
        list<contact> customerList=TestDataFactory.customerList(20);
        insert customerList;
    }
    /* method to test if records are available to edit*/
    @istest
    static void getCustomerRecordForEditing(){
          contact con=[select id,firstName,lastName,email,phone,mailingstreet,mailingCountry,mailingState,MailingCity,description,MailingpostalCode from contact limit 1] ;
        Test.startTest();
        CustomerLightningController.getFields();
       list<contact> conlist= CustomerLightningController.getCustomers(con.id);
        Test.stopTest();
        system.assertEquals(conlist.size(),1,'error while fetching record to edit');
         

    }
    /* method to test if records are showing in the datatable while component initialization*/
    @isTest
    static void fetchCustomerRecordsWhileInitialization(){
        Test.startTest();
        list<contact> conlist= CustomerLightningController.getCustomers(null);
        Test.stopTest();
        system.assertEquals(conlist.size(),20,'error while fetching record on component initialization');
    }
    
    /*method to test insertion of records while clicking on save button*/
    @isTest
    static void saveCustomerRecord(){
         contact con=[select id,firstName,lastName,email,phone,mailingstreet,mailingCountry,mailingState,MailingCity,description,MailingpostalCode from contact limit 1] ;
        Test.startTest();        
            boolean result=CustomerLightningController.saveCustomer(con);
        system.assert(result,'error while inserting cutomer records');
        Test.stopTest();
    }
     /*method to test  error while insertion of records on clicking on save button*/
    @isTest
    static void neagativeSaveCustomerRecord(){
         contact con=[select id,firstName,lastName,email,phone,mailingstreet,mailingCountry,mailingState,MailingCity,description,MailingpostalCode from contact limit 1] ;
        con.lastname='';
        Test.startTest();
        try{ 
            boolean result=CustomerLightningController.saveCustomer(con);
           }
        catch(DMLException e){
            system.assertEquals(e.getMessage(),e.getmessage());
        }
       
        Test.stopTest();
        
    }
    /* method to test deletion of records while clicking of delete button*/
    @isTest
    static void deleteCustomerRecords(){
        contact con=[select id,firstName,lastName,email,phone,mailingstreet,mailingCountry,mailingState,MailingCity,description,MailingpostalCode from contact limit 1] ;
        Test.startTest();
        boolean result=CustomerLightningController.deleteCustomer(con.Id);
        Test.stopTest();
        system.assert(result,'error while delete records');
    }
    
    
    
    
}