({doInit: function(component, event, helper) {
        component.set('v.showcontent', 'false');
            window.setTimeout(
            $A.getCallback(function() {
                component.set('v.showcontent', 'true');
            }), 500);
},
	 userLogin : function(component, event, helper) {
          window.localStorage.setItem('activelink',''); 
        console.log( ' << userLogin'  );
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var uname = component.get("v.Username");
        var upass = component.get("v.Password");
         
         if($A.util.isEmpty(uname)){
             component.find("Id_spinner").set("v.class" , 'slds-hide');
             console.log('<<< in if');
             var toastEvent = $A.get("e.force:showToast");
             if(toastEvent) {
                 toastEvent.setParams({
                     type: 'error',
                     mode: 'pester',
                     message: 'Por favor, introduzca su nombre de usuario'
                 });
                 toastEvent.fire();
             }else{
                 alert('Por favor, introduzca su nombre de usuario');
             }
         }else if($A.util.isEmpty(upass)){
             component.find("Id_spinner").set("v.class" , 'slds-hide');
             console.log('<<< in if');
             var toastEvent = $A.get("e.force:showToast");
             if(toastEvent) {
                 toastEvent.setParams({
                     type: 'error',
                     mode: 'pester',
                     message: 'Por favor, introduzca su contraseña'
                 });
                 toastEvent.fire();
             }else{
                 alert('Por favor, introduzca su contraseña');
             }
         }else{
            var action = component.get("c.login");
            
             var pass = '';           
            action.setParams({
                username : uname,
                password :upass
            });
            
            action.setCallback(this, function(response){
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("From server: " + response.getReturnValue());
                     var urlEvent = $A.get("e.force:navigateToURL");
                     var siteContaxt=$A.get("$Label.c.sitecontext");
                     var openURL = siteContaxt+"zeolandingpage";
                    if(urlEvent) {
                        urlEvent.setParams({
                          "url": openURL
                        });
                        urlEvent.fire();
                    }else{
                        window.open(response.getReturnValue(),"_self")
                    }
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                     errors[0].message);
                            /*component.find('notifyId').showToast({
                                "variant": "Error",
                                "title": "Error!",
                                "message": "Error message: " + 
                                     errors[0].message
                            });*/
                            var toastEvent = $A.get("e.force:showToast");
                             if(toastEvent) {
                                 toastEvent.setParams({
                                     type: 'error',
                                     mode: 'pester',
                                     message: "Error message: " + 
                                     errors[0].message
                                 });
                                 toastEvent.fire();
                             }else{
                                 alert("Error message: " + 
                                     errors[0].message);
                             }
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            
            $A.enqueueAction(action);
            component.set("v.Username",'');
            component.set("v.Password",pass);
         }
    }
})