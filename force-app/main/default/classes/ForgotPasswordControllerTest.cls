/**********************************************************************************************
@Description: Test class for ForgotPasswordController coverage on method forgotPassword
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest public with sharing class ForgotPasswordControllerTest {
  	 @IsTest public static void testForgotPasswordController() {
         test.startTest();
    	//@Description: Instantiate a new controller with all parameters in the page
    	ForgotPasswordController controller = new ForgotPasswordController();
    	controller.username = 'test@salesforce.com';
    	System.assertEquals(controller.forgotPassword(),null,'Forgot password return value is null');
         test.stopTest();
    }
}