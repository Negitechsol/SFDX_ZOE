({
    init : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Identificación', fieldName: 'idVal',type: 'url',typeAttributes: {label: { fieldName: 'Id' }, target: '_top'}},
            {label: 'Nombre', fieldName: 'Name',  type: 'text'},
            {label: 'Primer nombre', fieldName: 'First_Name__c', type: 'text'},
            {label: 'Apellido', fieldName: 'Sur_Name__c', type: 'text'},
            {label: 'Nombre de usuario', fieldName: 'Username__c', type: 'text '},
            {label: 'Correo electrónico', fieldName: 'Email__c', type: 'text '},
            {label: 'Estado', fieldName: 'Status__c', type: 'text '}
            
        ]);
        var action = component.get("c.fetchPendingUsers");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                let baseUrl = 'https://'+location.host+'/';
                records.forEach(function(record){
                	record.idVal = baseUrl+record.Id;
                });

                component.set("v.data", records);
            }
        });
        $A.enqueueAction(action);
    },
    updateSelectedText:function(component, event, helper) {
         var selectedRows = event.getParam('selectedRows'); 
         component.set("v.selectedRows",selectedRows);
       
    },
    
    Approve : function(component, event, helper) {
        debugger;
      	var approvedusers=component.get("v.selectedRows");
        console.log(approvedusers); 
         var action = component.get("c.approveUser");
        if(approvedusers.length==0){
            console.log("empty"); 
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: 'error',
                        mode: 'pester',
                        message: 'Seleccione al menos un registro'
                    });
                    toastEvent.fire();    
        
        
            action.setParams({
                "pendinguserList":approvedusers
            });
            return false;
        }else{
             action.setParams({
                "pendinguserList":approvedusers
            });
            action.setCallback(this, function(response){
                //component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state === "SUCCESS") {
                    var responsevalue=response.getReturnValue();
                    component.set("v.data", response.getReturnValue());
                    console.log("From server: " +responsevalue);
                    //alert(response.getReturnValue());
                    //if(responsevalue == "Success"){
                      var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: 'success',
                        mode: 'pester',
                        message: 'Se ha enviado un correo electrónico a las direcciones de correo electrónico de los usuarios.'
                    });
                    toastEvent.fire();  
                    /*}else{
                        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: 'success',
                        mode: 'pester',
                        message: responsevalue
                    });
                    toastEvent.fire();
                    }*/
                    
                    
                    /*var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": "/OMS/s/zeologin"
                    });
                    urlEvent.fire();*/
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
                            toastEvent.setParams({
                                type: 'error',
                                mode: 'pester',
                                message: errors[0].message
                            });
                            toastEvent.fire();  
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            
            $A.enqueueAction(action);
        }
    },
    Reject : function(component, event, helper) {
    	var rejectedusers=component.get("v.selectedRows");
        console.log(rejectedusers); 
        var action = component.get("c.rejectUser");
           
        if(rejectedusers.length==0){
            console.log("empty"); 
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: 'error',
                        mode: 'pester',
                        message: 'Seleccione al menos un registro'
                    });
                    toastEvent.fire();    
        
        
            action.setParams({
                "pendinguserList":rejectedusers
            });
            return false;
        }
        else{
            action.setParams({
                "pendinguserList":rejectedusers
            });
        
            action.setCallback(this, function(response){
                //component.find("Id_spinner").set("v.class" , 'slds-hide');
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("From server: " + response.getReturnValue());
                   // alert(response.getReturnValue());
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: 'error',
                        mode: 'pester',
                        message: 'El registro ha sido rechazado con éxito'
                    });
                     $A.get('e.force:refreshView').fire();
                    toastEvent.fire();
                    
                    
                    /*var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": "/OMS/s/zeologin"
                    });
                    urlEvent.fire();*/
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
    }
 })