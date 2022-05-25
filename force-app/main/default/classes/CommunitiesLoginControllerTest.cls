/**********************************************************************************************
@Description: An apex page controller that exposes the site login functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest global with sharing class CommunitiesLoginControllerTest {
    @IsTest
    global static void testCommunitiesLoginController () {
        test.startTest();
        //@Description: Instantiate a new controller with all parameters in the page
     	CommunitiesLoginController controller = new CommunitiesLoginController();
     	System.assertEquals(null, controller.forwardToAuthPage(),'Returns an empty object'); 
        //@Description: show up in perforce
        test.stoptest();
    }    
}