/**********************************************************************************************
@Description: Test class for ZOEHeaderController coverage on method ZOEHeaderController and 
currentLanguage
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class ZOEHeaderControllerTest {
    @isTest static void currentUserRoleTest() {
        Test.startTest();
    	Map<String,Boolean> mapLinkBln  = ZOEHeaderController.currentUserRole();
        System.assertNotEquals(mapLinkBln.size(), 0,'Mapped links are not zero');
        Test.stopTest();
    }
    @isTest static void currentUserLangugaeTest() {
        Test.startTest();
       string userLangugae = ZOEHeaderController.currentLanguage();
       system.assert(userLangugae!=NULL,'User Langugae exist');
        Test.stopTest();
    }
     @isTest static void changeUserLanguageTest() {
         Test.startTest();
       ZOEHeaderController zoe=new ZOEHeaderController();
         ZOEHeaderController.changeLang('English');
         System.assertNotEquals(null, zoe,'Empty initialization');
         Test.stopTest();
    }
}