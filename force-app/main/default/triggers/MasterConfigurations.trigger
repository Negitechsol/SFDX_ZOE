/**********************************************************************************************
@Description: Trigger that inserts the date from Master_Configuration__c
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
trigger MasterConfigurations on Master_Configuration__c (after insert, after update) {
    MasterConfigurationsTriggerHelper.afterUpdateHelper(Trigger.New);
}