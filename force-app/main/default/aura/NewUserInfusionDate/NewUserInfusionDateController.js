({
	doInit : function(component) {
        console.log('<< in com'+decodeURIComponent(window.location.search.substring(1)));
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,i;
        
        		if( sPageURL !== '' ) {
                    window.localStorage.setItem('id', '');
                for (i = 0; i < sURLVariables.length; i++) {
                    sParameterName = sURLVariables[i].split('=');
                    console.log(sParameterName[1]);
                    try{
                        component.set("v.reqType", sParameterName[1]);
                    }catch(e){
                        console.log(e);
                    }
                }}
    },
    handleSuccess : function(component, event, helper) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var pname = component.get("v.name");
        var pDate = component.get("v.dateInfu");       
        var action = component.get("c.saveInfuDate");
            
            action.setParams({
                name : pname,
                dateInfu: pDate
            });
            
            action.setCallback(this, function(response){
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                
                if (state === "SUCCESS") {
                    component.find('notifLib').showToast({
                    "variant": "success",
                    "title": "Registro creado con éxito y el ID de referencia del paciente es "+storeResponse.Patient_Reference_ID__c
                });
                // if storeResponse size is 0 ,display no record found message on screen.
                if (storeResponse.length == 0) {
                   // component.set("v.errorMsg", true);
                } else {
                    var siteContaxt=$A.get("$Label.c.sitecontext");
                    var openURL = '';
                    if(component.get("v.reqType") == 'labtracker'){
                        openURL = siteContaxt+"zoe-labtracker?c__id="+storeResponse.Id;
                    }else{
                        openURL = siteContaxt+"zoe-calendar?c__id="+storeResponse.Id;
                    }
                   
                  window.open(openURL,"_self")
                }
                    
                    
                }
                else if (state === "INCOMPLETE") {
                    // do something
                   
                }
                
            });
            
            $A.enqueueAction(action);
        
    },
    saveRecord : function(component, event, helper) {
        debugger;
        component.set("v.propertyRecord.Name", component.find('propName').get("v.value"));    
        component.set("v.propertyRecord.Patient_Reference_ID__c", component.find('propId').get("v.value"));
        component.set("v.propertyRecord.Infusion_Date__c", component.find('propDate').get("v.value"));
        component.set("v.propertyRecord.Status__c", component.find('propStatus').get("v.value"));
        var tempRec = component.find("forceRecord");
        tempRec.saveRecord($A.getCallback(function(result) {
            console.log(result.state);
            var resultsToast = $A.get("e.force:showToast");
            if (result.state === "SUCCESS") {
                resultsToast.setParams({
                    "title": "Guardado con éxito",
                    "message": "El registro fue guardado."
                });
                resultsToast.fire();
                var siteContaxt=$A.get("$Label.c.sitecontext");
                var openURL = siteContaxt+"zoe-calendar";
 
               var urlEvent = $A.get("e.force:navigateToURL");
               if(urlEvent) {
                   urlEvent.setParams({
                       "url": openURL
                   });
                   urlEvent.fire();
               }else{
                /*   window.open(response.getReturnValue(),"_self") */
               }
            } else if (result.state === "ERROR") {
                console.log('Error: ' + JSON.stringify(result.error));
                resultsToast.setParams({
                    "title": "¡Error!",
                    "message": "Hubo un error al guardar el registro: " + JSON.stringify(result.error)
                });
                resultsToast.fire();
            } else {
                console.log('Unknown problem, state: ' + result.state + ', error: ' + JSON.stringify(result.error));
            }
        }));
	},
    cancelDialog : function(component, helper) {
        window.history.go(-1);
	},
   
    onkeypress: function(component, event, helper) {
        var selectedValue=  event.getSource().get("v.validity").valid;       
        if(!selectedValue){        
        	component.set('v.isInfBtnActive',true);
        }else{
            component.set('v.isInfBtnActive',false);
        }
      var fieldVal = component.get("v.name");
        if(fieldVal.toLocaleLowerCase().indexOf("script")!=-1){
	    component.set("v.name", '');
	  }
        
	  if(fieldVal.toLocaleLowerCase().indexOf("$('")!=-1){
		  console.log(fieldVal+'  :: Cross Site Scripting Not allowed');
		  component.set("v.name", '');
	  }
	  if(fieldVal.toLocaleLowerCase().indexOf("var ")!=-1 || fieldVal.toLocaleLowerCase().indexOf("const ")!=-1){
		  console.log(fieldVal+'  :: Cross Site Scripting Not allowed');
		  component.set("v.name", '');
	  }
    }
})