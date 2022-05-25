/**********************************************************************************************
@Description: Trigger that inserts the date from Pending_Registrations__c
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
trigger PendingRegistrationTrigger on Pending_Registrations__c (before update) {
    PendingRegistrationTriggerHelper.beforeUpdateHelper(Trigger.New);
}