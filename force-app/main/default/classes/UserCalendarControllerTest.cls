/**********************************************************************************************
@Description: An apex page controller that exposes the UserCalendarController Functionalities
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class UserCalendarControllerTest {
    @testSetup
    static void setUpData(){
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Customer Community Plus User']; 
                
        User runAsUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        String contactid;
        System.runAs ( runAsUser ) {          
            Account testAccount = new Account();
            testAccount.Name='Test Account' ;
            insert testAccount;
            
            Contact cont = new Contact();
            cont.FirstName='Test';
            cont.LastName='Test';
            cont.Accountid= testAccount.id;
            insert cont;
            contactid = cont.Id;
            
            User_Calendar__c objUserCalendar = TestDataFactory.createUser_Calendar(false);
            objUserCalendar.Event_Type__c ='CALENDAR';
            objUserCalendar.Calendar_email_template__c = 'Pre infusion';
            objUserCalendar.First_Notification_Date__c = '2022-03-16 00:00:00';
            objUserCalendar.Second_Notification_Date__c = '2022-03-19 00:00:00';
            insert objUserCalendar ;
            
            User_Calendar__c objUserCalendar1 = TestDataFactory.createUser_Calendar(false);
            objUserCalendar1.Event_Type__c ='CALENDAR';
            insert objUserCalendar1 ;
            
            User_Infusion_Dates__c objUserInfusionDates  = new User_Infusion_Dates__c ();
            objUserInfusionDates.Name = 'Test user user infusion';
            //objUserInfusionDates.OwnerId=objuser.Id;
            objUserInfusionDates.Status__c='Active';
            objUserInfusionDates.Infusion_Date__c = system.today()+3;
            insert objUserInfusionDates;
            
        }        
        User objUser = new User(Alias = 'standt', Email='divyanidadavolu231@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = objProfile.Id, 	ContactId = contactid, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest@novartis.com');
        
        insert objUser;
        
        
    }
     static testmethod void getUserCalendarEventsTest() {
        //@Description: Setup test data
        //@Description: This code runs as the system user
        User user= [Select id from User where LastName='Testing' Limit 1];
        System.runAs(user) {
            
            
            Test.StartTest();
            List<User_Calendar__c> lstUserCalendar =  UserCalendarController.getUserCalendarEvents(user.Id);
            system.assertNotEquals(1, lstUserCalendar.size(),'User calendar list is not equals to one');
            //system.assertEquals('Test user calender name', lstUserCalendar[0].Name);
            UserCalendarController.dateConversion('08-03-2018');
            Test.StopTest();
        }
    }
    
    static testmethod void getUserCalendarEventsNegativeTest() {
        //@Description: Setup test data
        User user= [Select id from User where UserName='standardusertest@novartis.com' Limit 1];
        
        System.runAs(user) {
            
            Test.StartTest();
            List<User_Calendar__c> lstUser_Calendar =  UserCalendarController.getUserCalendarEvents(user.Id);
            system.assertEquals(0, lstUser_Calendar.size(),'Calendar size is zero');
            Test.StopTest();
        }
    }
    
    static testmethod void getCalMapTest() {
        //@Description: Setup test data
        //@Description: This code runs as the system user
        User user= [Select id from User where LastName='Testing' Limit 1];
        System.runAs(user) {
            Id calendaractivity=Schema.SObjectType.Master_Configuration__c.getRecordTypeInfosByName().get('Calendar Activities').getRecordTypeId();
            Master_Configuration__c conf=new Master_Configuration__c();
            conf.Calendar_Activity__c='Test';
            conf.Calendar_Activity_desc__c='Test';
            conf.Calendar_Activity_duration_Type__c='Month';
            conf.Calendar_Activity_duration__c='1';
            conf.RecordTypeId=calendaractivity;
            
            conf.Infusion_Center_Id__c='Test';
            conf.Infusion_Center_Name__c='Test';
            conf.Infusion_Center_Address__c='Test';
            conf.Street__c='Test';
            conf.State__c='Test';
            conf.City__c='Test';
            conf.Country__c='Test';
            conf.PostalCode__c='123456';
            conf.Active__c= true;
            conf.Address_2__c='test';
            conf.Address_1__c='test';   
            conf.Address_3__c='test';
            conf.Calendar_Activity__c='Test';
            conf.Calendar_Activity_desc__c='Test';
            conf.Calendar_Activity_duration__c='1';
            conf.Calendar_Activity_Duration_Type__c='Day';
            conf.Calendar_email_template__c='Infusion day';
            conf.Description__c='test';
            conf.Dosage__c= 2;
            conf.End_Weight__c= 2;
            conf.First_Notification__c='1';
            conf.Institution_Id__c='test';
            conf.Institution_Name__c='test';
            conf.Link__c='www.salesforce.com';
            conf.Weight_Range__c='1-2';
            conf.Record_Status__c='t';
            conf.Second_Notification__c='2';
            conf.Spanish_Calendar_Activity__c='test';
            conf.Spanish_Calendar_Activity_Description__c='test';
            conf.Start_Weight__c= 2;
            conf.Training_Name__c='test';
            conf.Type__c='PDF';
            conf.Vial5_5__c= 1;
            conf.Vial8_3__c= 1;
            conf.Viales_Totales__c= 1;
            conf.RecordTypeId=calendaractivity;
            insert conf;
            User_Infusion_Dates__c objUserInfusionDates  = new User_Infusion_Dates__c ();
            objUserInfusionDates.Name = 'Test user user infusion';
            objUserInfusionDates.OwnerId=user.Id;
            objUserInfusionDates.Status__c='Active';
            objUserInfusionDates.Infusion_Date__c = system.today()+3;
            insert objUserInfusionDates;
            
            User_Infusion_Dates__c objuserinfusion= [Select id from User_Infusion_Dates__c where Name='Test user user infusion' Limit 1]; 
            
            Test.StartTest();
            Map<String, String> mapidName = UserCalendarController.getCalMap(user.Id);
            system.assertEquals(1, mapidName.size(),'Calendar map is eqauls to zero');
            Test.StopTest();
        }
    }
    
    static testmethod void getAllUsersCalenderRecTest() {
        //@Description: Setup test data
        //@Description: This code runs as the system user
        User user= [Select id from User where UserName='standardusertest@novartis.com' Limit 1];
        System.runAs(user) {
            User_Infusion_Dates__c objUser_Infusion_Dates = TestDataFactory.createUser_InfusionDate(true);
            
            User_Calendar__c objUser_Calendar = TestDataFactory.createUser_Calendar(false);
            objUser_Calendar.Event_Type__c ='LABTRACKER';
            objUser_Calendar.User_Infusion_Date_Id__c = objUser_Infusion_Dates.Id;
            insert objUser_Calendar ;
            
            Test.StartTest();
            List<UserCalendarController.UserCalWrapper> lstUserCalWrap = UserCalendarController.getAllUsersCalenderRec(user.Id);
            system.assertEquals(1, lstUserCalWrap.size(),'User calendar list is equals to zero');
            system.assertEquals('1', lstUserCalWrap[0].calday,'User calendar call day is equals to one');
            Test.StopTest();
        }
    }
    
    static testmethod void getEncryptUserCalRec() {
        
    }
    
    static testmethod void getAllUsersCalenderRecByPatientId() {
        //@Description: Setup test data
        //@Description: This code runs as the system user
        User user= [Select id from User where UserName='standardusertest@novartis.com' Limit 1];
        System.runAs(user) {
            User_Infusion_Dates__c objUserInfusionDates  = new User_Infusion_Dates__c ();
            objUserInfusionDates.Name = 'Test user user infusion';
            objUserInfusionDates.OwnerId=user.Id;
            objUserInfusionDates.Status__c='Active';
            objUserInfusionDates.Infusion_Date__c = system.today()+3;
            insert objUserInfusionDates;
            
            User_Calendar__c objUser_Calendar = TestDataFactory.createUser_Calendar(false);
            objUser_Calendar.Event_Type__c ='LABTRACKER';
            objUser_Calendar.User_Infusion_Date_Id__c = objUserInfusionDates.Id;
            insert objUser_Calendar ;
            
            Test.StartTest();
            List<UserCalendarController.UserCalWrapper> lstUserCalWrap = UserCalendarController.getAllUsersCalenderRec(user.Id);
            system.assertEquals(1, lstUserCalWrap.size(),'User calendar call day is equals to zero');
            system.assertEquals('1', lstUserCalWrap[0].calday,'User calendar call day is equals to one');
            UserCalendarController.getAllUsersCalenderRecByPatientId(user.Id,objUserInfusionDates.Id);
            UserCalendarController.getLabtackerChartDetails(user.Id,objUserInfusionDates.Id);
            UserCalendarController.updateFeatureUsage('Calendar');
            UserCalendarController.getUserCalendarEventsByPatient(user.Id,objUserInfusionDates.Id);
            UserCalendarController.getUserCalendarEventsByPatient(user.Id,'all');
            Test.StopTest();
        }
    }
    static testmethod void getAllUsersCalenderAllRecs() {
        //@Description: Setup test data
        //@Description: This code runs as the system user
        User user= [Select id from User where UserName='standardusertest@novartis.com' Limit 1];
        System.runAs(user) {
            
            User_Infusion_Dates__c objUserInfusionDates  = new User_Infusion_Dates__c ();
            objUserInfusionDates.Name = 'Test user user infusion';
            objUserInfusionDates.OwnerId=user.Id;
            objUserInfusionDates.Status__c='Active';
            objUserInfusionDates.Infusion_Date__c = system.today()+3;
            insert objUserInfusionDates;
            User_Calendar__c objUser_Calendar = TestDataFactory.createUser_Calendar(false);
            objUser_Calendar.Event_Type__c ='LABTRACKER';
            objUser_Calendar.User_Infusion_Date_Id__c = objUserInfusionDates.Id;
            insert objUser_Calendar ;
            
            Test.StartTest();
            List<UserCalendarController.UserCalWrapper> lstUserCalWrap = UserCalendarController.getAllUsersCalenderAllRecs(user.Id);
            system.assertEquals(1, lstUserCalWrap.size(),'User calendar call day is equals to zero');
            system.assertEquals('1', lstUserCalWrap[0].calday,'User calendar call day is equals to one');
            /*  UserCalendarController.getAllUsersCalenderRecByPatientId(user.Id,objUserInfusionDates.Id);
UserCalendarController.getLabtackerChartDetails(user.Id,objUserInfusionDates.Id);
UserCalendarController.updateFeatureUsage('Calendar');
UserCalendarController.getUserCalendarEventsByPatient(user.Id,objUserInfusionDates.Id);
UserCalendarController.getUserCalendarEventsByPatient(user.Id,'all'); */
            Test.StopTest();
        }
    }
    static testmethod void UserCalWrapperTest() {
        List<UserCalendarController.UserCalWrapper> usrList=new List<UserCalendarController.UserCalWrapper>();
        UserCalendarController.UserCalWrapper usr=new UserCalendarController.UserCalWrapper();
        User_Infusion_Dates__c objUser_Infusion_Dates = TestDataFactory.createUser_InfusionDate(true);
        usr.calday='01';
        usr.calInfusionDate=System.today();
        usr.calInfusionId=objUser_Infusion_Dates.id;
        usr.calweek='02';
        usr.chopintended='test';
        
        usr.doesDate1=system.today();
        usr.doesDate1_day='01';
        usr.doesDate1_week='02';
        usr.doesDate2=Date.parse('04/04/2022');
        usr.doesDate2_day='01';
        usr.doesDate2_week='03';
        usr.doesDate3=Date.parse('04/05/2022');
        usr.doesDate3_day='01';
        usr.doesDate3_week='04';
        usr.doesDate4=Date.parse('04/06/2022');
        usr.doesDate4_day='02';
        usr.doesDate4_week='05';
        usr.doseOfInfusion='testdoseinfusion';
        usr.isCHOPTable='testchop';
        usr.isDoseInfusionTable='testdoseinf';
        usr.isPLAQUETASTable='testplaq';
        usr.isTRANSAMINASASTable='testtrans';
        usr.paitentid='testpatientId';
        usr.paitentName='testpatientName';
        usr.platelets='testplatelets';
        //usr.recId='testrecid';
        usr.transaminasas_ALT='testalt';
        usr.transaminasas_ALT_CalVal='testcalval';
        usr.transaminasas_ALT_Ref='testaltref';
        usr.userInfustionDate=Date.parse('04/03/2022');
        usrList.add(usr);
        Test.startTest();
        List<UserCalendarController.UserCalWrapper> lstUserCalWrapper =UserCalendarController.updateDose(usrList);
        Test.stopTest();
        System.assertNotEquals(lstUserCalWrapper.size(), 0,'User calendar updated dose details is not eqauls to zero');
        
    }
}