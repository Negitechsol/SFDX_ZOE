({
	openEntrenamientos: function(component, event, helper) {
       var siteContaxt=$A.get("$Label.c.sitecontext");
       var openURL = siteContaxt+"entrenamientos";      
       var urlEvent = $A.get("e.force:navigateToURL");
       if(urlEvent) {
           urlEvent.setParams({
               "url": openURL
           });
           urlEvent.fire();
       }else{
        /*   window.open(response.getReturnValue(),"_self") */
       }
   },
    handleLanguageChangeEvent : function(component, event, helper) {
        //alert('inside language event');
        console.log("handleLanguageChangeEvent");
        var currentLanguage = event.getParam("selectedLanguage");
         console.log("currentLanguage"+currentLanguage);
       // alert('selectedLanguage from event in parent'+currentLanguage)
        component.set("v.userlanguage", currentLanguage);
    }
})