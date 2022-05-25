/**********************************************************************************************
@Description: An apex page controller that exposes the New Infusion date Create functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class NewInfusionDateCntrl {
    //@Description: This method used to Save New Infusion Data
    @AuraEnabled
    public static User_Infusion_Dates__c saveInfuDate(String name, Date dateInfu) {
       
        User_Infusion_Dates__c objUserInfusionDates = new User_Infusion_Dates__c();
        String encName=CryptoEncryptDecrypt.getEncryptedValue(name);
        objUserInfusionDates.Name = encName;
        objUserInfusionDates.Infusion_Date__c = dateInfu;
        objUserInfusionDates.Status__c = 'active';
        if(Schema.sObjectType.User_Infusion_Dates__c.isCreateable()){
        insert objUserInfusionDates;
        }
        List<User_Infusion_Dates__c> userInfList =new List<User_Infusion_Dates__c>();
        if (Schema.sObjectType.User_Infusion_Dates__c.isAccessible()){
          userInfList = [SELECT Id,Name,Infusion_Date__c,Patient_Reference_ID__c,Status__c FROM User_Infusion_Dates__c WHERE Id=:objUserInfusionDates.Id ];
        }
            return userInfList[0];
    }
    //@Description: This method used to Save New Infusion Data
    @AuraEnabled
    public static User_Infusion_Dates__c updateInfuDate(String name, Date dateInfu,String delpatient,String InfusionDateId) {
       
        List<User_Infusion_Dates__c> lstInfusionDate = new List<User_Infusion_Dates__c>();
        lstInfusionDate = [SELECT Id,Name,Infusion_Date__c,Patient_Reference_ID__c,Status__c FROM User_Infusion_Dates__c WHERE Id=:InfusionDateId ];
        String encName=CryptoEncryptDecrypt.getEncryptedValue(name);
        if(lstInfusionDate.size() > 0){
            if(Schema.sObjectType.User_Infusion_Dates__c.fields.name.isUpdateable())
            lstInfusionDate[0].name=encName;
            if(Schema.sObjectType.User_Infusion_Dates__c.fields.Infusion_Date__c.isUpdateable())
            lstInfusionDate[0].Infusion_Date__c=dateInfu;
            if(('true').equals(delpatient)){
                if(Schema.sObjectType.User_Infusion_Dates__c.fields.Status__c.isUpdateable())
                lstInfusionDate[0].Status__c='inactive';
            }
            if(Schema.sObjectType.User_Infusion_Dates__c.isUpdateable()){
            update lstInfusionDate[0];
            }
        }

        
        return lstInfusionDate[0];
    }
    
    //@Description:This Method used to get Patient Infusion Dates by logged in user id
    @AuraEnabled
    public static Map<String, String> getPatientMap( String userId ) {
        Map<String, String> mapIdNamePatientId = new Map<String, String>();
        if( String.isNotBlank(userId)) {
             if(Schema.sObjectType.User_Infusion_Dates__c.isAccessible()){ 
            for(User_Infusion_Dates__c objUser_Infusion_Dates : [SELECT Id
                                                                 , Name
                                                                 , Patient_Reference_ID__c,Infusion_Date__c
                                                                 FROM User_Infusion_Dates__c 
                                                                 WHERE OwnerId =: userId and Status__c='active']) {
                                                                      String pName=objUser_Infusion_Dates.Name;
                                                                      String strName = pName + ' - ' + objUser_Infusion_Dates.Patient_Reference_ID__c;
                													if(pName.length() > 36){
                                                                     String decryptName=CryptoEncryptDecrypt.getDecryptedValue(pName);
                                                                     strName = decryptName + ' - ' + objUser_Infusion_Dates.Patient_Reference_ID__c;
                                                                     mapIdNamePatientId.put(objUser_Infusion_Dates.Id, strName );
                                                                    }else{
                                                                        mapIdNamePatientId.put(objUser_Infusion_Dates.Id, strName );
                                                                    }
                                                                 }
            return mapIdNamePatientId;
        }
        }
        return mapIdNamePatientId;
    }
    
    @AuraEnabled
    public static List<User_Infusion_Dates__c> getPatientList( String userId,String InfusionDateId) {
        List<User_Infusion_Dates__c> lstInfusionDates = new List<User_Infusion_Dates__c>();
        if( String.isNotBlank(userId)) {
             if(Schema.sObjectType.User_Infusion_Dates__c.isAccessible()){ 
            for(User_Infusion_Dates__c objUser_Infusion_Dates : [SELECT Id
                                                                 , Name
                                                                 , Patient_Reference_ID__c,Infusion_Date__c
                                                                 FROM User_Infusion_Dates__c 
                                                                 WHERE OwnerId =: userId and Id=:InfusionDateId and Infusion_Date__c > TODAY]) {
                                                                      String pName=objUser_Infusion_Dates.Name;
                													if(pName.length() > 36){
                                                                     	String decryptName=CryptoEncryptDecrypt.getDecryptedValue(pName);                                                                     
																	 	objUser_Infusion_Dates.Name=decryptName;
                                                                    }else{
                                                                        objUser_Infusion_Dates.Name=pName;                                                                       
                                                                    }
                                                                    	lstInfusionDates.add(objUser_Infusion_Dates);
                                                                 }
             }
            return lstInfusionDates;
        }
        	return lstInfusionDates;
    }
}