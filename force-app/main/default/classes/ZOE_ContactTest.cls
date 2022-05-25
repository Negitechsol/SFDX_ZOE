/**********************************************************************************************
@Description: Test class for ZOE_Contact coverage on method ZOEHeaderController
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class ZOE_ContactTest {
	@isTest static void currentUserRoleTest() {
        test.startTest();
            ZOE_Contact__c objZOE = ZOE_Contact.createZOE_Contact('Test Name','test@novartis.com');
        	system.assert(objZOE.Name!= '' ,'Test Name');
        test.stoptest();
    }
}