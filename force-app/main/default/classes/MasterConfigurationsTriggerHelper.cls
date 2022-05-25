/**********************************************************************************************
@Description: Trigger that inserts the date from Master_Configuration__c
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/

public with sharing class MasterConfigurationsTriggerHelper {
    public static void afterUpdateHelper(list<Master_Configuration__c>  mc_List){
//trigger MasterConfigurations on Master_Configuration__c (after insert,after update) {
  //  list<Master_Configuration__c>  mc_List=trigger.new;
    List<Audit_Log__c> lstAudit = new List<Audit_Log__c>();
    String eventName='';
    if(Trigger.isInsert && Trigger.isAfter)
	   eventName='Insert';
	if(Trigger.isUpdate && Trigger.isAfter)
		eventName='Update';
    Audit_Log__c objAudit_Log = MasterConfigController.createAuditRecord(mc_List[0].Id,JSON.serialize(trigger.new),'Master_Configuration__c',eventName);
    lstAudit.add(objAudit_Log);
    if( (!lstAudit.isEmpty() && lstAudit.size() > 0) && (Schema.sObjectType.Audit_Log__c.fields.Id.isCreateable()) ) {
       insert lstAudit;
    }
}
}