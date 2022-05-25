/**********************************************************************************************
@Description: Test class for LightningLoginFormController coverage on method login and other
authentication features
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest
public with sharing class LightningSelfRegisterControllerTest {

 /* Verifies that IsValidPassword method with various password combinations. */
 @IsTest
 static void testIsValidPassword() {
     test.startTest();
  System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334') ==true,'False to be returned');
  System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', 'dummyPassword')==false,'False to be returned');
  System.assert(LightningSelfRegisterController.isValidPassword('password?@12334', null) ==false,'False to be returned');
  System.assert(LightningSelfRegisterController.isValidPassword(null, 'fakePwd')==false,'False to be returned');
     test.stopTest();
 }

 @IsTest
 static void testSiteAsContainerEnabled() {
     test.startTest();
     System.assertNotEquals(null, LightningSelfRegisterController.siteAsContainerEnabled('https://portaleu1-developer-edition.eu11.force.com'),'Returns not a null to siteAsContainerEnabled method ');
 	 test.stopTest();
 }

 /* Verifies the selfRegistration method flow with various invalid inputs */
 @IsTest
 static void testSelfRegistration() {
  Map < String, String > paramsMap = initializeParams();
     test.startTest();
  System.assertNotEquals(null, paramsMap,'Not a null value for ParamsMap');
  System.assertEquals(Label.Site.lastname_is_required, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), '', paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true),'Last name is required');
  System.assertEquals(Label.Site.email_is_required, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true),'Email is required');
  System.assertEquals(Label.Site.email_is_required, LightningSelfRegisterController.selfRegister(null, paramsMap.get('lastName'), '', null, paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true),'Firstname is required');
  System.assertEquals(Label.site.passwords_dont_match, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true),'Password Length is differed');
  System.assertNotEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false),'Not an empty response for successfull registration');
     test.stopTest();
 }


 /* Verifies the selfRegistration flow for valid inputs */
 @IsTest
 static void testSelfRegisterWithProperCredentials() {
     test.startTest();
  Map < String, String > paramsMap = initializeParams();
  System.assertEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true),'Registered if a null value is returned');
     test.stopTest();
 }

 /* Verifies SelfRegistration flow with an accounId that is created within the test */
 @IsTest
 static void testSelfRegisterWithCreatedAccount() {
     test.startTest();
  Account acc = new Account(name = 'test acc');
  insert acc;
  List < Account > accounts = [SELECT Id FROM Account LIMIT 1];
  System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
  String accountId = accounts[0].Id;
  Map < String, String > paramsMap = initializeParams();
  System.assertNotEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), accountId, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false),'Returns null and registers the record against to account id');
     test.stopTest();
 }

 @IsTest
 static void testGetNullExtraFields() {
     test.startTest();
  System.assertEquals(new List < Map < String, Object >> (), LightningSelfRegisterController.getExtraFields(null),'Returns a list');
     test.stopTest();
 }

 @IsTest
 static void testGetNonEmptyExtraFields() {
     test.startTest();
  System.assertEquals(new List < Map < String, Object >> (), LightningSelfRegisterController.getExtraFields('field1'),'Returns a list');
     test.stopTest();
 }

 /* Verifies validation of extraFields within the Self Registration flow */
 @IsTest
 static void testGetExtraFieldsInSelfRegistration() {
     test.startTest();
  List < Map < String, Object >> fieldlist = new List < Map < String, Object >> ();
  Map < String, String > paramsMap = initializeParams();
  Map < String, Object > fieldMap = new Map < String, Object > ();
  fieldMap.put('description', 'new field');
  fieldMap.put('fieldPath', 'dummyPath');
  fieldlist.add(fieldMap);
  String extraFields = JSON.serialize(fieldlist);
  System.assertNotEquals(null, LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true),'Returns null and selfregister with extrafields');
     test.stopTest();
 }

 @IsTest
 static void LightningSelfRegisterControllerInstantiation() {
     test.startTest();
  LightningSelfRegisterController controller = new LightningSelfRegisterController();
  System.assertNotEquals(controller, null,'Not a null');
     test.stopTest();
 }

 /* Helper method to initialize the parameters required for SelfRegistration. */
 private static Map < String, String > initializeParams() {
  Map < String, String > paramsMap = new Map < String, String > ();
  String firstName = 'test';
  String lastName = 'User';
  String email = 'testUser@salesforce.com';
  String password = 'testuser123';
  String confirmPasswordCorrect = 'testuser123';
  String confirmPasswordWrong = 'wrongpassword';
  String accountId = 'testuser123';
  String regConfirmUrl = 'http://registration-confirm.com';
  String startUrl = 'http://my.company.salesforce.com';
  paramsMap.put('firstName', firstName);
  paramsMap.put('lastName', lastName);
  paramsMap.put('email', email);
  paramsMap.put('password', password);
  paramsMap.put('confirmPasswordCorrect', confirmPasswordCorrect);
  paramsMap.put('confirmPasswordWrong', confirmPasswordWrong);
  paramsMap.put('accountId', accountId);
  paramsMap.put('regConfirmUrl', regConfirmUrl);
  paramsMap.put('startUrl', startUrl);
  return paramsMap;
 }
    @IsTest
 static void setExperienceIdTest() {
     test.startTest();
  String result=LightningSelfRegisterController.setExperienceId('12345');
  System.assertNotEquals(null,result,'Result is not null');
     test.stopTest();
 }
}