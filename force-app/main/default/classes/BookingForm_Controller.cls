public class BookingForm_Controller {

    public Contact con {get;set;}
    public Date date1 {get;set;}
    public Time time1 {get;set;}
    public List<SelectOption> eventLst {get;set;}
    public String testPicklist{get;set;}
        
    public BookingForm_Controller() {
        con = new Contact();
        testPicklist = '';
        /*eventLst = new List<SelectOption>();
        eventLst.add(new SelectOption('','--None--'));
        eventLst.add(new SelectOption('Anand Karaj (Wedding)','Anand Karaj (Wedding)'));
        eventLst.add(new SelectOption('Kurmai (Engagement)','Kurmai (Engagement)'));
        eventLst.add(new SelectOption('Akhand Paath (3 Day Prayers)','Akhand Paath (3 Day Prayers)'));
        eventLst.add(new SelectOption('Sejeh Paath (Custom Length Prayers)','Sejeh Paath (Custom Length Prayers)'));
        eventLst.add(new SelectOption('Sukhmani Sahib Paath (stanzas of 10 hymns)','Sukhmani Sahib Paath (stanzas of 10 hymns)'));
        eventLst.add(new SelectOption('Other','Other'));*/
    }
     public pageReference Save() {
         System.debug(con);
         System.debug(testPicklist);
         insert con;
         pageReference pg = new PageReference('/apex/GuestFormSuccess');
         pg.setRedirect(true);
         return pg;
    }
     public pageReference Cancel() {
         pageReference pg = new PageReference('/apex/Booking_Form');
         pg.setRedirect(true);
         return pg;
    }
    
}