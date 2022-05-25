/**********************************************************************************************
@Description: An apex page controller that exposes the site login functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest public with sharing class SiteLoginControllerTest {
    @IsTest public static void testSiteLoginController () {
        Test.startTest();
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        System.assertEquals(controller.login(),null,'Returns null for login method');
        Test.stopTest();
    }    
}