/**********************************************************************************************
@Description: This Class will schedule the email nofication sending functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class ScheduleEmailBatch Implements Schedulable  {
     public void execute(SchedulableContext schedulableContext){
       	EmailBatch batchInst = new EmailBatch();
        Database.executeBatch(batchInst);
    }
}