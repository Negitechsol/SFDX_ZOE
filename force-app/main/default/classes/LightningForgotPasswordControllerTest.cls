/**********************************************************************************************
@Description: Test class for LightningForgotPasswordController coverage on method forgotPassword

----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest
public with sharing class LightningForgotPasswordControllerTest {

 /* Verifies that ForgotPasswordController handles invalid usernames appropriately */
 @IsTest
 static void testLightningForgotPasswordControllerInvalidUserName() {
     test.startTest();
  System.assertEquals(LightningForgotPasswordController.forgotPassword('fakeUser', 'http://a.com'), Label.Site.invalid_email,'Forgotpassword method to check the response for test data');
  System.assertEquals(LightningForgotPasswordController.forgotPassword(null, 'http://a.com'), Label.Site.invalid_email,'Forgotpassword method to check the response for test data');
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a', '/home/home.jsp'), Label.Site.invalid_email,'Forgotpassword method to check the response for test data');
     test.stopTest();
 }

 /* Verifies that null checkEmailRef url throws proper exception. */
 @IsTest
 static void testLightningForgotPasswordControllerWithNullCheckEmailRef() {
     test.startTest();
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a', null),'Argument 1 cannot be null','Condition will be true');
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a@salesforce.com', null), 'Argument 1 cannot be null','Condition will be true');
     test.stopTest();
 }

 /* Verifies that LightningForgotPasswordController object is instantiated correctly. */
 @IsTest
 static void LightningForgotPasswordControllerInstantiation() {
     test.startTest();
  LightningForgotPasswordController controller = new LightningForgotPasswordController();
  System.assertNotEquals(controller, null,'Empty initialization');
     test.stopTest();
 }
    
    
 @IsTest
 static void setExperienceIdTest() {
     test.startTest();
  String result=LightningForgotPasswordController.setExperienceId('12345');
     System.assertNotEquals(null,result,'result is not empty');
     test.stopTest();
 }
}