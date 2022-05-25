/**********************************************************************************************
@Description: Test class for MyProfilePageController coverage on method save for updating the 
profile details
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@IsTest public with sharing class MyProfilePageControllerTest {

    @IsTest static void testSave() {
        // Modify the test to query for a portal user that exists in your org
        List<User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='CustomerSuccess'];

        if (existingPortalUsers.isEmpty()) {
            User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];
            MyProfilePageController controller = new MyProfilePageController();
            System.assertEquals(currentUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            System.assert(controller.getIsEdit() == false, 'isEdit should default to false');
            controller.edit();
            System.assert(controller.getIsEdit() == true,'Edit is possible as the return is true');
            controller.cancel();
            System.assert(controller.getIsEdit() == false,'Edit is not possible as the return is false');
            
            System.assert(Page.ChangePassword.getUrl().equals(controller.changePassword().getUrl()),'URL paths are mapped');
            
            String randFax = Math.rint(Math.random() * 1000) + '5551234';
            controller.getUser().Fax = randFax;
            controller.save();
            System.assert(controller.getIsEdit() == false,'Edit is not possible as the return is false');
            
            currentUser = [Select id, fax from User where id =: currentUser.Id];
            System.assert(currentUser.fax == randFax,'Fax number is tallied');
        } else {
            User existingPortalUser = existingPortalUsers[0];
            String randFax = Math.rint(Math.random() * 1000) + '5551234';

            System.runAs(existingPortalUser) {
                MyProfilePageController controller = new MyProfilePageController();
                System.assertEquals(existingPortalUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
                System.assert(controller.getIsEdit() == false, 'isEdit should default to false');
                controller.edit();
                System.assert(controller.getIsEdit() == true,'Edit is possible as the return is true');

                controller.cancel();
                System.assert(controller.getIsEdit() == false,'Edit is not possible as the return is false');

                controller.getUser().Fax = randFax;
                controller.save();
                System.assert(controller.getIsEdit() == false,'Edit is not possible as the return is false');
            }

            // verify that the user was updated
            existingPortalUser = [Select id, fax from User where id =: existingPortalUser.Id];
            System.assert(existingPortalUser.fax == randFax,'Fax number is tallied');
        }
    }
}