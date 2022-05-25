({
   doInit : function(component, event, helper) {
       component.set('v.showcontent', 'false');
          try{
            var userlanguage = window.localStorage.getItem('userlanguage');
            if(userlanguage!=''){
                component.set("v.userlanguage", userlanguage);
                component.set("v.selectedlanguage", userlanguage);
                var langAppEvent = $A.get("e.c:LanguageEvent");       
                langAppEvent.setParams({
                    "selectedLanguage" : userlanguage 
                });
                langAppEvent.fire();
                    }
        }catch(e){
            console.log(e);
        }
        window.setTimeout(
          $A.getCallback(function() {
             component.set('v.showcontent', 'true');
        }), 500);
    },
    handleLanguageChangeEvent : function(component, event, helper) {
      //  alert('inside language event');
        console.log("handleLanguageChangeEvent");
        var currentLanguage = event.getParam("selectedLanguage");
         console.log("currentLanguage"+currentLanguage);
       // alert('selectedLanguage from event in parent'+currentLanguage)
        component.set("v.userlanguage", currentLanguage);
    }
})