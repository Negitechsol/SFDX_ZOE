/**********************************************************************************************
@Description: An apex page controller that exposes the Feature Usage functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class FeatureUsage {
    //@Description: This method used insert Feature Usage details
    @AuraEnabled
    public static void insertFeatureUsage(String functionality) {
    
            String currentUser=UserInfo.getUserId();
            Feature_Usage__c feature=new Feature_Usage__c();
            feature.Functionality__c= functionality;
            feature.Used_By__c=currentUser;
            if (Schema.sObjectType.Feature_Usage__c.isCreateable()){
            insert feature;            
            
            }
        
    }
}