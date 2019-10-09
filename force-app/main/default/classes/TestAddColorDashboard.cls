@isTest 
public class TestAddColorDashboard{
    static testMethod void UnitTest() {
        UIpanel__c ObjUi = new UIpanel__c();
        objUI.Logo_Color_BG__c = 'logo-bg2';
        objUI.Header_BG_Color__c = 'header-bg1';
        objUI.SetupOwnerId= Userinfo.getUserId();
        insert objUI;
          System.assertEquals(objUI.SetupOwnerId,Userinfo.getUserId());
        AddColorDashboard obj = new AddColorDashboard();
        obj.getColorList();
        obj.saveDashboard();
    }
}