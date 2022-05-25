/**********************************************************************************************
@Description: An apex page controller that exposes the Pending Registrations functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class PendingRegistrationController {
    
    //@Description: This method used to get The Registered User List with pending Status
    @AuraEnabled
    public static List <Pending_Registrations__c> fetchPendingUsers() {
        List<Pending_Registrations__c> pendinguserList = new List<Pending_Registrations__c>();
        if (Schema.sObjectType.Pending_Registrations__c.isAccessible()){
        pendinguserList = [SELECT Id, Name, Email__c,                                      
                   First_Name__c, Nick_Name__c, Password__c, Status__c,Sur_Name__c,Username__c,Other_Institution_Name__c from Pending_Registrations__c where Status__c=:ZOE_Constant.PENDING ];
        }
            return pendinguserList;
    }
    
    //@Description: This method used to Apperove the Registered User
    @AuraEnabled
    public static List <Pending_Registrations__c> approveUser(List<Pending_Registrations__c> pendinguserList ) {
        List<Pending_Registrations__c> lstPend = new List<Pending_Registrations__c>();
        //@Description: it's okay if password is null - we'll send the user a random password in that case
        try {
            for(Pending_Registrations__c pendingUser:pendinguserList){
             if(Schema.sObjectType.Pending_Registrations__c.fields.Status__c.isUpdateable())
                pendingUser.Status__c=ZOE_Constant.APPROVED;
             lstPend.add(pendingUser);
            }
            if (Schema.sObjectType.Pending_Registrations__c.isUpdateable()){
                   update lstPend;
            }    
            return fetchPendingUsers();
        }catch (Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
    //@Description: This method used to Reject the Registered User
    @AuraEnabled
    public static String rejectUser(List<Pending_Registrations__c> pendinguserList ) {
        //@Description: it's okay if password is null - we'll send the user a random password in that case
        try {
            for(Pending_Registrations__c pendingUser:pendinguserList){
                   if(Schema.sObjectType.Pending_Registrations__c.fields.Status__c.isUpdateable())
                pendingUser.Status__c=ZOE_Constant.REJECTED;
            }
            if (Schema.sObjectType.Pending_Registrations__c.isUpdateable()){
            update pendinguserList;
            }
            return ZOE_Constant.SUCCESS;
        }catch (Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
}