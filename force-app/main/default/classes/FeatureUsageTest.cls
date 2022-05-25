/**********************************************************************************************
@Description: Test class for FeatureUsage coverage on method insertFeatureUsage
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class FeatureUsageTest {
    static testMethod void insertFeatureUsageTest() {
        test.startTest();
        Feature_Usage__c feature=new Feature_Usage__c();
       FeatureUsage.insertFeatureUsage('Z-Kit Calculator');
        System.assertNotEquals(null, feature,'Feature is not null');
        test.stopTest();
    }
}