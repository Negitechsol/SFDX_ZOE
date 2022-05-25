/**********************************************************************************************
@Description: Test class for ScheduleEmailBatch coverage on method getUserCalendarEvents
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class ScheduleEmailBatchTest {
    @testSetup
    static void setUpData(){
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User objUser = new User(Alias = 'standt', Email='standarduser@novartis.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = objProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest@novartis.com');
		insert objUser;
    }
    static testmethod void getUserCalendarEventsNegativeTest() {
        //@Description: Setup test data
        //@Description: This code runs as the system user
        
        User user= [Select id from User where UserName='standardusertest@novartis.com' Limit 1];
        System.runAs(user) {
            Test.StartTest();
				List<User_Calendar__c> lstUserCalendar =  UserCalendarController.getUserCalendarEvents(user.Id);
            	system.assertEquals(0, lstUserCalendar.size(),'Calendar size is equals to zero');
            Test.StopTest();
        }
    }
}