/**********************************************************************************************
@Description: An apex page controller that exposes the User Calendar functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class UserCalendarController {
    //@Description:This Method used get Calendar event by logged in user
    @AuraEnabled
    public static List<User_Calendar__c> getUserCalendarEvents( String userId ) {
        List< User_Calendar__c > lstUserCalendar = new List<User_Calendar__c>();
        if( String.isNotBlank(userId)) {
            //@Description:Capturing the feature Usage
            FeatureUsage.insertFeatureUsage(ZOE_Constant.VIRTUAL_ASISTENT);
            if (Schema.sObjectType.User_Calendar__c.isAccessible())
            lstUserCalendar = [SELECT Id
                    , Name
                    , Calendar_Activity__c 
                    , Calendar_Activity_Date__c
                    , User_Infusion_Date_Id__r.Name
                    , User_Infusion_Date_Id__r.Patient_Reference_ID__c
                    , User_Infusion_Date_Id__r.Infusion_Date__c
                    FROM User_Calendar__c 
                    WHERE OwnerId =: userId 
                    AND Event_Type__c =: ZOE_Constant.STR_CALENDAR];
            return lstUserCalendar;
        }
        return lstUserCalendar;
    }
    
    //@Description:This Method used to get Patient Infusion Dates by logged in user id
    @AuraEnabled
    public static Map<String, String> getCalMap( String userId ) {
        Map<String, String> mapIdNamePatientId = new Map<String, String>();
        if( String.isNotBlank(userId)) {
             if(Schema.sObjectType.User_Infusion_Dates__c.isAccessible()){ 
            for(User_Infusion_Dates__c objUser_Infusion_Dates : [SELECT Id
                                                                 , Name
                                                                 , Patient_Reference_ID__c
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
             }
            return mapIdNamePatientId;
        }
        return mapIdNamePatientId;
    }
    
    //@Description: This Method used to get All Calendar Activities by logged in user id
    @AuraEnabled
    public static List<UserCalWrapper> getAllUsersCalenderRec( String userId){
        List<UserCalWrapper> lstUserCalWrapper = new List<UserCalWrapper>();
        if( String.isNotBlank(userId)) {
            if(Schema.sObjectType.User_Calendar__c.isAccessible())  {
            for( User_Calendar__c objUser_Calendar :  [SELECT Id
                                                       , Name,Calendar_Activity__c 
                                                       , Calendar_Activity_Date__c,Corticosteroid_Dose__c
                                                       , Platelets__c,CHOP_INTEND__c
                                                       , Transaminasas_ALT__c,Transaminasas_AST__c
                                                       , User_Infusion_Date_Id__r.Name
                                                       , User_Infusion_Date_Id__r.Patient_Reference_ID__c
                                                       , User_Infusion_Date_Id__r.Infusion_Date__c
                                                       , Calendar_Day__c
                                                       , Calendar_Week__c,Transaminasas_AST_Calval__c
                                                       , Transaminasas_ALT_Ref__c,Transaminasas_AST_Ref__c
                                                       , Transaminasas_ALT_Calval__c
                                                       FROM User_Calendar__c 
                                                       WHERE User_Infusion_Date_Id__r.OwnerId =: userId 
                                                       AND Event_Type__c =: ZOE_Constant.STR_LABTRACKER order by Calendar_Day__c]) {
                                                           
                                                           UserCalWrapper objUserCalWrapper = new UserCalWrapper();
                                                           
                                                           String calInfdt = objUser_Calendar.Calendar_Activity_Date__c;
                                                           // remove unused code
                                                           String[] dt = calInfdt.split(' ');
                                                           String[] tdt=dt[0].split('-');
                                                           if( String.isNotBlank( objUser_Calendar.Calendar_Activity_Date__c)  ) {
                                                               if( String.isNotBlank(objUser_Calendar.Corticosteroid_Dose__c)) {
                                                                   objUserCalWrapper.isDoseInfusionTable = 'true';
                                                               }else if( String.isNotBlank(objUser_Calendar.Transaminasas_AST_Calval__c) 
                                                                        &&  String.isNotBlank(objUser_Calendar.Transaminasas_ALT_Calval__c)   ){
                                                                            objUserCalWrapper.isTRANSAMINASASTable = 'true';
                                                                        }else if( String.isNotBlank(objUser_Calendar.Platelets__c)  ){
                                                                            objUserCalWrapper.isPLAQUETASTable = 'true';
                                                                        }else if( String.isNotBlank(objUser_Calendar.CHOP_INTEND__c) ){
                                                                            objUserCalWrapper.isCHOPTable = 'true';
                                                                        }
                                                           }
                                                           objUserCalWrapper.calInfusionDate 			= Date.valueOf(calInfdt);
                                                           objUserCalWrapper.doseOfInfusion 			= objUser_Calendar.Corticosteroid_Dose__c;
                                                            String pName=objUser_Calendar.User_Infusion_Date_Id__r.Name;
                                                           if(pName.length() > 36){
                                                               objUserCalWrapper.paitentName 				= CryptoEncryptDecrypt.getDecryptedValue(objUser_Calendar.User_Infusion_Date_Id__r.Name);
                                                           }else{
                                                               objUserCalWrapper.paitentName 				= objUser_Calendar.User_Infusion_Date_Id__r.Name;
                                                           }
                                                           
                                                           objUserCalWrapper.paitentid 					= objUser_Calendar.User_Infusion_Date_Id__r.Patient_Reference_ID__c;
                                                           objUserCalWrapper.userInfustionDate 			= objUser_Calendar.User_Infusion_Date_Id__r.Infusion_Date__c;
                                                           objUserCalWrapper.calInfusionId 				= objUser_Calendar.User_Infusion_Date_Id__r.Id;
                                                           objUserCalWrapper.recId 						= objUser_Calendar.Id;
                                                           objUserCalWrapper.calday 					= objUser_Calendar.Calendar_Day__c;
                                                           objUserCalWrapper.calweek 					= objUser_Calendar.Calendar_Week__c;
                                                           objUserCalWrapper.platelets 					= objUser_Calendar.Platelets__c;
                                                           objUserCalWrapper.chopintended 				= objUser_Calendar.CHOP_INTEND__c;
                                                           objUserCalWrapper.transaminasas_AST 			= objUser_Calendar.Transaminasas_AST__c;
                                                           objUserCalWrapper.transaminasas_ALT 			= objUser_Calendar.Transaminasas_ALT__c;
                                                           objUserCalWrapper.transaminasas_ALT_Ref 		= objUser_Calendar.Transaminasas_ALT_Ref__c;
                                                           objUserCalWrapper.transaminasas_ALT_CalVal 	= objUser_Calendar.Transaminasas_ALT_Calval__c;
                                                           objUserCalWrapper.transaminasas_AST_Ref 		= objUser_Calendar.Transaminasas_AST_Ref__c;
                                                           objUserCalWrapper.transaminasas_AST_CalVal 	= objUser_Calendar.Transaminasas_AST_Calval__c;
                                                           lstUserCalWrapper.add(objUserCalWrapper);        
                                                       }
        }
            return lstUserCalWrapper;
        }
        return lstUserCalWrapper;
    }
    
    //@Description: This Method used to Convert/Formate the string Date
    public static String dateConversion( String strDate ) {
        if( string.isNotBlank(strDate) ) {
            String strFormatedDate = ''; 
            String[] lstDateVar = strDate.split(' ');
            if( !lstDateVar.isEmpty() && lstDateVar.size() > 0 ) {
                String[] lstDateWithoutDash = lstDateVar[0].split('-');
                strFormatedDate = lstDateWithoutDash[0]+'/'+lstDateWithoutDash[1]+'/'+lstDateWithoutDash[2];
            }
            return strFormatedDate;
        }
        return '';
    }
    
    //@Description: This Method used to get All Lab Tracker records from calendar object by logged in user and patient
    @AuraEnabled
    public static List<UserCalWrapper> getAllUsersCalenderRecByPatientId( String userId,String PatientId){
        
        List<UserCalWrapper> lstUserCalWrapper = new List<UserCalWrapper>();
        if(Schema.sObjectType.User_Calendar__c.isAccessible()){
        for( User_Calendar__c objUser_Calendar :  [SELECT Id,Name,Calendar_Activity__c 
                                                   , Calendar_Activity_Date__c,Corticosteroid_Dose__c,Platelets__c,CHOP_INTEND__c
                                                   , Transaminasas_ALT__c,Transaminasas_AST__c,User_Infusion_Date_Id__r.Name
                                                   , User_Infusion_Date_Id__r.Patient_Reference_ID__c
                                                   , User_Infusion_Date_Id__r.Infusion_Date__c
                                                   , Calendar_Day__c
                                                   , Calendar_Week__c,Transaminasas_AST_Calval__c
                                                   , Transaminasas_ALT_Ref__c,Transaminasas_AST_Ref__c,Transaminasas_ALT_Calval__c
                                                   FROM User_Calendar__c 
                                                   WHERE User_Infusion_Date_Id__r.OwnerId =: userId and User_Infusion_Date_Id__r.Id=:PatientId and User_Infusion_Date_Id__r.Status__c='active'
                                                   and Event_Type__c='LABTRACKER' order by Calendar_Day__c]) {
                                                       
                                                       UserCalWrapper objUserCalWrapper = new UserCalWrapper();
                                                       String calInfdt=objUser_Calendar.Calendar_Activity_Date__c;
                                                       String[] dt=calInfdt.split(' ');
                                                       String[] tdt=dt[0].split('-');
                                                       if( String.isNotBlank( objUser_Calendar.Calendar_Activity_Date__c)  ) {
                                                           if( String.isNotBlank(objUser_Calendar.Corticosteroid_Dose__c)) {
                                                               objUserCalWrapper.isDoseInfusionTable = 'true';
                                                           }else if( String.isNotBlank(objUser_Calendar.Transaminasas_AST_Calval__c) 
                                                                    &&  String.isNotBlank(objUser_Calendar.Transaminasas_ALT_Calval__c)   ){
                                                                        objUserCalWrapper.isTRANSAMINASASTable = 'true';
                                                                    }else if( String.isNotBlank(objUser_Calendar.Platelets__c)  ){
                                                                        objUserCalWrapper.isPLAQUETASTable = 'true';
                                                                    }else if( String.isNotBlank(objUser_Calendar.CHOP_INTEND__c) ){
                                                                        objUserCalWrapper.isCHOPTable = 'true';
                                                                    }
                                                       }
                                                       objUserCalWrapper.calInfusionDate = Date.valueOf(calInfdt);
                                                       objUserCalWrapper.doseOfInfusion = objUser_Calendar.Corticosteroid_Dose__c;
                                                       String pName=objUser_Calendar.User_Infusion_Date_Id__r.Name;
                                                           if(pName.length() > 36){
                                                               objUserCalWrapper.paitentName 				= CryptoEncryptDecrypt.getDecryptedValue(objUser_Calendar.User_Infusion_Date_Id__r.Name);
                                                           }else{
                                                               objUserCalWrapper.paitentName 				= objUser_Calendar.User_Infusion_Date_Id__r.Name;
                                                           }
                                                       objUserCalWrapper.paitentid = objUser_Calendar.User_Infusion_Date_Id__r.Patient_Reference_ID__c;
                                                       objUserCalWrapper.userInfustionDate = objUser_Calendar.User_Infusion_Date_Id__r.Infusion_Date__c;
                                                       objUserCalWrapper.recId = objUser_Calendar.Id;
                                                       objUserCalWrapper.calday = objUser_Calendar.Calendar_Day__c;
                                                       objUserCalWrapper.calweek = objUser_Calendar.Calendar_Week__c;
                                                       objUserCalWrapper.platelets = objUser_Calendar.Platelets__c;
                                                       objUserCalWrapper.chopintended = objUser_Calendar.CHOP_INTEND__c;
                                                       objUserCalWrapper.transaminasas_AST = objUser_Calendar.Transaminasas_AST__c;
                                                       objUserCalWrapper.transaminasas_ALT = objUser_Calendar.Transaminasas_ALT__c;                    
                                                       objUserCalWrapper.transaminasas_ALT_Ref = objUser_Calendar.Transaminasas_ALT_Ref__c;
                                                       objUserCalWrapper.transaminasas_ALT_CalVal = objUser_Calendar.Transaminasas_ALT_Calval__c;
                                                       objUserCalWrapper.transaminasas_AST_Ref = objUser_Calendar.Transaminasas_AST_Ref__c;
                                                       objUserCalWrapper.transaminasas_AST_CalVal = objUser_Calendar.Transaminasas_AST_Calval__c;
                                                       lstUserCalWrapper.add(objUserCalWrapper);        
                                                   }
    }
        return lstUserCalWrapper;
    }
    
     //@Description: This Method used to get All Lab Tracker records from calendar object by logged in user
    @AuraEnabled
    public static List<UserCalWrapper> getAllUsersCalenderAllRecs(String userId){
        
        List<UserCalWrapper> lstUserCalWrapper = new List<UserCalWrapper>();
        
        if(Schema.sObjectType.User_Calendar__c.isAccessible()){
        for( User_Calendar__c objUser_Calendar :  [SELECT Id,Name,Calendar_Activity__c 
                                                   , Calendar_Activity_Date__c,Corticosteroid_Dose__c,Platelets__c,CHOP_INTEND__c
                                                   , Transaminasas_ALT__c,Transaminasas_AST__c,User_Infusion_Date_Id__r.Name
                                                   , User_Infusion_Date_Id__r.Patient_Reference_ID__c
                                                   , User_Infusion_Date_Id__r.Infusion_Date__c
                                                   , Calendar_Day__c
                                                   , Calendar_Week__c,Transaminasas_AST_Calval__c
                                                   , Transaminasas_ALT_Ref__c,Transaminasas_AST_Ref__c,Transaminasas_ALT_Calval__c
                                                   FROM User_Calendar__c 
                                                   WHERE User_Infusion_Date_Id__r.OwnerId =: userId and User_Infusion_Date_Id__r.Status__c='active' and Event_Type__c='LABTRACKER' order by User_Infusion_Date_Id__r.Patient_Reference_ID__c,Calendar_Day__c]) {
                                                       
                                                       UserCalWrapper objUserCalWrapper = new UserCalWrapper();
                                                       String calInfdt=objUser_Calendar.Calendar_Activity_Date__c;
                                                       String[] dt=calInfdt.split(' ');
                                                       String[] tdt=dt[0].split('-');
                                                       if( String.isNotBlank( objUser_Calendar.Calendar_Activity_Date__c)  ) {
                                                           if( String.isNotBlank(objUser_Calendar.Corticosteroid_Dose__c)) {
                                                               objUserCalWrapper.isDoseInfusionTable = 'true';
                                                           }else if( String.isNotBlank(objUser_Calendar.Transaminasas_AST_Calval__c) 
                                                                    &&  String.isNotBlank(objUser_Calendar.Transaminasas_ALT_Calval__c)   ){
                                                                        objUserCalWrapper.isTRANSAMINASASTable = 'true';
                                                                    }else if( String.isNotBlank(objUser_Calendar.Platelets__c)  ){
                                                                        objUserCalWrapper.isPLAQUETASTable = 'true';
                                                                    }else if( String.isNotBlank(objUser_Calendar.CHOP_INTEND__c) ){
                                                                        objUserCalWrapper.isCHOPTable = 'true';
                                                                    }
                                                       }
                                                       objUserCalWrapper.calInfusionDate = Date.valueOf(calInfdt);
                                                       objUserCalWrapper.doseOfInfusion = objUser_Calendar.Corticosteroid_Dose__c;
                                                       String pName=objUser_Calendar.User_Infusion_Date_Id__r.Name;
                                                           if(pName.length() > 36){

                                                               objUserCalWrapper.paitentName 				= CryptoEncryptDecrypt.getDecryptedValue(objUser_Calendar.User_Infusion_Date_Id__r.Name);
                                                           }else{
                                                               objUserCalWrapper.paitentName 				= objUser_Calendar.User_Infusion_Date_Id__r.Name;
                                                           }
                                                       objUserCalWrapper.paitentid = objUser_Calendar.User_Infusion_Date_Id__r.Patient_Reference_ID__c;
                                                       objUserCalWrapper.userInfustionDate = objUser_Calendar.User_Infusion_Date_Id__r.Infusion_Date__c;
                                                       objUserCalWrapper.recId = objUser_Calendar.Id;
                                                       objUserCalWrapper.calday = objUser_Calendar.Calendar_Day__c;
                                                       objUserCalWrapper.calweek = objUser_Calendar.Calendar_Week__c;
                                                       objUserCalWrapper.platelets = objUser_Calendar.Platelets__c;
                                                       objUserCalWrapper.chopintended = objUser_Calendar.CHOP_INTEND__c;
                                                       objUserCalWrapper.transaminasas_AST = objUser_Calendar.Transaminasas_AST__c;
                                                       objUserCalWrapper.transaminasas_ALT = objUser_Calendar.Transaminasas_ALT__c;                    
                                                       objUserCalWrapper.transaminasas_ALT_Ref = objUser_Calendar.Transaminasas_ALT_Ref__c;
                                                       objUserCalWrapper.transaminasas_ALT_CalVal = objUser_Calendar.Transaminasas_ALT_Calval__c;
                                                       objUserCalWrapper.transaminasas_AST_Ref = objUser_Calendar.Transaminasas_AST_Ref__c;
                                                       objUserCalWrapper.transaminasas_AST_CalVal = objUser_Calendar.Transaminasas_AST_Calval__c;
                                                       lstUserCalWrapper.add(objUserCalWrapper);        
                                                   }
    }
        return lstUserCalWrapper;
    }
    
    //@Description: This Method used to update Dose details
    @AuraEnabled
    public static List<UserCalWrapper> updateDose( List< UserCalWrapper > wrapperList ){
        List< User_Calendar__c > lstUserCalendar = new List<User_Calendar__c>();
        List<UserCalWrapper> lstUserCalWrapper = new List<UserCalWrapper>();
        for( UserCalWrapper objUserCalWrapper : wrapperList ) {
            Integer numberDaysDue;
            String day='';
            String Week='';
            Date infusion_Date = objUserCalWrapper.userInfustionDate;
            User_Calendar__c objUserCalendar = new User_Calendar__c();
            numberDaysDue = infusion_Date.daysBetween(objUserCalWrapper.calInfusionDate);
            day=string.valueof(numberDaysDue);
            week=string.valueof(numberDaysDue/7);
             if(Schema.sObjectType.User_Calendar__c.fields.Corticosteroid_Dose__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Corticosteroid_Dose__c.isUpdateable())
            objUserCalendar.Corticosteroid_Dose__c = objUserCalWrapper.doseOfInfusion;
            if( objUserCalWrapper.recId != '' && objUserCalWrapper.recId != null ) { 
                objUserCalendar.Id = objUserCalWrapper.recId;
            }else{
                 if(Schema.sObjectType.User_Calendar__c.fields.User_Infusion_Date_Id__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.User_Infusion_Date_Id__c.isUpdateable())
                objUserCalendar.User_Infusion_Date_Id__c = objUserCalWrapper.calInfusionId;
                 if(Schema.sObjectType.User_Calendar__c.fields.Event_Type__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Event_Type__c.isUpdateable())
                objUserCalendar.Event_Type__c= ZOE_Constant.STR_LABTRACKER;
            }
            if(Schema.sObjectType.User_Calendar__c.fields.Platelets__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Platelets__c.isUpdateable())
            objUserCalendar.Platelets__c = objUserCalWrapper.platelets;
            if(Schema.sObjectType.User_Calendar__c.fields.CHOP_INTEND__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.CHOP_INTEND__c.isUpdateable())
            objUserCalendar.CHOP_INTEND__c = objUserCalWrapper.chopintended;
            if(Schema.sObjectType.User_Calendar__c.fields.Transaminasas_AST__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Transaminasas_AST__c.isUpdateable())
            objUserCalendar.Transaminasas_AST__c = objUserCalWrapper.transaminasas_AST;
            if(Schema.sObjectType.User_Calendar__c.fields.Transaminasas_ALT__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Transaminasas_ALT__c.isUpdateable())
            objUserCalendar.Transaminasas_ALT__c = objUserCalWrapper.transaminasas_ALT;
            if(Schema.sObjectType.User_Calendar__c.fields.Transaminasas_ALT_Ref__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Transaminasas_ALT_Ref__c.isUpdateable())
            objUserCalendar.Transaminasas_ALT_Ref__c = objUserCalWrapper.transaminasas_ALT_Ref;
            if(Schema.sObjectType.User_Calendar__c.fields.Transaminasas_ALT_Calval__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Transaminasas_ALT_Calval__c.isUpdateable())
            objUserCalendar.Transaminasas_ALT_Calval__c = objUserCalWrapper.transaminasas_ALT_CalVal;
            if(Schema.sObjectType.User_Calendar__c.fields.Transaminasas_AST_Ref__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Transaminasas_AST_Ref__c.isUpdateable())
            objUserCalendar.Transaminasas_AST_Ref__c =  objUserCalWrapper.transaminasas_AST_Ref;
            if(Schema.sObjectType.User_Calendar__c.fields.Transaminasas_AST_Calval__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Transaminasas_AST_Calval__c.isUpdateable())
            objUserCalendar.Transaminasas_AST_Calval__c = objUserCalWrapper.transaminasas_AST_CalVal; 
            if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Activity_Date__c.isCreateable() && Schema.sObjectType.User_Calendar__c.fields.Calendar_Activity_Date__c.isUpdateable())
            objUserCalendar.Calendar_Activity_Date__c = string.valueofGmt(objUserCalWrapper.calInfusionDate);
            if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Day__c.isCreateable()  && Schema.sObjectType.User_Calendar__c.fields.Calendar_Day__c.isUpdateable())
            objUserCalendar.Calendar_Day__c=day;
            if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Week__c.isCreateable()  && Schema.sObjectType.User_Calendar__c.fields.Calendar_Week__c.isUpdateable())
            objUserCalendar.Calendar_Week__c=week;
            
            lstUserCalendar.add(objUserCalendar);
        }
        if( !lstUserCalendar.isEmpty() && lstUserCalendar.size() > 0 ) {
            if ((Schema.sObjectType.User_Calendar__c.isCreateable()) || (Schema.sObjectType.User_Calendar__c.isUpdateable())){
            upsert lstUserCalendar;
                }
        }
        
        List<Audit_Log__c> lstAudit = new List<Audit_Log__c>();
        if(Schema.sObjectType.User_Calendar__c.isAccessible()){
        for( User_Calendar__c objUserCalendar :  [SELECT Id
                                                   , Name,Calendar_Activity__c 
                                                   , Calendar_Activity_Date__c,Corticosteroid_Dose__c
                                                   , Platelets__c,CHOP_INTEND__c
                                                   , Transaminasas_ALT__c,Transaminasas_AST__c
                                                   , User_Infusion_Date_Id__r.Name
                                                   , User_Infusion_Date_Id__r.Patient_Reference_ID__c
                                                   , User_Infusion_Date_Id__r.Infusion_Date__c
                                                   , Calendar_Day__c
                                                   , Calendar_Week__c,Transaminasas_AST_Calval__c
                                                   , Transaminasas_ALT_Ref__c,Transaminasas_AST_Ref__c
                                                   , Transaminasas_ALT_Calval__c
                                                   FROM User_Calendar__c 
                                                   WHERE Id IN: lstUserCalendar]) {                                                       
                                                       UserCalWrapper objUserCalWrapper = new UserCalWrapper();
                                                       
                                                       String calInfdt = objUserCalendar.Calendar_Activity_Date__c;
                                                       String[] dt = calInfdt.split(' ');
                                                       String[] tdt=dt[0].split('-');
                                                       if( String.isNotBlank( objUserCalendar.Calendar_Activity_Date__c)  ) {
                                                           if( String.isNotBlank(objUserCalendar.Corticosteroid_Dose__c)) {
                                                               objUserCalWrapper.isDoseInfusionTable = 'true';
                                                           }else if( String.isNotBlank(objUserCalendar.Transaminasas_AST_Calval__c) 
                                                                    &&  String.isNotBlank(objUserCalendar.Transaminasas_ALT_Calval__c)   ){
                                                                        objUserCalWrapper.isTRANSAMINASASTable = 'true';
                                                                    }else if( String.isNotBlank(objUserCalendar.Platelets__c)  ){
                                                                        objUserCalWrapper.isPLAQUETASTable = 'true';
                                                                    }else if( String.isNotBlank(objUserCalendar.CHOP_INTEND__c) ){
                                                                        objUserCalWrapper.isCHOPTable = 'true';
                                                                    }
                                                       }                           
                                                       objUserCalWrapper.calInfusionDate 			= Date.valueOf(calInfdt);
                                                       objUserCalWrapper.doseOfInfusion 			= objUserCalendar.Corticosteroid_Dose__c;
                                                       objUserCalWrapper.paitentName 				= objUserCalendar.User_Infusion_Date_Id__r.Name;
                                                       objUserCalWrapper.paitentid 					= objUserCalendar.User_Infusion_Date_Id__r.Patient_Reference_ID__c;
                                                       objUserCalWrapper.userInfustionDate 			= objUserCalendar.User_Infusion_Date_Id__r.Infusion_Date__c;
                                                       objUserCalWrapper.calInfusionId 				= objUserCalendar.User_Infusion_Date_Id__r.Id;
                                                       objUserCalWrapper.recId 						= objUserCalendar.Id;
                                                       objUserCalWrapper.calday 					= objUserCalendar.Calendar_Day__c;
                                                       objUserCalWrapper.calweek 					= objUserCalendar.Calendar_Week__c;
                                                       objUserCalWrapper.platelets 					= objUserCalendar.Platelets__c;
                                                       objUserCalWrapper.chopintended 				= objUserCalendar.CHOP_INTEND__c;
                                                       objUserCalWrapper.transaminasas_AST 			= objUserCalendar.Transaminasas_AST__c;
                                                       objUserCalWrapper.transaminasas_ALT 			= objUserCalendar.Transaminasas_ALT__c;
                                                       objUserCalWrapper.transaminasas_ALT_Ref 		= objUserCalendar.Transaminasas_ALT_Ref__c;
                                                       objUserCalWrapper.transaminasas_ALT_CalVal 	= objUserCalendar.Transaminasas_ALT_Calval__c;
                                                       objUserCalWrapper.transaminasas_AST_Ref 		= objUserCalendar.Transaminasas_AST_Ref__c;
                                                       objUserCalWrapper.transaminasas_AST_CalVal 	= objUserCalendar.Transaminasas_AST_Calval__c;
                                                       lstUserCalWrapper.add(objUserCalWrapper);   
                                                       
                                                       
                                                       // create audit records
                                                       Audit_Log__c objAuditLog = MasterConfigController.createAuditRecord( objUserCalendar.Id
                                                                                                                  , JSON.serialize(objUserCalendar)
                                                                                                                  , 'User_Calendar__c'
                                                                                                                  , 'Insert' );
                                                       lstAudit.add(objAuditLog);
                                                       // decrypting patient name after audit log                          
                                                       String pName=objUserCalendar.User_Infusion_Date_Id__r.Name;
                                                           if(pName.length() > 36){
                                                               objUserCalWrapper.paitentName 				= CryptoEncryptDecrypt.getDecryptedValue(objUserCalendar.User_Infusion_Date_Id__r.Name);
                                                           }else{
                                                               objUserCalWrapper.paitentName 				= objUserCalendar.User_Infusion_Date_Id__r.Name;
                                                           }
                                                       
                                                       }
    }
        
        if( !lstAudit.isEmpty() && lstAudit.size() > 0 ) {
            if (Schema.sObjectType.Audit_Log__c.isCreateable())
            insert lstAudit;
        }
        return lstUserCalWrapper;
    }
    //@Description: This method used for get all calendar activities
    @AuraEnabled
    public static List<User_Calendar__c> getUserCalendarEventsByPatient( String userId,String PatientId){
        List< User_Calendar__c > lstUserCalendar = new List<User_Calendar__c>();
        if(PatientId.equalsIgnoreCase('all')){
           if (Schema.sObjectType.User_Calendar__c.isAccessible())
           lstUserCalendar =  [SELECT Id,Name,Calendar_Activity__c ,Calendar_Activity_Date__c,User_Infusion_Date_Id__r.Name,User_Infusion_Date_Id__r.Patient_Reference_ID__c,User_Infusion_Date_Id__r.Infusion_Date__c
                    FROM User_Calendar__c 
                    WHERE OwnerId =: userId and User_Infusion_Date_Id__r.Status__c='active' and Event_Type__c=: ZOE_Constant.STR_CALENDAR];
        }else{
            if (Schema.sObjectType.User_Calendar__c.isAccessible())
            lstUserCalendar =  [SELECT Id,Name,Calendar_Activity__c ,Calendar_Activity_Date__c,User_Infusion_Date_Id__r.Name,User_Infusion_Date_Id__r.Patient_Reference_ID__c,User_Infusion_Date_Id__r.Infusion_Date__c
                    FROM User_Calendar__c 
                    WHERE OwnerId =: userId and User_Infusion_Date_Id__r.Status__c='active' and User_Infusion_Date_Id__r.Id=:PatientId and Event_Type__c=: ZOE_Constant.STR_CALENDAR order by Calendar_Activity_Date__c];  
        }
        if(lstUserCalendar.size() > 0){
           lstUserCalendar = getEncryptUserCalRec(lstUserCalendar);
        }
        return lstUserCalendar;
        
    }
    //@Description: This method is used to get Chart Data from user calander object
    @AuraEnabled
    public static List<User_Calendar__c> getLabtackerChartDetails( String userId,String PatientId){
        List<User_Calendar__c> userCalender = new  List<User_Calendar__c>();
        if (Schema.sObjectType.User_Calendar__c.isAccessible()){
        return [SELECT Calendar_Week__c,Corticosteroid_Dose__c,Platelets__c,Transaminasas_ALT__c,Transaminasas_AST__c,User_Infusion_Date_Id__r.Infusion_Date__c
                FROM User_Calendar__c 
                WHERE OwnerId =: userId and User_Infusion_Date_Id__r.Id=:PatientId and Event_Type__c=: ZOE_Constant.STR_LABTRACKER]; 
        }
        return userCalender;
    }
    //@Description: This method is used to update the feature usage
    @AuraEnabled
    public static void updateFeatureUsage( String eventName ){
        FeatureUsage.insertFeatureUsage(eventName);
    }
    
     @AuraEnabled
    public static List<User_Calendar__c> getEncryptUserCalRec(List<User_Calendar__c> lstUserCallist){
           
        List< User_Calendar__c > lstUserCalendar = new List<User_Calendar__c>();
        String User_Infusion_Date_Id='';
        for( User_Calendar__c objUserCalendar :lstUserCallist){
            if(!User_Infusion_Date_Id.equals(objUserCalendar.User_Infusion_Date_Id__r.Id)){
                String pName=objUserCalendar.User_Infusion_Date_Id__r.Name;
                if(pName.length() > 36){
                    objUserCalendar.User_Infusion_Date_Id__r.Name = CryptoEncryptDecrypt.getDecryptedValue(pName);
                }
            
            lstUserCalendar.add(objUserCalendar);
            User_Infusion_Date_Id=objUserCalendar.User_Infusion_Date_Id__r.Id;
            }else{
                 lstUserCalendar.add(objUserCalendar);
            }       
        }
        return lstUserCalendar;
    }
    
    //@Description: This is Wrapper for User Calendar
    public class UserCalWrapper {
        @AuraEnabled
        public String isDoseInfusionTable{get;set;}
        @AuraEnabled
        public String isTRANSAMINASASTable{get;set;}
        @AuraEnabled
        public String isPLAQUETASTable{get;set;}
        @AuraEnabled
        public String isCHOPTable{get;set;}
        @AuraEnabled
        public String calInfusionId{get;set;}
        @AuraEnabled
        public Date calInfusionDate{get;set;}
        @AuraEnabled
        public String doseOfInfusion{get;set;}
        @AuraEnabled
        public String paitentName{get;set;}
        @AuraEnabled
        public String paitentid{get;set;}
        @AuraEnabled
        public Date userInfustionDate{get;set;}
        @AuraEnabled
        public String recId{get;set;}
        @AuraEnabled
        public String calday{get;set;}
        @AuraEnabled
        public String calweek{get;set;}
        @AuraEnabled
        public String platelets{get;set;}
        @AuraEnabled
        public String chopintended{get;set;}
        @AuraEnabled
        public String transaminasas_AST{get;set;}
        @AuraEnabled
        public String transaminasas_ALT{get;set;}
        @AuraEnabled
        public String transaminasas_AST_Ref{get;set;}
        @AuraEnabled
        public String transaminasas_ALT_Ref{get;set;}
        @AuraEnabled
        public String transaminasas_AST_CalVal{get;set;}
        @AuraEnabled
        public String transaminasas_ALT_CalVal{get;set;}
        @AuraEnabled
        public Date doesDate1{get;set;}
        @AuraEnabled
        public Date doesDate2{get;set;}
        @AuraEnabled
        public Date doesDate3{get;set;}
        @AuraEnabled
        public Date doesDate4{get;set;}
        @AuraEnabled
        public String doesDate1_day{get;set;}
        @AuraEnabled
        public String doesDate2_day{get;set;}
        @AuraEnabled
        public String doesDate3_day{get;set;}
        @AuraEnabled
        public String doesDate4_day{get;set;}
        @AuraEnabled
        public String doesDate1_week{get;set;}
        @AuraEnabled
        public String doesDate2_week{get;set;}
        @AuraEnabled
        public String doesDate3_week{get;set;}
        @AuraEnabled
        public String doesDate4_week{get;set;}
    } 
}