/**********************************************************************************************
@Description: Test class for LightningLoginFormController coverage on method login and other
authentication features
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest
public with sharing class LightningLoginFormControllerTest {

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
     test.startTest();
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null,'Empty initialization');
     test.stopTest();
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
     test.startTest();
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled(),'Returns true from the method');
     test.stopTest();
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
     test.startTest();
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled(),'Returns false from the method');
     test.stopTest();
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
     test.startTest();
  System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl(),'Returns null from the method');
     test.stopTest();
 }

 @IsTest
 static void testAuthConfig() {
     test.startTest();
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig,'Returns null from the method');
     test.stopTest();
 }
    
    @IsTest
 static void loginTest() {
     test.startTest();
  String authConfig = LightningLoginFormController.login('test@username.com','pass@123','www.test.com');
   System.assertEquals(null, authConfig,'Returns null from the method');  
  	 test.stopTest();
 }
    @IsTest
 static void setExperienceIdTest() {
     test.startTest();
  String result=LightningLoginFormController.setExperienceId('12345');
     System.assertNotEquals(null,result,'Returns null from the method');
  	 test.stopTest();
 }
    @IsTest
 static void getForgotPasswordUrlTest() {
     test.startTest();
  String result=LightningLoginFormController.getForgotPasswordUrl();
  System.assertEquals(null, result,'Returns null from the method');  
     test.stopTest();
 }
}