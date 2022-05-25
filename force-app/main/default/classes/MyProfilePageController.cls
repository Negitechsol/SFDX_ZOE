/**********************************************************************************************
@Description: An apex page controller that features the update the profile details
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class MyProfilePageController {

    private User user;
    private boolean isEdit = false;

    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
        if (Schema.sObjectType.User.isAccessible()){
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId() WITH SECURITY_ENFORCED];
        }
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }

    public Boolean getIsEdit() {
        return isEdit;
    }

    public void edit() {
        isEdit=true;
    }

    public void save() {
        try {
            if (Schema.sObjectType.User.isUpdateable()){
            update user;
            }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }

    public PageReference changePassword() {
        return Page.ChangePassword;
    }

    public void cancel() {
        isEdit=false;
        //if (Schema.sObjectType.User.isAccessible())
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId() WITH SECURITY_ENFORCED];
    }    
}