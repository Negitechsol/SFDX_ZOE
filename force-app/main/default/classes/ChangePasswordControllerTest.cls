/**********************************************************************************************
@Description: A test class for ChangePasswordController to check the change password method execution
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest public with sharing class ChangePasswordControllerTest {
   	@IsTest public static void testChangePasswordController() {
        test.startTest();
        //@description: Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                 
        System.assertEquals(controller.changePassword(),null,'Password return method is not empty');
         
        test.stoptest();
    }    
}