({
	doInit : function(component) {
        component.set('v.showcontent', 'false');
        component.set('v.showmsg', 'false');
        
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
        
        
         window.setTimeout(
            $A.getCallback(function() {
            	var userId = $A.get("$SObjectType.CurrentUser.Id");
    			var action = component.get("c.getPatientMap");
            action.setParams({
                "userId": userId
            });
            action.setCallback(this, function(data) {
                var result = data.getReturnValue()
                var opts = [];
                opts.push({
                    class: "optionClass",
                    label: "Seleccione el paciente...",
                    value: ""
                });
                for (var i in result) {
                    if (result[i] !== null) {
                        opts.push({
                            class: "optionClass",
                            label: result[i],
                            value: i
                        });
                    }
                }
                component.set("v.calList", opts);
                console.log(opts);
                component.set('v.showselect', 'true');                
            });
            $A.enqueueAction(action);
            }), 500);
        
    },
   onChange: function(cmp, evt, helper) {
  		console.log('@@@@@@@@@@@@@@');
        var valSel = cmp.get("v.valSel");
        console.log(cmp.get('v.valSel') + ' Id of record.');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var InfusionDateId = valSel;
     
     	try {
            var action = cmp.get("c.getPatientList");
            console.log(action);
            action.setParams({
                "userId": userId,
                "InfusionDateId": InfusionDateId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var rslt=response.getReturnValue();   
                    if(rslt.length > 0){
                        cmp.set("v.name", rslt[0].Name);
                        cmp.set("v.dateInfu", rslt[0].Infusion_Date__c);
                        cmp.set('v.showcontent', 'true');
                        cmp.set('v.showmsg', 'false');
                    }else{
                    	cmp.set('v.showcontent', 'false');
                        cmp.set('v.showmsg', 'true');
                    }
                    
                    
                } else if (state === "INCOMPLETE") {
                    alert('Response is Incompleted');
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " +
                                errors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }

    },
    handleSuccess : function(component, event, helper) {
        
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var checkCmp = component.find("delpatient");
        var delpatient=checkCmp.get("v.value");
        var pname = component.get("v.name");
        var pDate = component.get("v.dateInfu");       
        var action = component.get("c.updateInfuDate");
        var InfusionDateId = component.get("v.valSel");
            action.setParams({
                name : pname,
                dateInfu: pDate,
                delpatient:delpatient,
                InfusionDateId: InfusionDateId
            });
            
            action.setCallback(this, function(response){
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                
                if (state === "SUCCESS") {
                    component.find('notifLib').showToast({
                    "variant": "success",
                        "title": "Registro actualizado con éxito y el ID de referencia del paciente es: "+storeResponse.Patient_Reference_ID__c
                });
                // if storeResponse size is 0 ,display no record found message on screen.
                if (storeResponse.length == 0) {
                   // component.set("v.errorMsg", true);
                } else {
                    var siteContaxt=$A.get("$Label.c.sitecontext");
                    var openURL = '';
                    if(component.get("v.reqType") == 'labtracker'){
                        openURL = siteContaxt+"zoe-labtracker?c__id="+storeResponse.Id;;
                    }else{
                        openURL = siteContaxt+"zoe-calendar?c__id="+storeResponse.Id;
                    }
                   
                  window.open(openURL,"_self")
                }
                    
                    
                }
                else if (state === "INCOMPLETE") {
                   
                }
                
            });
            
            $A.enqueueAction(action);
        
    },
    saveRecord : function(component, event, helper) {
         var checkCmp = component.find("delpatient");
		 alert(checkCmp.get("v.value"));       
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