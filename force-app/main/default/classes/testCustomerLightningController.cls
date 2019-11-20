@isTest
public class testCustomerLightningController {

    @testSetup
    static void setup(){
        list<contact> customerList=TestDataFactory.customerList(20);
        insert customerList;
    }
    /*@isTest
    static void testCustomer(){
       list<contact> custList=[select id,firstName,lastName,email,phone,mailingstreet,mailingCountry,mailingState,MailingCity,description,MailingpostalCode from contact] ;
        CustomerLightningController.getFields();
        CustomerLightningController.getCustomers(custList[0].id);
         CustomerLightningController.getCustomers(null);
        for(contact con:custList){
            CustomerLightningController.saveCustomer(con);
             boolean result=CustomerLightningController.deleteCustomer(con.Id);
            system.assertequals(result,false,'error while deleting');
        }
        
        
    }*/
    /* method to test if records are available to edit*/
    @istest
    static void getCustomerRecordWhileEditing(){
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
        Test.stopTest();
        system.assert(result,'error while inserting records');
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