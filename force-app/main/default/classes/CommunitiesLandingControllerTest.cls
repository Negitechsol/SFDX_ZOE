/**********************************************************************************************
@Description: An apex page controller that takes the user to the right start page based on credentials or lack thereof
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest public with sharing class CommunitiesLandingControllerTest {
    @IsTest public static void testCommunitiesLandingController() {
        //@Description: Instantiate a new controller with all parameters in the page
        test.startTest();
        CommunitiesLandingController controller = new CommunitiesLandingController();
        PageReference pageRef = controller.forwardToStartPage();
        //@Description: PageRef is either null or an empty object in test context
        if(pageRef != null){
            String url = pageRef.getUrl();
            if(url != null){
                System.assertEquals(true, String.isEmpty(url),'check the url empty conditon');
                //@Description: show up in perforce
        test.stoptest();
            }
        }
    }
}