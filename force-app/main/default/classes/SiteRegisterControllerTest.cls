/**********************************************************************************************
@Description: Class containing tests for SiteRegisterController
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest public with sharing class SiteRegisterControllerTest {
    @IsTest static void testRegistration() {
        Test.startTest();
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        //@Description:  registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
        Test.stopTest();
    }
}