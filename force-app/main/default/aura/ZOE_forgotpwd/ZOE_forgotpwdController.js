({    doInit : function(component, event, helper) {
            component.set('v.showcontent', 'false');
            window.setTimeout(
            $A.getCallback(function() {
                component.set('v.showcontent', 'true');
            }), 500);
   },
	resetpwd : function(component, event, helper) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var uname = component.get("v.username");
         //var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
      
      //var regExpEmailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;

  
        console.log(uname+'uname');
        if($A.util.isEmpty(uname)){
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            console.log('<<< in if');
       		component.set("v.hasError", true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: 'error',
                mode: 'pester',
                message: 'Por favor, introduzca su nombre de usuario'
            });
            toastEvent.fire();
        }else{
            //if(uname.match(regExpEmailformat)){
            //    console.log('entered');
            //}
            
            var action = component.get("c.forgotPassword");
                    
            action.setParams({
                strusername : uname
            });
            
            action.setCallback(this, function(response){
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("From server: " + response.getReturnValue());
                    if(response.getReturnValue()=='success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: 'success',
                        mode: 'pester',
                        message: 'Se ha enviado un correo electrónico a su dirección de correo electrónico.'
                    });
                    toastEvent.fire();
                    }
                    if(response.getReturnValue()=='fail'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: 'error',
                        mode: 'pester',
                        message: 'El usuario no existe'
                    });
                    toastEvent.fire();
                    }
                    var urlEvent = $A.get("e.force:navigateToURL");
                    var siteContaxt=$A.get("$Label.c.siteurl");
                 
                    var openURL = siteContaxt;  
                    
                    urlEvent.setParams({
                      "url": openURL
                    });
                    urlEvent.fire();
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
                            component.find('notifyId').showToast({
                                "variant": "Error",
                                "title": "¡Error!",
                                "message": "Mensaje de error: " + 
                                     errors[0].message
                            });
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            
            $A.enqueueAction(action);
            component.set("v.Username",'');
        }
        
        
	}
})