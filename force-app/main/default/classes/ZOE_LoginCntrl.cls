/**********************************************************************************************
@Description: An apex page controller that exposes the User login functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class ZOE_LoginCntrl {
    //@Description:This Method used to get Institution Name from Master Configurations
    @AuraEnabled
    public static List<String> getInstitutionName() {
        
        try {
            List<String> instituteNames=new List<String>();            
            if(Schema.sObjectType.Master_Configuration__c.isAccessible()){
            List<Master_Configuration__c> institutionCenters=[select Id,Institution_Name__c from Master_Configuration__c where RecordType.Name=:ZOE_Constant.MC_INSTITUTIONS];
             for(Master_Configuration__c masterConfig:institutionCenters){
                instituteNames.add(masterConfig.Institution_Name__c);
            }
        }
            return instituteNames;
        }
        catch (Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
    
    //@Description:This Method used to validate login details and redirct to landing page
    @AuraEnabled
    public static String login(String username , String password) {
        
        try {
            String startUrl = Label.siteurl+'zeolandingpage';
            ApexPages.PageReference pageRef = Site.login(username, password, startUrl);
            return pageRef.getUrl();
        }
        catch (Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
    
    //This Method used for forgot password functionality
    @AuraEnabled
    public static String forgotPassword(String strusername ) {
        try {
            List<User> existingPortalUsers;
            if (Schema.sObjectType.User.isAccessible())
              existingPortalUsers= [select id,Username,IsActive from User where Username =: strusername and IsActive = true ];
                 if(existingPortalUsers.size()>0){ 
               boolean success = Site.forgotPassword(strusername);
                if (success) {  
                 return 'success';
            }else {
                return 'failure';
            }
            }else{
                return 'fail';
            } 
        }
            catch (Exception e) {
          
            throw new AuraHandledException( e.getMessage()); 
        }
         
    }
   
    //@Description:This Method used to Register New User
  
    @AuraEnabled
    public static String registerUser(String primaryName,
                                      String primarySurname,
                                      String email,
                                      String profession,
                                      String matricula,
                                      List<String> institutionList) {
                                          String firstname=null;
                                          String surname=null;
                                          try {
                                             String institutions = String.join( institutionList, ', ' ); 
                                              Pending_Registrations__c objPendingReg=new Pending_Registrations__c();
                                              firstname = primaryName.replaceAll( '\\s+', '');
                                              surname = primarySurname.replaceAll( '\\s+', '');
                                              String username=firstname+surname+generateRandomString(5)+'@zolgensma.com';
                                               objPendingReg.Username__c = username ;
                                              objPendingReg.Email__c = email;
                                              objPendingReg.Nick_Name__c = firstname.substring(0,2)+surname.substring(0,2);
                                              objPendingReg.First_Name__c= firstname;
                                              objPendingReg.Sur_Name__c= surname;
                                              objPendingReg.Profession__c=profession;
                                              objPendingReg.Matricula__c=matricula;
                                              objPendingReg.Institution__c=institutions;
                                              objPendingReg.Status__c=ZOE_Constant.PENDING;
                                              if (Schema.sObjectType.Pending_Registrations__c.isCreateable()){
                                              insert objPendingReg;
                                              }    
                                               Audit_Log__c objAudit_Log = MasterConfigController.createAuditRecord(objPendingReg.Id,JSON.serialize(objPendingReg),'Pending_Registrations__c','Insert');
                                              if (Schema.sObjectType.Audit_Log__c.isCreateable()){
                                              insert objAudit_Log;
                                              }
                                              return ZOE_Constant.SUCCESS;
                                          }
                                          catch (Exception e) {
                                              throw new AuraHandledException( e.getMessage());    
                                          }
                                      }
    
    //@Description:This Method used to random string by length
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}