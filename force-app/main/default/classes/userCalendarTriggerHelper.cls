public with sharing class userCalendarTriggerHelper {
    /**********************************************************************************************
@Description: Trigger that fires when record inserts to User_Calendar__c
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public static void afterInsertHelper( list<User_Calendar__c>  userCalendarList) {
     List<Audit_Log__c> lstAudit = new List<Audit_Log__c>();
     //list<User_Calendar__c>  userCalendarList=trigger.new;
     List<Notification__c> notificationList=new List<Notification__c>();
    User activeUser = new User();
        for (User_Calendar__c usercal : userCalendarList) {
             Audit_Log__c objAudit_Log = MasterConfigController.createAuditRecord(usercal.Id,JSON.serialize(usercal),'User_Calendar__c','Insert');
             lstAudit.add(objAudit_Log);
             if(usercal != null && usercal.Event_Type__c != null && usercal.Event_Type__c.equals('CALENDAR') && usercal.Calendar_email_template__c !=null && usercal.Calendar_email_template__c!=''){
                     String userName = UserInfo.getUserName();
                 if (Schema.sObjectType.User.isAccessible()){
                      activeUser = [Select Email From User where Username = : userName limit 1];
                 }
                     String userEmail = activeUser.Email;
                     String scheduleDate=usercal.First_Notification_Date__c;
                     Date scheduleDt=Date.valueOf(scheduleDate);
                     Notification__c notification=new Notification__c();
                     if(Schema.sObjectType.Notification__c.fields.Email__c.isCreateable())
                     notification.Email__c=userEmail;
                     if(Schema.sObjectType.Notification__c.fields.Email_Type__c.isCreateable())
                     notification.Email_Type__c=usercal.Calendar_email_template__c;
                     if(Schema.sObjectType.Notification__c.fields.RecordId__c.isCreateable())
                     notification.RecordId__c=usercal.id;
                     if(Schema.sObjectType.Notification__c.fields.Trigger_DateTime__c.isCreateable())
                     notification.Trigger_DateTime__c=scheduleDt;
                     notificationList.add(notification);
                 if(usercal.Second_Notification_Date__c !=null && usercal.Second_Notification_Date__c!=''){
                     scheduleDate=usercal.Second_Notification_Date__c;
                     scheduleDt=Date.valueOf(scheduleDate);
                     Notification__c notification2=new Notification__c();
                     if(Schema.sObjectType.Notification__c.fields.Email__c.isCreateable())
                     notification2.Email__c=userEmail;
                     if(Schema.sObjectType.Notification__c.fields.Email_Type__c.isCreateable())
                     notification2.Email_Type__c=usercal.Calendar_email_template__c;
                     if(Schema.sObjectType.Notification__c.fields.RecordId__c.isCreateable())
                     notification2.RecordId__c=usercal.id;
                     if(Schema.sObjectType.Notification__c.fields.Trigger_DateTime__c.isCreateable())
                     notification2.Trigger_DateTime__c=scheduleDt;
                     notificationList.add(notification2);
                 }
           	}
          }
          if(notificationList.size() > 0 && Schema.sObjectType.Notification__c.isCreateable()){
                 insert notificationList;
          }
          if( !lstAudit.isEmpty() && lstAudit.size() > 0 && Schema.sObjectType.Audit_Log__c.isCreateable() ) {
              
                insert lstAudit;
              
          }
}

}