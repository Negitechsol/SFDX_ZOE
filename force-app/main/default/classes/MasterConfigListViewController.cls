/**********************************************************************************************
@Description: An apex page controller that exposes the Master Configurations List View functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class MasterConfigListViewController {
    /*@Description: apex method to fetch wrapper of list view*/
    @AuraEnabled
    public static list<listViewWrapper> listValues(string objectInfo){
        
        list<listViewWrapper> oListViewWrapper = new list<listViewWrapper>();
        if(Schema.sObjectType.ListView.isAccessible()){ 
        for(ListView lv : [SELECT id, Name, DeveloperName FROM ListView
                           WHERE sObjectType = : objectInfo   ORDER By Name ASC ]){
                               listViewWrapper oWrapper = new listViewWrapper();
                               oWrapper.label = lv.Name;
                               oWrapper.developerName = lv.DeveloperName;
                               oListViewWrapper.add(oWrapper);
                           }
        }
        
        return oListViewWrapper;
    }
    
    /*@Description: wrapper class to store listView details*/
    public class listViewWrapper{
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string developerName{get;set;}
    }
    /*@Description: update Record type*/
    @AuraEnabled
    public static string updateRecordtype(Id recordId,String recordTypename) {
        RecordType recordType=new RecordType();
        Master_Configuration__c config=new Master_Configuration__c();
        try{
            recordType = [select Id,Name from RecordType where Name =:recordTypename WITH SECURITY_ENFORCED];
            config=[SELECT Id,recordtypeid FROM Master_Configuration__c WHERE Id=:recordId WITH SECURITY_ENFORCED];
            config.recordtypeid = recordType.Id;
            if (Schema.sObjectType.Master_Configuration__c.isUpdateable()){
            update config;
            }
            return null;    
        }catch(Exception e){
            return null;
        }
        
    }
    //@Description: To Get Specific Fields from Master_Configuration__c
    @AuraEnabled
    public static List<string> getSpecificFields(String PageLayoutName) {
        try{
            List<string> fields=new List<string>();
            List<Metadata.Metadata> layouts = 
                Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
                                             new List<String> {PageLayoutName});
          Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
            for (Metadata.LayoutSection section : layoutMd.layoutSections) {
                for (Metadata.LayoutColumn column : section.layoutColumns) {
                    if (column.layoutItems != null) {
                        for (Metadata.LayoutItem item : column.layoutItems) {
                            fields.add(item.field);
                        }
                    }
                }
            }
            return fields;
        }catch(Exception e){
            return new String[0];
        }
        
    }
}