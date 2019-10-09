/**
    Name: AddColorDashboard
    Description:
*/
public with sharing class AddColorDashboard{
    public UIpanel__c UIPanelData{get;set;}
    public string LogoColor{get;set;}
    public string HeaderBgColor{get;set;}
    public string LeftPanelBgColor{get;set;}
    public string NavigationSide{get;set;}
    public string NavigationType{get;set;}
    public string SideBarEffect{get;set;}
    public string SidebarPosition{get;set;}
    
    public string logovalue{get;set;}
    public string headervalue{get;set;}
    public string leftpanelvalue{get;set;}
    public string navigationvalue{get;set;}
    public string navsidevalue{get;set;}
    public string Sidebar{get;set;}
    
    public string selectedUpcoming{get;set;}
    public string selectedRunning{get;set;}
    public string selectedCompleted{get;set;}
    public string selectedDeclined{get;set;}
    public boolean debuleBooking{get;set;}
    
    public boolean AppName{get;set;}
    public boolean AppDiscription{get;set;}
    public boolean Appstatus{get;set;}
    public boolean AppCapacity{get;set;}
    
    
    
    public AddColorDashboard(){
        UIpanel__c UIPanelData = UIpanel__c.getInstance(Userinfo.getUserid());
        LogoColor = UIPanelData.Logo_Color_BG__c;
        HeaderBgColor = UIPanelData.Header_BG_Color__c;
        system.debug('bgcolor'+HeaderBgColor );
         
        LeftPanelBgColor = UIPanelData.Left_Panel_BG_Color__c;
        system.debug('custom setting value navsidevalue'+UIPanelData.Navigation_Side__c);
        NavigationSide = UIPanelData.Navigation_Side__c;
        NavigationType = UIPanelData.Navigation_Type__c;
        SideBarEffect = UIPanelData.SideBar_Effect__c;
        SidebarPosition = UIPanelData.Sidebar_Position__c;
        
        
        selectedUpcoming = UIPanelData.Status_Upcoming__c;
        selectedRunning = UIPanelData.Status_Running__c;
        selectedCompleted = UIPanelData.Status_Completed__c;
        selectedDeclined = UIPanelData.Status_Declined__c;
        debuleBooking = UIPanelData.dobule_booking__c;
        
        AppName = UIPanelData.Appointment_Name__c;
        AppDiscription = UIPanelData.Description__c;
        Appstatus = UIPanelData.Status__c;
        AppCapacity = UIPanelData.Capacity__c;
        
    }
    public pagereference saveDashboard(){
        System.debug(logovalue+'---'+headervalue+'---'+leftpanelvalue+'---'+navigationvalue+'---'+navsidevalue+'ssss---'+Sidebar);
        UIPanelData = UIpanel__c.getInstance(Userinfo.getUserid());
        UIPanelData.Logo_Color_BG__c =logovalue;
        UIPanelData.Header_BG_Color__c =headervalue;
        UIPanelData.Left_Panel_BG_Color__c =leftpanelvalue;
        UIPanelData.Navigation_Side__c =navsidevalue;
        UIPanelData.Navigation_Type__c =navigationvalue;
        UIPanelData.Sidebar_Position__c = Sidebar;
        
        UIPanelData.Status_Upcoming__c = selectedUpcoming;
        UIPanelData.Status_Running__c = selectedRunning;
        UIPanelData.Status_Completed__c = selectedCompleted;
        UIPanelData.Status_Declined__c = selectedDeclined;
        
        UIPanelData.dobule_booking__c = debuleBooking;
        
        UIPanelData.Appointment_Name__c = AppName;
        UIPanelData.Description__c = AppDiscription;
        UIPanelData.Status__c = Appstatus;
        UIPanelData.Capacity__c = AppCapacity;
        update UIPanelData;
        
        return new pagereference('/apex/CC_QAppt__SettingPage');
        
    }
    
    public List<SelectOption> getColorList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Gray','select color'));
        options.add(new SelectOption('blue','Blue'));
        options.add(new SelectOption('Teal','Teal'));
        options.add(new SelectOption('green','Green'));
        options.add(new SelectOption('red','Red'));
        options.add(new SelectOption('Gray','Gray'));
        options.add(new SelectOption('LightSalmon','LightSalmon'));
        
         return options;
    }
   
}