/**********************************************************************************************
@Description: This Apex Trigger Helper exposes the Pending_Registrations__c Object DML Operations
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History 
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class PendingRegistrationTriggerHelper {
    //@Description: This will execute before Pending_Registrations__c update
    public static void beforeUpdateHelper(List<Pending_Registrations__c> pendingregList) {
        
            List<Contact> contactList=new List<Contact>();
            List<Id> contactIds=new List<Id>();
            Set<String> setProfessionName = new Set<String>();
            Set<String> setProfessionEmail = new Set<String>();
            Map<String,Id> mapAccNameId = new Map<String,Id>();
            Map<String,Contact> mapConEmailId = new Map<String,Contact>();
            List<Account> lstAcc = new List<Account>();
            // create set of all the profession present in the new iteration
            for(Pending_Registrations__c objPendReg : pendingregList) {
                if( objPendReg != null && objPendReg.Status__c.equals(ZOE_Constant.APPROVED) ) {
                    if( String.isNotBlank( objPendReg.Profession__c ) ) {
                            setProfessionName.add(objPendReg.Profession__c);
                     }
                    if( String.isNotBlank( objPendReg.Email__c ) ) {
                    	setProfessionEmail.add(objPendReg.Email__c);
                    }
                }
            }
              if( setProfessionName != null && setProfessionName.size() > 0 && !setProfessionName.isEmpty() ) {
                  if(Schema.sObjectType.Account.isAccessible() ){
                  for( Account objAcc : [Select Id,Owner.Profile.Name, Name from Account where Name IN: setProfessionName ] ) {
                    if( objAcc != null &&  String.isNotBlank( objAcc.Name ) && !mapAccNameId.containsKey(objAcc.Name) ) {                        
                        mapAccNameId.put(objAcc.Name,objAcc.Id);
                        if( objAcc.Owner.Profile.Name.contains(ZOE_Constant.Community)  ) {
                            if(Schema.sObjectType.Account.isUpdateable())
                               objAcc.OwnerId = label.DefaultSystemAdminUserId;
                        }
                    }
                    lstAcc.add(objAcc);
                }
                  }     
            }
            
             if( setProfessionEmail != null && setProfessionEmail.size() > 0 && !setProfessionEmail.isEmpty() ) {
                if(Schema.sObjectType.Contact.isAccessible()){
                 for( Contact objCon : [Select Id,Owner.Profile.Name , Email from Contact where Email IN: setProfessionEmail ] ) {
                    if( objCon != null &&  String.isNotBlank( objCon.Email ) && !mapConEmailId.containsKey(objCon.Email) ) {
                        mapConEmailId.put(objCon.Email,objCon);
                    }
                }
                }
            }
            
            for(Pending_Registrations__c pendingUser : pendingregList) {
                if(pendingUser.Status__c.equals(ZOE_Constant.APPROVED)){
                    Contact objContact=new Contact();
                    if(Schema.sObjectType.Contact.fields.AccountId.isCreateable() && Schema.sObjectType.Contact.fields.AccountId.isUpdateable())
                    objContact.AccountId= mapAccNameId != null && mapAccNameId.size() > 0 && !mapAccNameId.isEmpty() && mapAccNameId.containskey(pendingUser.Profession__c) ? mapAccNameId.get(pendingUser.Profession__c) : createNewAccount(pendingUser.Profession__c);
                    if(Schema.sObjectType.Contact.fields.FirstName.isCreateable() && Schema.sObjectType.Contact.fields.FirstName.isUpdateable())
                    objContact.FirstName=pendingUser.First_Name__c;
                    if(Schema.sObjectType.Contact.fields.LastName.isCreateable() && Schema.sObjectType.Contact.fields.LastName.isUpdateable())
                    objContact.LastName=pendingUser.Sur_Name__c;
                    if(Schema.sObjectType.Contact.fields.Email.isCreateable() && Schema.sObjectType.Contact.fields.Email.isUpdateable())
                    objContact.Email= pendingUser.Email__c;
                    if(Schema.sObjectType.Contact.fields.Username__c.isCreateable() && Schema.sObjectType.Contact.fields.Username__c.isUpdateable())
                    objContact.Username__c=pendingUser.Username__c;
                    if(Schema.sObjectType.Contact.fields.Matricula__c.isCreateable() && Schema.sObjectType.Contact.fields.Matricula__c.isUpdateable())
                    objContact.Matricula__c=pendingUser.Matricula__c;
                    if(Schema.sObjectType.Contact.fields.Profession__c.isCreateable() && Schema.sObjectType.Contact.fields.Profession__c.isUpdateable())
                    objContact.Profession__c=pendingUser.Profession__c;
                    if(Schema.sObjectType.Contact.fields.Institution__c.isCreateable() && Schema.sObjectType.Contact.fields.Institution__c.isUpdateable())
                    objContact.Institution__c=pendingUser.Institution__c;
                    
                    if(  mapConEmailId != null &&  mapConEmailId.size() > 0 && !mapConEmailId.isEmpty()
                       && mapConEmailId.containsKey(pendingUser.Email__c)) {
                           objContact.Id = mapConEmailId.get(pendingUser.Email__c).Id;
                           if( mapConEmailId.get(pendingUser.Email__c).Owner.Profile.Name.contains(ZOE_Constant.Community)  ) {
                           if(Schema.sObjectType.Contact.fields.OwnerId.isCreateable() && Schema.sObjectType.Contact.fields.OwnerId.isUpdateable())
                               objContact.OwnerId = label.DefaultSystemAdminUserId;
                           }
                       }else{
                           if(Schema.sObjectType.Contact.fields.OwnerId.isCreateable() && Schema.sObjectType.Contact.fields.OwnerId.isUpdateable())
                           objContact.OwnerId = label.DefaultSystemAdminUserId;
                       }
                    contactList.add(objContact); 
                    pendingUser.Status__c=ZOE_Constant.REGISTERED;
                }
            }
            if(contactList!=null && contactList.size()>0){
                if (Schema.sObjectType.Contact.isCreateable() || Schema.sObjectType.Contact.isUpdateable()){
                	upsert contactList;
                }
                if (Schema.sObjectType.Account.isCreateable() || Schema.sObjectType.Account.isUpdateable()){
                	update lstAcc;
                }
                for(Contact objContact:contactList){
                    contactIds.add(objContact.Id);  
                } 
                ExternalUserRegistration.createPortalUser(contactIds);
            }
            
        
    }
    
    public static Id createNewAccount( String strName ) {
        if( String.isNotBlank(strName) ) {
            Account objAccount = new Account();
            objAccount.Name = strName; 
            if (Schema.sObjectType.Account.isCreateable()){
            	insert objAccount;
            }
            return objAccount.Id;
        }else{
            return label.DefaultAccountId;
        }
    }
}