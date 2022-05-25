/**********************************************************************************************
@Description: Trigger that fires when record inserts to User_Calendar__c
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
trigger usercalendar on User_Calendar__c (after insert) {
     userCalendarTriggerHelper.afterInsertHelper(Trigger.New);
}