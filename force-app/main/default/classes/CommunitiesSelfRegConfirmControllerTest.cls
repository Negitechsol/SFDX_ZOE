/**********************************************************************************************
@Description:An apex page controller that takes the user to the right start page based on credentials or lack thereof
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest public with sharing class CommunitiesSelfRegConfirmControllerTest {
    @IsTest public static void testCommunitiesSelfRegConfirmController() {
        // @Description:Instantiate a new controller with all parameters in the page
        CommunitiesSelfRegConfirmController controller = new CommunitiesSelfRegConfirmController();
        //As the method is empty and will be intiated the method as and when the confirm 
         System.assertNotEquals(null,controller,'Empty initialization');   
      }    
}