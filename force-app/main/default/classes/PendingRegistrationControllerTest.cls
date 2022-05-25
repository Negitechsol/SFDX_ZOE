/**********************************************************************************************
@Description: Test class for PendingRegistrationController coverage on method rejectUser
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class PendingRegistrationControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        UserRole r = new UserRole(DeveloperName = 'ZOETest', Name = 'ZOETest');
		insert r;
        Test.stopTest();
    }
    static testMethod void approveUserTest() {
        Test.startTest();
        String firstname='Test';
        String surname='Test';
        String email='Test@zolgensma.com';
        String profession='Neurologist';
        String matricula='Test';
        List<String> institutionList=new List<String>{'Sample'};
        String institution=ZOE_LoginCntrl.registerUser( firstname,surname,email,profession,matricula,institutionList);
        System.assertNotEquals(null, institution,'Institution is not empty');
        List<Pending_Registrations__c> pendinguserList=PendingRegistrationController.fetchPendingUsers();
        System.assertNotEquals(pendinguserList.size(), 0,'Pending users list is not equals to zero');
        List<Pending_Registrations__c> fetch=PendingRegistrationController.approveUser(pendinguserList);
        System.assertEquals(fetch.size(), 0,'Pendingusers approval list is zero');
        Test.stopTest();           
    }
    static testMethod void rejectUserTest() {
        Test.startTest();
        String firstname='Test';
        String surname='Test';
        String email='Test@zolgensma.com';
        String profession='Neurologist';
        String matricula='Test';
        List<String> institutionList=new List<String>{'Sample'};
        String institution=ZOE_LoginCntrl.registerUser( firstname,surname,email,profession,matricula,institutionList);
        System.assertNotEquals(null, institution,'Institution is not empty');
        List<Pending_Registrations__c> pendinguserList=PendingRegistrationController.fetchPendingUsers();
        System.assertNotEquals(pendinguserList.size(), 0,'Pending users list is not equals to zero');
        String userlist=PendingRegistrationController.rejectUser(pendinguserList);
        System.assertNotEquals(null, userlist,'Userslist is not empty');
        Test.stopTest();        
        
    }
    
}