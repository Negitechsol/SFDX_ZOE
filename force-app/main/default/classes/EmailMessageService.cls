/**********************************************************************************************
@description: Service class to send email using Messaging.SingleEmailMessage SFDC method
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class EmailMessageService {
    private Map<String,EmailTemplate> mapEmailTemplates;
    private Set<String> setApiNames;
    private List<Merge_Field_Mapping__mdt> listMergeFldMdt;
    public EmailMessageService() {
        getConfigs();
    }
    //@description: Code we will get the email templates configurations
    public void getConfigs() {
        mapEmailTemplates = new Map<String,EmailTemplate>();
        setApiNames = new Set<String>();
        listMergeFldMdt = new List<Merge_Field_Mapping__mdt>();
        
        //@description:Get All Notification folder Email Template
        if(Schema.sObjectType.EmailTemplate.isAccessible()){
        for( EmailTemplate templateObj : [SELECT 
                                          Id
                                          , Name  
                                          , Subject  
                                          , Body
                                          , HtmlValue
                                          , TemplateType
                                          FROM 
                                          EmailTemplate 
                                          WHERE 
                                          Folder.Name = 'Notification'
                                         ]) {
                                             if( !mapEmailTemplates.containsKey( templateObj.Name ) ) {
                                                 mapEmailTemplates.put( templateObj.Name , templateObj );
                                             }     
                                         }
                                         }
        
        //@description:get configured merge field mappings
        if(Schema.sObjectType.Merge_Field_Mapping__mdt.isAccessible()){
        for( Merge_Field_Mapping__mdt mdt : [ SELECT
                                             Field_API_Name__c
                                             , Merge_Field__c
                                             , Process_Name__c
                                             , Priority_Order__c
                                             FROM
                                             Merge_Field_Mapping__mdt
                                             WHERE
                                             Process_Name__c = 'Notification'
                                             ORDER BY 
                                             Priority_Order__c ASC ] ) {
                                                 setApiNames.add( mdt.Field_API_Name__c );
                                                 listMergeFldMdt.add( mdt );
                                             }
    }
    }
    
    //@description: Code we will send Single mail
    public List<Notification__c> sendSinglemail( Notification__c objNotification ) {
        List<Notification__c> lstNotificationToUpdate = new List<Notification__c>();
        EmailMessageWrapper objEmailMessageWrapper = sendmail( objNotification );
        if( !objEmailMessageWrapper.lstNotificationToUpdate.isEmpty() ) {
            lstNotificationToUpdate.addAll(objEmailMessageWrapper.lstNotificationToUpdate);
        }
        if( !objEmailMessageWrapper.lstEmails.isEmpty() ) {
            if(!Test.isRunningTest()) {
                Messaging.sendEmail(objEmailMessageWrapper.lstEmails);
            }
        }
        return lstNotificationToUpdate;
    }
    
    //@description: Code we will send mail
    public EmailMessageWrapper sendmail( Notification__c objNotification ) {
        
        EmailMessageWrapper objEmailMessageWrapper = new EmailMessageWrapper();
        if( objNotification != null ) {
            EmailTemplate objEmailTemplate = new EmailTemplate();
            List<Notification__c> lstNotificationToUpdate = new List<Notification__c>();
            List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
            
            if( mapEmailTemplates != null && mapEmailTemplates.size() > 0 
               && String.isNotBlank( objNotification.Email_Type__c ) 
               && mapEmailTemplates.containsKey( objNotification.Email_Type__c ) ) {
                   objEmailTemplate = mapEmailTemplates.get( objNotification.Email_Type__c );
               }
            
            Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();
            //@description:Prepare SendToEmail List          
            List<String> lstSendToEmails = new List<String>();
            if(objNotification.Email__c != null) {
                lstSendToEmails.add(objNotification.Email__c);
            }
            objEmail.setToAddresses(lstSendToEmails);
            
            //@description:Set Email Subject
            String strSub = MergeFieldReplacer.replaceMergeFields( objEmailTemplate.Subject, 'Notification'
                                                                  , Id.valueOf( objNotification.RecordId__c) 
                                                                  , setApiNames , listMergeFldMdt);
            objEmail.setSubject(strSub);
            
            //@description:Set Email Body
            String contentValue = MergeFieldReplacer.replaceMergeFields( objEmailTemplate.HtmlValue, 'Notification'
                                                                        , Id.valueOf( objNotification.RecordId__c) 
                                                                        , setApiNames , listMergeFldMdt);
            String contentBody = MergeFieldReplacer.replaceMergeFields( objEmailTemplate.Body, 'Notification'
                                                                       , Id.valueOf( objNotification.RecordId__c) 
                                                                       , setApiNames , listMergeFldMdt);
            if( String.isNotBlank(contentValue)) {
                objEmail.setHtmlBody(contentValue);
            }else if ( String.isNotBlank(contentBody)) {
                objEmail.setPlainTextBody(contentBody);
            }
            
            objEmail.setsaveasactivity(true);
            objEmail.setWhatId(objNotification.Id);
            
            lstEmails.add(objEmail);
            if(Schema.sObjectType.Notification__c.fields.Notification_Status__c.isUpdateable())
            objNotification.Notification_Status__c = 'Sent';
            lstNotificationToUpdate.add(objNotification);
            
            objEmailMessageWrapper.lstEmails = lstEmails;
            if(Schema.sObjectType.Notification__c.isUpdateable())
            objEmailMessageWrapper.lstNotificationToUpdate = lstNotificationToUpdate;
        }
        return objEmailMessageWrapper;
    }
    
    //@description: This is our wrapper/container class
    public class EmailMessageWrapper {
        public transient List<Messaging.SingleEmailMessage> lstEmails {get;set;}
        public transient List<Notification__c> lstNotificationToUpdate {get;set;}
    }
}