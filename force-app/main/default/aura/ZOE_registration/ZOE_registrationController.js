({	register : function(component, event, helper) {
        console.log('<< register');
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var firstName=component.get("v.name");
        var surName=component.get("v.surname");
        var email = component.get("v.email");
        var profession = component.find("profession").get("v.value");
        var matricula = component.get("v.matricula");
        var terms = component.get("v.terms");
        var instlist = component.get("v.selectedInstituteList");
           if($A.util.isEmpty(firstName)){
            component.find("Id_spinner").set("v.class" , 'slds-hide');
       		component.set("v.hasError", true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: 'error',
                mode: 'pester',
                message: 'Por favor, introduzca su nombre de pila'
            });
            toastEvent.fire();
        }
        else if($A.util.isEmpty(surName)){
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            console.log('<<< in if');
       		component.set("v.hasError", true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: 'error',
                mode: 'pester',
                message: 'Por favor ingrese su nombre Sur'
            });
            toastEvent.fire();
        }else if($A.util.isEmpty(email)){
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            console.log('<<< in if');
       		component.set("v.hasError", true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: 'error',
                mode: 'pester',
                message: 'Por favor introduzca su correo electrónico'
            });
            toastEvent.fire();
        }else{        
            var action = component.get("c.registerUser");
            action.setParams({
                primaryName: firstName,
                primarySurname: surName,
                email: email,
                profession : profession,
                matricula: matricula,
                institutionList:component.get("v.selectedInstituteList")
                

            });
            action.setCallback(this, function(response){
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("From server: " + response.getReturnValue());
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: 'success',
                        mode: 'pester',
                        message: 'Su solicitud para crear un usuario ha sido enviada.'
                    });
                    toastEvent.fire();
                    
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
                            console.log(errors[0]);
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                     errors[0].message);
                            component.find('notifyId').showToast({
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
            
            $A.enqueueAction(action);
            
        }
	},
    doInit : function(component, event, helper) {
        debugger;
            component.set('v.showcontent', 'false');
            window.setTimeout(
            $A.getCallback(function() {
                component.set('v.showcontent', 'true');
            }), 500);
        var action=component.get("c.getInstitutionName");
       action.setCallback(this,function(response){
            var state=response.getState();
            console.log('state'+state);
            if(state==='SUCCESS'){
                
                var result=response.getReturnValue();
                console.log('result');
                console.log('result'+JSON.stringify(response.getReturnValue()));
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.instituteList", plValues);
                
                 
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
        if( component.get("v.firstterms") == false 
         || component.get("v.secondterms") == false
         || component.get("v.thirdterms") == false ) {
			component.set("v.isDisable", true);
        } 
    },
    handleInstituteChange:function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
         
        //Update the Selected Values  
        component.set("v.selectedInstituteList", selectedValues);
    },
    // For Terms & Conditions
    opencModel: function(component, event, helper) {
      	
        console.log('terms data');
      var isChecked = component.find("cbFirst").get("v.checked");
        if(isChecked == true) {
            component.set("v.isModalOpen", true);
            component.set("v.firstterms", true);
        }else {
            component.set("v.isModalOpen", false);
            component.set("v.isDisable", true);
            component.set("v.firstterms", false);
        }
   },
  
   closecModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
       if( component.get("v.firstterms") == true 
          && component.get("v.secondterms") == true
          && component.get("v.thirdterms") == true ) {
           component.set("v.isDisable", false);
       }else{
           component.set("v.isDisable", true);
       }
   },
  
/*   submitDetails: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },  */
    // for privacy policies
    openModel: function(component, event, helper) {
      //component.set("v.isModal", true);
        console.log('privacy data');
        
         var isChecked = component.find("cbSecond").get("v.checked");
        if(isChecked == true) {
            component.set("v.isModal", true);
            component.set("v.secondterms", true);
        }else {
            component.set("v.isModal", false);
            component.set("v.isDisable", true);
            component.set("v.secondterms", false);
        }
   },
  
   closeModel: function(component, event, helper) {
      component.set("v.isModal", false);
       if( component.get("v.firstterms") == true 
          && component.get("v.secondterms") == true
          && component.get("v.thirdterms") == true ) {
           component.set("v.isDisable", false);
       }else{
           component.set("v.isDisable", true);
       }
   },
  thirdcb: function(component, event, helper) {
      //component.set("v.isModal", true);
        console.log('privacy data');
        
        var isChecked = component.find("cbThird").get("v.checked");
        if(isChecked == true) {
            component.set("v.thirdterms", true);
            if( component.get("v.firstterms") == true 
              && component.get("v.secondterms") == true ) {
               component.set("v.isDisable", false);
           }
        }else{
            component.set("v.thirdterms", false);
            component.set("v.isDisable", true);
        }
   },
   submitDetails: function(component, event, helper) {
      component.set("v.isModal", false);
   }
})