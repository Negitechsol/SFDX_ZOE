/**********************************************************************************************
@Description: An apex page controller that Header functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class ZOEHeaderController {
    //@Description: This Methos used to ger loggedi  in user role
    @AuraEnabled
    public static Map<String,Boolean> currentUserRole() {
        Map<String,Boolean> mapLinkBln = new Map<String, Boolean>();
        User currentUserInfo =new User();
        if (Schema.sObjectType.User.isAccessible()){
        currentUserInfo = [select Id,Name,UserRoleId,UserRole.name from User where Id = :UserInfo.getUserId()];
        }
        //@Description:get configured merge field mappings
        if(Schema.sObjectType.RBAC__mdt.isAccessible()){
        for( RBAC__mdt mdtRbac : [ SELECT
                                  Id
                                  , MasterLabel
                                  , Roles__c
                                  FROM
                                  RBAC__mdt
                                  WHERE
                                  Process_Name__c =:ZOE_Constant.META_ZOE] ) {                                      
                                      List<String> lstRoles = mdtRbac.Roles__c.split(',');
                                      Set<String> setRoles = new Set<String>(lstRoles);
                                      if( setRoles.contains( currentUserInfo.UserRole.name)  ) {
                                          if(!mapLinkBln.containsKey(mdtRbac.MasterLabel)) {
                                              mapLinkBln.put(mdtRbac.MasterLabel,true);
                                          }           
                                      }else{
                                          mapLinkBln.put(mdtRbac.MasterLabel,false);
                                      }
                                  }
    }
        /*mapLinkBln.put('CALENDAR',true);
        mapLinkBln.put('Configuration',true);
        mapLinkBln.put('Dashboard',true);
        mapLinkBln.put('Infusion',true);
        mapLinkBln.put('LABTRACKER',true);
        mapLinkBln.put('PostInfusion',true);
        mapLinkBln.put('PreInfusion',true);
        mapLinkBln.put('Training',true);
        mapLinkBln.put('ZKIT',true);*/
        //@Description:return currentUserInfo.UserRole.name ;
        return mapLinkBln;    
    }
    //@Description: This methos used to get current language selected
    @AuraEnabled
    public static string currentLanguage() {
        string displayLanguage = Test.isRunningTest()?'Spanish':(string)Cache.Session.get('currentLanguage');        
        if(string.isBlank(displayLanguage)){
            displayLanguage = 'Spanish';    
        }
        return displayLanguage;
    }
    //@Description: This methos used to handle change language
    @AuraEnabled
    public static void changeLang(String newLanguage) {
        if(test.isRunningTest()==false){
            Cache.Session.put('currentLanguage', newLanguage);    
        }   	
    }
}