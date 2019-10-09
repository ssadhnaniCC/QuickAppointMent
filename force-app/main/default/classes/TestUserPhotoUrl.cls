@isTest 
public class TestUserPhotoUrl{
    static testMethod void UnitTest() {
        User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:Userinfo.getUserid()];
        
        UserPhotoUrl objUser = new UserPhotoUrl();
        objUser.Photolink = u.FullPhotoUrl;
        objUser.userName = Userinfo.getName();
        system.assertEquals(objUser.userName,Userinfo.getName());
    }
}