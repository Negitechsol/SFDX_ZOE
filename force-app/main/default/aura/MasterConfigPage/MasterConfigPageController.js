({
    doInit : function(component, event, helper) {
        // call apex method to fetch list view dynamically
        var action = component.get("c.listValues");
        action.setParams({
            "objectInfo" : component.get("v.objectInfo")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var listViewResult = response.getReturnValue();
                if(listViewResult.length > 0){
                    // set listViewResult attribute with response
                    component.set("v.listViewResult",listViewResult);
                    // set first value as default value
                    component.set("v.currentListViewName", listViewResult[0].developerName);
                    // rendere list view on component
                    component.set("v.recordTypeName", "Z-Kit Calculator");
                    component.set("v.bShowListView", true);
                    var fields=["Weight_Range__c","Vial5_5__c","Vial8_3__c","Viales_Totales__c"];
                    component.set("v.fields", fields);
                }            }
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
    
    onPicklistChange: function(component, event, helper) {
        // unrenders listView
        component.set("v.bShowListView", false);
        
        // get current selected listview Name
        var lstViewName = event.getSource().get("v.value");
        
        // set new listName for listView
        component.set("v.currentListViewName", lstViewName);
        if(lstViewName!="All"){
            component.set("v.recordTypeName", lstViewName);
            if(lstViewName == "Z-Kit Calculator"){
                var zkitfields=["Weight_Range__c","Vial5_5__c","Vial8_3__c","Viales_Totales__c"];
                component.set("v.fields", zkitfields);
            }
            if(lstViewName == "Training"){
                var trainingfields=["Training_Name__c","Type__c","Link__c"];
                component.set("v.fields", trainingfields);
            }
            if(lstViewName == "Calendar Activities"){
                var calendarfields=["Calendar_Activity__c","Calendar_Activity_desc__c","Calendar_Activity_duration__c"];
                component.set("v.fields", calendarfields);
            }
            if(lstViewName == "Infusion Center Master"){
                var infusionfields=["Infusion_Center_Id__c","Infusion_Center_Name__c","Infusion_Center_Address__c"];
                component.set("v.fields", infusionfields);
            }
            if(lstViewName == "Institution Master"){
                var institutionfields=["Institution_Id__c","Institution_Name__c"];
                component.set("v.fields", institutionfields);
            }
        }else{
            component.set("v.recordTypeName", "Z-Kit Calculator");
            var zkitcalfields=["Weight_Range__c","Vial5_5__c","Vial8_3__c","Viales_Totales__c"];
            component.set("v.fields", zkitcalfields);
        }
        
        
        
        // rendere list view again with new listNew  
        component.set("v.bShowListView", true);
    },
    handleClick:function(component, event, helper) {
        
        component.set("v.isModalOpen", true);
    },
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "record Created",
            "message": "Record ID: " + event.getParam("id")
        });
        component.set("v.isModalOpen", false);
        var action = component.get("c.updateRecordtype");
        action.setParams({
            "recordId" : event.getParam("id"),
            "recordTypename":component.get("v.recordTypeName")
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