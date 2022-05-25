/**********************************************************************************************
@Description: Batch to send reminder email to user
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public class EmailBatch implements Database.Batchable<sObject>
, Database.AllowsCallouts
, Database.Stateful {
    
    
    List<Notification__c> lstNotificationToUpdate;
    transient List<Messaging.SingleEmailMessage> lstEmails;
    
    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        return Database.getQueryLocator([SELECT 
                                         Id
                                         , Name
                                         , Trigger_DateTime__c
                                         , Email_Type__c
                                         , Notification_Status__c
                                         , Email__c
                                         , RecordId__c
                                         FROM 
                                         Notification__c
                                         WHERE  
                                         Trigger_Date__c = TODAY
                                         AND 
                                         Notification_Status__c = ''] ); 
        
    }
    //@description: Code we will send batch emails                                                
    public void execute(Database.BatchableContext batchContext, List<Notification__c> scope){
        if( !scope.isEmpty() && scope.size() > 0  ) {
            lstNotificationToUpdate = new List<Notification__c>();
            lstEmails = new List<Messaging.SingleEmailMessage>();
            EmailMessageService.EmailMessageWrapper objEmailMessageWrapper = new EmailMessageService.EmailMessageWrapper();
            EmailMessageService objEmailMessageService = new EmailMessageService();
            
            for( Notification__c objNotification : scope ) {
                objEmailMessageWrapper = objEmailMessageService.sendmail( objNotification );
                if( !objEmailMessageWrapper.lstNotificationToUpdate.isEmpty() ) {
                    lstNotificationToUpdate.addAll(objEmailMessageWrapper.lstNotificationToUpdate);
                }
                if( !objEmailMessageWrapper.lstEmails.isEmpty() ) {
                    lstEmails.addAll(objEmailMessageWrapper.lstEmails);
                }
            }
            if(!Test.isRunningTest()) {
                Messaging.sendEmail(lstEmails);
            }
            
            //@description: Update call count on calling list
            if( !lstNotificationToUpdate.isEmpty() ) {
                update lstNotificationToUpdate;
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
}