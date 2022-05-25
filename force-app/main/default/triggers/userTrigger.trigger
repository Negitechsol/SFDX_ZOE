/**********************************************************************************************
@Description: Trigger that fires when record inserts to user
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
trigger userTrigger on User (after insert) {
    UserTriggerHelper.afterinsertHelper(Trigger.New);
}