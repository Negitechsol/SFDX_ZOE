/**********************************************************************************************
@Description: An apex page controller that supports self registration of users in communities that allow self registration
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    @IsTest 
    public static void testCommunitiesSelfRegController() {
        test.startTest();
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
         System.assert(controller.registerUser() == null,'RegisterUser will always return null when the page isnt accessed as a guest user');   
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null,'RegisterUser will always return null when the page isnt accessed as a guest user');   
        test.stoptest();
    }    
}