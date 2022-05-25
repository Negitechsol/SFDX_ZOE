/**********************************************************************************************
@Description: An apex page controller that exposes the External User Registration functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class ExternalUserRegistration {
    public static void createPortalUser(List<Id> contactids) {
        List<User> userList=new List<User>();
        set<String> setUserName = new set<String>();
        Map<String,Id> mapUserNameId = new Map<String,Id>();
        List<Contact> contactList=new List<Contact>();
        if (Schema.sObjectType.Contact.isAccessible()){
        contactList=[SELECT Id,Username__c,Email,LastName,FirstName,Matricula__c,Profession__c,Institution__c from Contact where ID IN :contactids];
		 if(Schema.sObjectType.Contact.isAccessible()){
        for(Contact objCon  : contactList) {
            if( objCon != null && objCon.Username__c != null ) {
            	setUserName.add(objCon.Username__c);
            }
        }
        }
        }
        if( setUserName != null && setUserName.size() > 0 && !setUserName.isEmpty() ) { 
             if(Schema.sObjectType.User.isAccessible()){
            for( User objUser : [Select Id,ContactId, Username from User where ContactId IN: contactids  ] ) {
                if( objUser != null &&  String.isNotBlank( objUser.Username ) && !mapUserNameId.containsKey(objUser.Username)
                  && objUser.ContactId != null ) {
                    mapUserNameId.put(objUser.Username,objUser.Id);
                }
            }
           }
        }
     
        string profession = contactList[0].Profession__c;        
        string userRole;
        if(profession.equals(ZOE_Constant.USER_PROFESSION_NEUROLOGIST) || profession.equals(ZOE_Constant.USER_PROFESSION_NEUROPEDIATRICIANS) || profession.equals(ZOE_Constant.USER_PROFESSION_PEDIATRICIAN)){
            userRole = ZOE_Constant.USER_ROLE_HCP;    
        }
        else if(profession.equals(ZOE_Constant.USER_PROFESSION_NURSE) || profession.equals(ZOE_Constant.USER_PROFESSION_OTHER)){
            userRole = ZOE_Constant.USER_ROLE_NURSE;    
        }
        else if(profession.equals(ZOE_Constant.USER_PROFESSION_PHARMACIST) || profession.equals(ZOE_Constant.USER_PROFESSION_PHARMA_TECHNICIAN)){
            userRole = ZOE_Constant.USER_ROLE_PHARMACIST;    
        }
        else {
            userRole = ZOE_Constant.USER_ROLE_FULLACCESS;   
        }
        
        if(Test.isRunningTest()){
            userRole= ZOE_Constant.USER_ROLE_TEST;
        }
        
         
        for(Contact objContact:contactList){
            if(  mapUserNameId != null &&  mapUserNameId.size() > 0 && !mapUserNameId.isEmpty()
               && mapUserNameId.containsKey(objContact.Username__c)) {
                   ZOE_LoginCntrl.forgotPassword(objContact.Username__c);
               }else{
                    User objUser = new User();
                    TimeZone tz = UserInfo.getTimeZone();
                
                   Boolean isCreateAccess = true;
                   Boolean isUpdateAccess = true;
                    String[] userFields = new String [] {'Username','Email','CommunityNickname','LastName','FirstName','ProfileId','ContactId','Matricula__c','Alias','EmailEncodingKey','TimeZoneSidKey','LocaleSidKey','LanguageLocaleKey'};
                    Map<String,Schema.SObjectField> mapSchema = Schema.SObjectType.User.fields.getMap();
                    for(String fieldToCheck : userFields) {
                        if(mapSchema.get(fieldToCheck) != null && (!mapSchema.get(fieldToCheck).getDescribe().isCreateable())) {
                            isCreateAccess = false;
                            break;
                        }
                        if(mapSchema.get(fieldToCheck) != null && (!mapSchema.get(fieldToCheck).getDescribe().isUpdateable())) {
                            isUpdateAccess = false;
                            break;
                        }
                    } 

                   
                   if(isCreateAccess && isUpdateAccess){
                   objUser.Username = objContact.Username__c;
                    objUser.Email = objContact.Email;
                    objUser.CommunityNickname = objContact.FirstName.substring(0,2)+objContact.LastName.substring(0,2);
                    objUser.LastName=objContact.LastName;
                    objUser.FirstName=objContact.FirstName;
                    objUser.ProfileId= UserInfo.getProfileId(); 
                    objUser.ContactId=objContact.Id;
                    objUser.Matricula__c=objContact.Matricula__c;
                    objUser.Alias=ZOE_Constant.USER_ROLE_TEST;
                    objUser.EmailEncodingKey=ZOE_Constant.STR_UTF;
                    objUser.TimeZoneSidKey = tz.getID();
                    objUser.LocaleSidKey = ZOE_Constant.STR_EN_US;
                    objUser.LanguageLocaleKey = ZOE_Constant.STR_EN_US;
                   }
                    userList.add(objUser);
               }
        }
        if( mapUserNameId.isEmpty() && !userList.isEmpty() && userList!=null && userList.size()>0){
            if(!Test.isRunningTest()){
                if(Schema.sObjectType.User.isCreateable() && Schema.sObjectType.User.isUpdateable()){
                Database.upsert(userList,true);
                }
            }
        }
    }
}