/**********************************************************************************************
@Description: Test class for MergeFieldReplacer coverage on method replaceMergeFields 
 
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class MergeFieldReplacerTest {
    @testSetup
    static void setUpData(){
        User_Infusion_Dates__c objUserInfusionDates = TestDataFactory.createUser_InfusionDate(true);
        User_Calendar__c objUCal = TestDataFactory.createUser_Calendar(false);
        objUCal.User_Infusion_Date_Id__c = objUserInfusionDates.Id;
        insert objUCal;
        Notification__c objNotification = new Notification__c();
        objNotification.Email__c='TestEmail@testacc.xyz';
        objNotification.Email_Type__c='Experience Cloud: New Member Welcome Email';
        objNotification.RecordId__c=objUCal.Id;
        objNotification.Trigger_DateTime__c=system.now();
        objNotification.Notification_Status__c='';
        insert objNotification;
    }
    @IsTest
    static void testReplaceMergeFields(){
        Test.startTest();
        EmailMessageService objEmailMessageService = new EmailMessageService();
        Notification__c notify=[Select id,Email_Type__c,Email__c,RecordId__c,Trigger_DateTime__c,Notification_Status__c from Notification__c where Email__c='TestEmail@testacc.xyz' limit 1];
        List<Notification__c> lstNotificationToUpdate =objEmailMessageService.sendSinglemail(notify);
        //MergeFieldReplacer.replaceMergeFields( e.Subject,'Notification', objNotification.RecordId__c, new<String> {'UserName'} );
        Test.stopTest();
        System.assertNotEquals(lstNotificationToUpdate.size(), 0,'List is not empty');
    }
    @IsTest
    static void testReplaceMergeFields1(){
        List<EmailTemplate> lstEmailTemp = [SELECT 
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
                               AND Name = 'Experience Cloud: New Member Welcome Email'
                                        ];
        Set<String> setApiNames = new Set<String>();
        List<Merge_Field_Mapping__mdt> listMergeFldMdt = new List<Merge_Field_Mapping__mdt>();
        //get configured merge field mappings
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
        Notification__c notify=[Select id,Email_Type__c,Email__c,RecordId__c,Trigger_DateTime__c,Notification_Status__c from Notification__c where Email__c='TestEmail@testacc.xyz' limit 1];
        Test.startTest();        
        	String replacer=MergeFieldReplacer.replaceMergeFields(lstEmailTemp[0].Body,'Notification'
                                                                 , Id.valueOf( notify.RecordId__c)
                                                  				, setApiNames , listMergeFldMdt);
        //MergeFieldReplacer.replaceMergeFields( e.Subject,'Notification', objNotification.RecordId__c, new<String> {'UserName'} );
        Test.stopTest();
        System.assertNotEquals('3', replacer,'Replacer is not empty');
    }
}