Public with sharing class UserPhotoUrl{

    public string Photolink{get;set;}
    public string userName{get;set;}
    Public UserPhotoUrl(){
         if(Schema.sObjectType.User.fields.SmallPhotoUrl.isAccessible() && Schema.sObjectType.User.fields.FullPhotoUrl.isAccessible()){
             User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:Userinfo.getUserid()];
             Photolink = u.FullPhotoUrl;
             userName = UserInfo.getName();
         }
    }
    
}