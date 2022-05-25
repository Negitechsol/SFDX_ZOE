({
    doInit: function(cmp, event, helper) {
        cmp.set('v.showcontent', 'false');
        window.localStorage.setItem('activelink', '');
        try {
            var userlanguage = window.localStorage.getItem('userlanguage');
            if (userlanguage != '') {
                cmp.set("v.userlanguage", userlanguage);
                var langAppEvent = $A.get("e.c:LanguageEvent");
                langAppEvent.setParams({
                    "selectedLanguage": userlanguage
                });
                langAppEvent.fire();
            }
        } catch (e) {
            console.log(e);
        }

        window.setTimeout(
            $A.getCallback(function() {
                cmp.set('v.showcontent', 'true');
            }), 500);

        var action = cmp.get("c.getInfusionCenterDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state  *************' + state);
            if (state === 'SUCCESS') {

                var result = response.getReturnValue();
                console.log('result '+result);
                var jsonlist = [];
                for (var i in result) {

                    if(typeof result[i] === 'string'){
                    console.log(JSON.parse(result[i]));
                    jsonlist.push(JSON.parse(result[i]));
                }
            }

                
                cmp.set('v.mapMarkers', jsonlist);
                cmp.set('v.center', {
                    location: {
                        City: 'Buenos Aires'
                    }
                });
                cmp.set('v.zoomLevel', 10);
                cmp.set('v.markersTitle', 'Centros de Infusión en Argentina');
                cmp.set('v.showFooter', true);

            } else if (state === "ERROR") {
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

        cmp.set('v.zoomLevel', 4);
        cmp.set('v.markersTitle', 'Salesforce locations in United States');
        cmp.set('v.showFooter', false);

    },
    openTrackerModal: function(component, event, helper) {
        component.set("v.isLabModalOpen", true);
    },
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.isLabModalOpen", false);
    },
    openCal: function(component, event, helper) {
        try {
            var action = component.get("c.updateFeatureUsage");
            action.setParams({
                "eventName": 'Virtual Assistant',
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
        var siteContaxt=$A.get("$Label.c.sitecontext");
        var openURL = siteContaxt+"zoe-calendar";
        window.open(openURL, "_self");
    },
    editpatient: function(component, event, helper) {
        try {
            var action = component.get("c.updateFeatureUsage");
            action.setParams({
                "eventName": 'Infusion Date',
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }

        var siteContaxt=$A.get("$Label.c.sitecontext");
        var openURL = siteContaxt+"editpatient";

        var urlEvent = $A.get("e.force:navigateToURL");
        if (urlEvent) {
            urlEvent.setParams({
                "url": openURL
            });
            urlEvent.fire();
        } else {
        /*    window.open(response.getReturnValue(), "_self") */
        }
    },
     editpatientlab: function(component, event, helper) {
        try {
            var action = component.get("c.updateFeatureUsage");
            action.setParams({
                "eventName": 'Infusion Date',
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }

        var siteContaxt=$A.get("$Label.c.sitecontext");
        var openURL = siteContaxt+"editpatient?reqType=labtracker";

        var urlEvent = $A.get("e.force:navigateToURL");
        if (urlEvent) {
            urlEvent.setParams({
                "url": openURL
            });
            urlEvent.fire();
        } else {
        /*    window.open(response.getReturnValue(), "_self") */
        }
    },
    openCalInfDate: function(component, event, helper) {
        try {
            var action = component.get("c.updateFeatureUsage");
            action.setParams({
                "eventName": 'Infusion Date',
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }

        var siteContaxt=$A.get("$Label.c.sitecontext");
        var openURL = siteContaxt+"newuserinfusiondate";

        var urlEvent = $A.get("e.force:navigateToURL");
        if (urlEvent) {
            urlEvent.setParams({
                "url": openURL
            });
            urlEvent.fire();
        } else {
        /*    window.open(response.getReturnValue(), "_self") */
        }
    },
    openLabInfDate: function(component, event, helper) {
        try {
            var action = component.get("c.updateFeatureUsage");
            action.setParams({
                "eventName": 'Infusion Date',
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
        var siteContaxt=$A.get("$Label.c.sitecontext");
        var openURL = siteContaxt+"newuserinfusiondate?reqType=labtracker";
        var urlEvent = $A.get("e.force:navigateToURL");
        if (urlEvent) {
            urlEvent.setParams({
                "url": openURL
            });
            urlEvent.fire();
        } else {
           /*    window.open(response.getReturnValue(), "_self") */
        }
    },
    handleLanguageChangeEvent: function(component, event, helper) {
        console.log("handleLanguageChangeEvent");
        var currentLanguage = event.getParam("selectedLanguage");
        console.log("currentLanguage" + currentLanguage);
        component.set("v.userlanguage", currentLanguage);
        window.localStorage.setItem('userlanguage', currentLanguage);
    },
    showModal: function(component, event, helper) {
        var action = component.get("c.getDosage");
        //action.setParams({ weight : component.get("v.weight") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state' + state);
            if (state === 'SUCCESS') {
                var weightranges = [];
                var result = response.getReturnValue();
                console.log('result');
                console.log('result' + JSON.stringify(response.getReturnValue()));
                component.set('v.dosagemap', response.getReturnValue());
                var conts = response.getReturnValue();
                var i = 1;
                for (var key in conts) {
                    if (i == 1) {
                        weightranges.push({
                            id: i,
                            label: key,
                            selected: true
                        });
                        var dosages = conts[key].split("-");
                        var dose5 = dosages[0];
                        var dose8 = dosages[1];
                        var total = dosages[2];
                        component.set("v.dose5", dose5);
                        component.set("v.dose8", dose8);
                        component.set("v.totaldose", total);
                    } else {
                        weightranges.push({
                            id: i,
                            label: key
                        });
                    }

                    i++;
                }
                component.set('v.weightRanges', weightranges);

            } else if (state === "ERROR") {
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
        component.set("v.showZx", true);
        component.set("v.showResult", true);
    },
    hideModal: function(component, event, helper) {
        component.set("v.showZx", false);
    },
    onChange: function(component, event, helper) {
        var selectedval = component.find('select').get('v.value');
        component.set("v.selectedRange", selectedval);
        var resultvalue = component.get("v.dosagemap");
        console.log("resultvalue" + resultvalue);
        var dosages = resultvalue[selectedval].split("-");
        var dose5 = dosages[0];
        var dose8 = dosages[1];
        var total = dosages[2];
        component.set("v.dose5", dose5);
        component.set("v.dose8", dose8);
        component.set("v.totaldose", total);
        component.set("v.showResult", true);
    },

    handleClick: function(component, event, helper) {
        var weightinKG = component.get("v.weight");
        var weighttakenDate = component.get("v.takenDate");
        console.log('weight ' + weightinKG);
        console.log('weighttakendate' + weighttakenDate);
        var action = component.get("c.calculateDosage");
        action.setParams({
            weight: component.get("v.weight")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state' + state);
            if (state === 'SUCCESS') {

                var result = response.getReturnValue();
                console.log('result');
                component.set("v.dosage", result);

            } else if (state === "ERROR") {
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
        component.set("v.showResult", true);
  },
    openTracker: function(component, event, helper) {
        var siteContaxt=$A.get("$Label.c.sitecontext");
        var openURL = siteContaxt+"zoe-labtracker";
        window.open(openURL, "_self")
    },
})