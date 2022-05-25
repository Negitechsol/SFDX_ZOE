/**********************************************************************************************
@Description: Apex class to insert conact info under ZOE contact object
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class ZOE_Contact {
    @AuraEnabled
    public static ZOE_Contact__c createZOE_Contact( String strName , String strEmail ) {
        ZOE_Contact__c objZOE_Contact = new ZOE_Contact__c();
        objZOE_Contact.Name = String.isNotBlank( strName ) ? strName : '';
       objZOE_Contact.Contact_Email__c = String.isNotBlank( strEmail ) ? strEmail : '';
    
        if (Schema.sObjectType.ZOE_Contact__c.isCreateable())
        insert objZOE_Contact;
        return objZOE_Contact;
    }
}