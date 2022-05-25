/**********************************************************************************************
@Description: Test class for MicrobatchSelfRegController coverage on method registerUser 
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest
 public with sharing class MicrobatchSelfRegControllerTest {
      @IsTest
     public static void testMicrobatchSelfRegController() {
         test.startTest();
         MicrobatchSelfRegController controller = new MicrobatchSelfRegController();
         controller.firstName = 'FirstName';
         controller.lastName = 'LastName';
         controller.email = 'test@force.com';
         controller.communityNickname = 'test';
         System.assert(controller.registerUser() == null, 'registerUser will always return null when the page isnt accessed as a guest user');
         test.stopTest();
     }
 }