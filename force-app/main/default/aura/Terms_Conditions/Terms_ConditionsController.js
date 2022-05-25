({
	myAction : function(component, event, helper) {
		
	},
    handleLanguageChangeEvent : function(component, event, helper) {
        //alert('inside language event');
        console.log("handleLanguageChangeEvent in header");
        var currentLanguage = event.getParam("selectedLanguage");
         console.log("currentLanguage in header"+currentLanguage);
       // alert('selectedLanguage from event in parent'+currentLanguage)
        component.set("v.selectedlanguage", currentLanguage);
    }
})