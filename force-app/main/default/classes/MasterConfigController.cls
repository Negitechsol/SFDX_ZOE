/**********************************************************************************************
@Description: An apex page controller that exposes the ZOE Master Configurations
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class MasterConfigController {
    
    //@Description: This method used get Dosage Details from Master Configurations
    @AuraEnabled
    public static Map<String,String> getDosage() {
        Map<String,String> dosages=new Map<String,String>();
         if(Schema.sObjectType.Master_Configuration__c.isAccessible()){
        List<Master_Configuration__c> zkitDosage=[select Start_Weight__c, End_Weight__c, Dosage__c,Weight_Range__c,Vial5_5__c,Vial8_3__c,Viales_Totales__c,name from Master_Configuration__c where RecordType.Name=:ZOE_Constant.MC_Z_KIT order by name];
        for(Master_Configuration__c masterConfig:zkitDosage){
            if(masterConfig.Weight_Range__c!=null && masterConfig.Vial5_5__c!=null && masterConfig.Vial8_3__c!=null && masterConfig.Viales_Totales__c!=null){
                String dosage= String.valueOf(masterConfig.Vial5_5__c)+'-'+String.valueOf(masterConfig.Vial8_3__c)+'-'+String.valueOf(masterConfig.Viales_Totales__c);
                dosages.put(masterConfig.Weight_Range__c,dosage);
            }
        }
         }
        FeatureUsage.insertFeatureUsage(ZOE_Constant.MC_Z_KIT);
        return dosages;
    }
    
    //@Description: This method used get Training Links
    @AuraEnabled
    public static List<Master_Configuration__c> gettrainings() {
       
        
        List<Master_Configuration__c> trainings=[select Id,Description__c,Training_Name__c,Link__c,Type__c from Master_Configuration__c where RecordType.Name=:ZOE_Constant.MC_TRAINING];
        return trainings;
    }
    
    //@Description: This method used get Institution Names
    @AuraEnabled
    public static List<Master_Configuration__c> getInstitutionName() {
        
        try {
            List<Master_Configuration__c> institutionCenters=[select Id,Institution_Name__c from Master_Configuration__c where RecordType.Name=:ZOE_Constant.MC_INSTITUTIONS];
            return institutionCenters;
        }
        catch (Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
    
    //@Description: This method used for insert Feature usage
    @AuraEnabled
    public static void updateFeatureUsage( String eventName ){
        FeatureUsage.insertFeatureUsage(eventName);
    }
    
      //@Description: This method is used to get the correct answers for Quiz 
    @AuraEnabled
    public static Integer getSelectedOptions( String value1, String value2, String value3, String value4 ){
       
        try {
            List<string>lstvaluecount = new list<string>();
            
            if(value1 == Label.Quiz1Ques1 )
            {
                lstvaluecount.add(value1);
            }
            if(value2 == Label.Quiz1Ques2)
            {
                lstvaluecount.add(value2);
            }
            if(value3 == Label.Quiz1Ques3)
            {
                lstvaluecount.add(value3);
            }
            if(value4 == Label.Quiz1Ques4)
            {
                lstvaluecount.add(value4);
            }
            return lstvaluecount.size();
        }
        catch (Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
     @AuraEnabled
    public static Integer getSelectedOptions2( String value1, String value2, String value3, String value4, String value5, String value6, String value7 ){
       
        try {
            List<string>lstvaluecount = new list<string>();
            
            if(value1 == Label.Quiz2Ques1 )
            {
                lstvaluecount.add(value1);
            }
            if(value2 == Label.Quiz2Ques2)
            {
                lstvaluecount.add(value2);
            }
            if(value3 == Label.Quiz2Ques3)
            {
                lstvaluecount.add(value3);
            }
            if(value4 == Label.Quiz2Quiz4)
            {
                lstvaluecount.add(value4);
            }
            if(value5 == Label.Quiz2Quiz5)
            {
                lstvaluecount.add(value5);
            }
            if(value6 == Label.Quiz2Quiz6)
            {
                lstvaluecount.add(value6);
            }
            if(value7 == Label.Quiz2Ques7)
            {
                lstvaluecount.add(value7);
            }
            return lstvaluecount.size();
        }
        catch (Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
    
    
  // This method used for user transactions audit
    public static Audit_Log__c createAuditRecord( String strObjectId 
                                                 , String strJson 
                                                 , String strObjectName
                                                 , String strTransType ) {
                                                     if(Schema.sObjectType.Audit_Log__c.isCreateable()){
                                                     Audit_Log__c objAudit_Log = new Audit_Log__c();
                                                     if( String.isNotBlank( strObjectId )  ) {
                                                         if(Schema.sObjectType.Audit_Log__c.fields.Object_Id__c.isCreateable())
                                                         objAudit_Log.Object_Id__c = strObjectId;
                                                     }
                                                     if( String.isNotBlank( strJson )  ) {
                                                       if(Schema.sObjectType.Audit_Log__c.fields.Object_json__c.isCreateable())
                                                         objAudit_Log.Object_json__c = strJson;
                                                     }
                                                     if( String.isNotBlank( strObjectName )  ) {
                                                         if(Schema.sObjectType.Audit_Log__c.fields.Object_Name__c.isCreateable())
                                                         objAudit_Log.Object_Name__c = strObjectName;
                                                     }
                                                     if( String.isNotBlank( strTransType )  ) {
                                                        if(Schema.sObjectType.Audit_Log__c.fields.Transaction_Type__c.isCreateable())
                                                         objAudit_Log.Transaction_Type__c = strTransType;
                                                     }
                                                     
                                                     return objAudit_Log;
                                                     }
                                                     return null;
                                                 }  
    
    
   @AuraEnabled
    public static Integer getSelectedOptions3( String value1, String value2, String value3, String value4, String value5, String value6 ){
       
        try {
            List<string>lstvaluecount = new list<string>();
            if(value1 == Label.Quiz3Ques1 )
            {
                 
                lstvaluecount.add(value1);
            }
            if(value2 == Label.Quiz3Ques2)
            {
                 
                lstvaluecount.add(value2);
            }
            if(value3 == Label.Quiz3Ques3)
            {
               
                lstvaluecount.add(value3);
            }
            if(value4 == Label.Quiz3Ques4)
            {
                
                lstvaluecount.add(value4);
            }
            if(value5 == Label.Quiz3Ques)
            {
               
                lstvaluecount.add(value5);
            }
            if(value6 == Label.Quiz3Ques6)
            {
                 
                lstvaluecount.add(value6);
            }
           
            return lstvaluecount.size();
        }
        catch (Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
   
}