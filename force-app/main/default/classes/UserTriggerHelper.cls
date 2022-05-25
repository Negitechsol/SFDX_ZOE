/**********************************************************************************************
@Description: Trigger that fires when record inserts to user
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class UserTriggerHelper {

public static void afterinsertHelper(List<User> users){
  List<User> user =new List<User>();
   set<string> lstUserName = new set<string>();
    if(trigger.isAfter && trigger.isInsert){
        for(user u :(List<User>) trigger.new){
            
            lstUserName.add(u.UserName);
        }
        if (Schema.sObjectType.User.isAccessible()){
   user = [SELECT Id, Name FROM User WHERE UserName In : lstUserName];
        }
   
   }      
}
}