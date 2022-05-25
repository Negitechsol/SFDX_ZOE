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
    selectChanged : function(component, event, helper) {
        console.log(component.find("selectItem").get("v.value"));
    },
    notify: function(component, event, helper) {
        
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var name = component.find("selectItem").get("v.value");
        var email = component.get("v.email");
       
        
        if($A.util.isEmpty(name)){
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            component.find('notifLib').showToast({
                                "variant": "Error",
                                "title": "Error!",
                                "message": "por favor, escriba su nombre "
                            });
        }
       else if($A.util.isEmpty(email)){
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            component.find('notifLib').showToast({
                                "variant": "Error",
                                "title": "Error!",
                                "message": "Por favor ingrese el correo electrónico"
                            });
        }
        else{
        
            var action = component.get("c.createZOE_Contact");
            
            
            action.setParams({
                strName : name,
                strEmail: email
            });
            action.setCallback(this, function(response){
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                debugger;
                if (state === "SUCCESS") {
                    console.log("From server: " + response.getReturnValue());
                    var lang=component.get("v.userlanguage");
                    var notification='Gracias por contactarnos.Nos estaremos comunicando con usted a la brevedad';       
                    if(lang == 'English'){
                        notification='Gracias por contactarnos en breve nos estaremos comunicando con usted';
                    }
                    component.find('notifLib').showToast({
                                "variant": "success",
                                "title": notification,
                                "duration":"5000",
                            });
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log(errors[0]);
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                     errors[0].message);
                            component.find('notifLib').showToast({
                                "variant": "Error",
                                "title": "Error!",
                                "message": "Error message: " + 
                                     errors[0].message
                            });
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            debugger;
            $A.enqueueAction(action);
            debugger;
        }
        
        
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