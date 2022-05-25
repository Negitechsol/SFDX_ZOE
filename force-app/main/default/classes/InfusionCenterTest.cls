/**********************************************************************************************
@Description: Test class for InfusionCenter coverage on method getInfusionCenterDetails
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class InfusionCenterTest {
    @testSetup
    static void setUpData(){
        Id infusioncenterRecordTypeId=Schema.SObjectType.Master_Configuration__c.getRecordTypeInfosByName().get('Infusion Center Master').getRecordTypeId();
        Master_Configuration__c conf=new Master_Configuration__c();
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
        conf.Calendar_Activity__c='test';
        conf.Calendar_Activity_desc__c='test';
        conf.Calendar_Activity_duration__c='12';
        conf.Calendar_Activity_Duration_Type__c='Day';
        conf.Calendar_email_template__c='Infusion day';
        conf.Description__c='test';
        conf.Dosage__c= 2;
        conf.End_Weight__c= 2;
        conf.First_Notification__c='test';
        conf.Institution_Id__c='test';
        conf.Institution_Name__c='test';
        conf.Link__c='www.salesforce.com';
        conf.Weight_Range__c='1-2';
        conf.Record_Status__c='t';
        conf.Second_Notification__c='test';
        conf.Spanish_Calendar_Activity__c='test';
        conf.Spanish_Calendar_Activity_Description__c='test';
        conf.Start_Weight__c= 2;
        conf.Training_Name__c='test';
        conf.Type__c='PDF';
        conf.Vial5_5__c= 1;
        conf.Vial8_3__c= 1;
        conf.Viales_Totales__c= 1;
        conf.RecordTypeId=infusioncenterRecordTypeId; 
        insert conf;
    }
    static testMethod void getInfusionCenterDetailsTest() {
        test.startTest();
        List<Object> infusion=InfusionCenter.getInfusionCenterDetails(); 
        System.assertNotEquals(infusion.size(),0,'Infusion size is not empty');
        test.stopTest();
    }
}