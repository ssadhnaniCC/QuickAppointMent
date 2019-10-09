public class GuestFormClass {
    public Contact con {get;set;}
    
    public GuestFormClass() {
        con = new Contact();
    }
    public pageReference Save() {
        insert con;
         pageReference pg    = new PageReference('/apex/GuestFormSuccess');
         pg.setRedirect(true);
         return pg;
    }
    public pageReference Cancel() {
         pageReference pg    = new PageReference('/apex/GuestForm');
         pg.setRedirect(true);
         return pg;
    }
}