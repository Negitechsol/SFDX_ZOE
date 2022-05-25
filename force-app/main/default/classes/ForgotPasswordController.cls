/**********************************************************************************************
@Description: An apex page controller that exposes the site forgot password functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class ForgotPasswordController {
    public String username {get; set;}   
    
    public ForgotPasswordController() {}
     //@Description: This method used for forgot password
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);
        PageReference pageReference = Page.ForgotPasswordConfirm;
        pageReference.setRedirect(true);
        
        if (success) {  			
            return pageReference;
        }
        return null;
    }
}