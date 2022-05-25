/**********************************************************************************************
@Description: An apex class that creates a portal user
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class SiteRegisterController {
    //@Description: PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    //@Description: you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
    private static Id portalAccountId = '001x000xxx35tPN';
    
    public SiteRegisterController () {
    }

    public String username {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    //@Description: Validate Password
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    public PageReference registerUser() {
        //@Description: it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
        	ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
        	ApexPages.addMessage(msg);
            return null;
        }    
        User u = new User();
        u.Username = username;
        u.Email = email;
        u.CommunityNickname = communityNickname;
        
        String accountId = portalAccountId;

        //@Description: lastName is a required field on user, but if it isn't specified, we'll default it to the username
        String userId = Site.createPortalUser(u, accountId, password);
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(username, password, null);
            }
            else {
                PageReference page = System.Page.SiteRegisterConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }
}