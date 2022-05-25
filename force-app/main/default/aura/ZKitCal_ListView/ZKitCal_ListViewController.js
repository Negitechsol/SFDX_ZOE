({
    doInit: function(component, event, helper) {
       var action = component.get("c.getSpecificFields");
        action.setParams({
            "PageLayoutName" : "Master_Configuration__c-ZKitCalculator"
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result=response.getReturnValue();
                console.log("success"+result); 
                component.set("v.fields",result);
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
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
    },
	handleClick:function(component, event, helper) {
        
        component.set("v.isModalOpen", true);
    },
    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id;
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Grabación creada",
            "message": "Registro de identificación: " + myRecordId
        });
        component.set("v.isModalOpen", false);
        var action = component.get("c.updateRecordtype");
        action.setParams({
            "recordId" : myRecordId,
            "recordTypename":"Z-Kit Calculator"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("success");    
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
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
        $A.get('e.force:refreshView').fire();
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    }
})