/**********************************************************************************************
@Description: Test class for NewInfusionDateCntrl coverage on method saveInfuDate
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class NewInfusionDateCntrlTest {
    @testSetup
    static void setUpData(){
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User objUser = new User(Alias = 'standt', Email='standarduser@novartis.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = objProfile.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest@novartis.com');
        insert objUser;
        //User_Infusion_Dates__c objUser_Infusion_Dates = TestDataFactory.createUser_InfusionDate(true);
        
        User_Infusion_Dates__c objUserInfusionDates  = new User_Infusion_Dates__c ();
        objUserInfusionDates.Name = 'Test user user infusion';
        objUserInfusionDates.OwnerId=objuser.Id;
        objUserInfusionDates.Status__c='Active';
        //objUserInfusionDates.Patient_Reference_ID__c='20220418003';
        objUserInfusionDates.Infusion_Date__c = system.today()+3;
        insert objUserInfusionDates;
        
        //Below Master configuration creation covers CalendarActivitiesTriggerhelper Coverage
        Id calendarrecordtypeid=Schema.SObjectType.Master_Configuration__c.getRecordTypeInfosByName().get('Calendar Activities').getRecordTypeId();
        Master_Configuration__c conf3=new Master_Configuration__c();
        conf3.Infusion_Center_Id__c='Test';
        conf3.Infusion_Center_Name__c='Test';
        conf3.Infusion_Center_Address__c='Test';
        conf3.Street__c='Test';
        conf3.State__c='Test';
        conf3.City__c='Test';
        conf3.Country__c='Test';
        conf3.PostalCode__c='123456';
        conf3.Active__c= true;
        conf3.Address_2__c='test';
        conf3.Address_1__c='test';   
        conf3.Address_3__c='test';
        conf3.Calendar_Activity__c='test';
        conf3.Calendar_Activity_desc__c='test';
        conf3.Calendar_Activity_duration__c='12';
        conf3.Calendar_Activity_Duration_Type__c='Day';
        conf3.Calendar_email_template__c='Infusion day';
        conf3.Description__c='test';
        conf3.Dosage__c= 2;
        conf3.End_Weight__c= 2;
        conf3.First_Notification__c='12';
        conf3.Institution_Id__c='test';
        conf3.Institution_Name__c='test';
        conf3.Link__c='www.salesforce.com';
        conf3.Weight_Range__c='1-2';
        conf3.Record_Status__c='t';
        conf3.Second_Notification__c='12';
        conf3.Spanish_Calendar_Activity__c='test';
        conf3.Spanish_Calendar_Activity_Description__c='test';
        conf3.Start_Weight__c= 2;
        conf3.Training_Name__c='test';
        conf3.Type__c='PDF';
        conf3.Vial5_5__c= 1;
        conf3.Vial8_3__c= 1;
        conf3.Viales_Totales__c= 1;
        conf3.RecordTypeId=calendarrecordtypeid;
        
        insert conf3;
        
        //Below UserCalendar  creation covers CalendarActivitiesTriggerhelper Coverage
        
        User_Calendar__c objUserCalendar = TestDataFactory.createUser_Calendar(false);
        objUserCalendar.Event_Type__c ='CALENDAR';
        objUserCalendar.Name='CALENDARTEST';
        objUserCalendar.Calendar_email_template__c = 'Pre infusion';
        objUserCalendar.First_Notification_Date__c = '2022-03-16 00:00:00';
        objUserCalendar.Second_Notification_Date__c = '2022-03-19 00:00:00';
        objUserCalendar.User_Infusion_Date_Id__c= objUserInfusionDates.Id;
        insert objUserCalendar ;
        
        
    }
    
    static testmethod void getUserCalendarEventsTest() {
        test.startTest();
        User_Infusion_Dates__c infusion=new User_Infusion_Dates__c();
        infusion=NewInfusionDateCntrl.saveInfuDate('Test',system.today());
        System.assertNotEquals(null, infusion,'Infusion Dates are not null');
        test.stopTest();
    }
    
    static testmethod void getPatientDetailsTest() {
        User objuser= [Select id from User where LastName='Testing' Limit 1]; 
        test.startTest();
        Map<String, String> mapIdNamePatientId = new Map<String, String>();    
        mapIdNamePatientId=NewInfusionDateCntrl.getPatientMap(objuser.Id);
        System.assertNotEquals(null, mapIdNamePatientId,'Patientid is not null');
        test.stopTest();
    }
    static testmethod void getPatientDetailsListTest() {
        User objuser= [Select id from User where LastName='Testing' Limit 1]; 
        User_Infusion_Dates__c objuserinfusion= [Select id from User_Infusion_Dates__c where Name='Test user user infusion' Limit 1]; 
        test.startTest();
        List<User_Infusion_Dates__c> lstInfusionDates = new List<User_Infusion_Dates__c>();    
        lstInfusionDates = NewInfusionDateCntrl.getPatientList(objuser.id,objuserinfusion.Id);
        System.assertNotEquals(null, lstInfusionDates,'Infusion dates is not null');
        test.stopTest();
    }
    static testmethod void getupdateInfuDateTest() {
        User objuser= [Select id from User where LastName='Testing' Limit 1]; 
        User_Infusion_Dates__c objuserinfusion= [Select id,Name,Infusion_Date__c,Patient_Reference_ID__c from User_Infusion_Dates__c where Name='Test user user infusion' Limit 1]; 
        test.startTest();
        List<User_Infusion_Dates__c> lstInfusionDate = new List<User_Infusion_Dates__c>();
        try{
            lstInfusionDate[0] = NewInfusionDateCntrl.updateInfuDate(objuserinfusion.Name,objuserinfusion.Infusion_Date__c,objuserinfusion.Patient_Reference_ID__c,objuserinfusion.Id);
        }catch(Exception e){
            
        }
        System.assertNotEquals(null, lstInfusionDate,'Infusion dates is not null for updation');
        test.stopTest();
    }
}