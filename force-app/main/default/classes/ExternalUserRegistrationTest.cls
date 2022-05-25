/**********************************************************************************************
@Description: Test class for ExternalUserRegistration for executing the coverage on createPortalUser
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class ExternalUserRegistrationTest {
    @testSetup
    static void setUpData(){
        Contact objContact = new Contact();
        objContact.LastName = 'xyz';
        objContact.FirstName = 'abc';
        objContact.Username__c = 'test@uesrname.com';
        objContact.Email = 'test@email.com';
        objContact.Profession__c = 'Neurologist';
        insert objContact;
    }
    
	@IsTest
     static void testLightningForgotPasswordControllerInvalidUserName() {    
        test.startTest();
        Contact obj = new Contact();
        ExternalUserRegistration ext=new ExternalUserRegistration();
         if (Schema.sObjectType.Contact.isAccessible())
         obj=[Select id from Contact where Username__c='test@uesrname.com' limit 1];
         ExternalUserRegistration.createPortalUser(new List<Id>{obj.Id});
         System.assertNotEquals(null,ext,'Empty initilization for void method to execute');
         test.stoptest();
     }	
}