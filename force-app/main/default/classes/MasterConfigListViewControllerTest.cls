/**********************************************************************************************
@Description: An apex page controller that exposes the ZOE Master Configurations
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class MasterConfigListViewControllerTest {
    @testSetup
    static void setUpData(){
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
        conf.Weight_Range__c='2.6-3.0';
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
        insert conf;
    }
    
    static testMethod void listValuesTest() {
        test.startTest();
        List<string> fields=new List<string>();
        fields=MasterConfigListViewController.getSpecificFields('Master_Configuration__c-ZKitCalculator');
        System.assertNotEquals(fields.size(),0,'Zkitcalculator size is greater than zero');
        Master_Configuration__c masconf=[Select id from Master_Configuration__c where Weight_Range__c='2.6-3.0'];
        String result=MasterConfigListViewController.updateRecordtype(masconf.id, 'Z-Kit Calculator');
        System.assertEquals(null, result,'Result is null');
        String obj ='Master_Configuration__c';
        MasterConfigListViewController.listValues(obj);
         System.assertNotEquals((MasterConfigListViewController.listValues(obj)).size(), 0,'List is not empty');
        test.stopTest();
    }
}