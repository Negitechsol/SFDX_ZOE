/**********************************************************************************************
@Description: Trigger to User_Infusion_Dates__c where there is insert action is performed
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
trigger CalendarActivities on User_Infusion_Dates__c (after insert,after update) {
    CalendarActivtiesTriggerHelper.afterInsertHelper(Trigger.New);
}