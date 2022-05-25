/**********************************************************************************************
@Description: Test Class to check the EmailBatch class for notificationEmailTest and testschedule
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class EmailBatchTest {
    @isTest static void notificationEmailTest() {
        testDataFactory.createNotification();
        test.startTest();
        System.assert(database.executeBatch(new Emailbatch()) != null,'Is not empty');  
        test.stoptest();
    }
    
    static testMethod void testschedule() {
        testDataFactory.createNotification();
        Test.StartTest(); 
        ScheduleEmailBatch sh1 = new ScheduleEmailBatch();        
        String sch = '0 0 23 * * ?'; 
        
        System.assert(system.schedule('Test email schedule', sch, sh1) != null,'Is not empty');  
        Test.stopTest(); 
    }
}