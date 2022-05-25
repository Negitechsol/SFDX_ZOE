({
    doInit: function(component, event, helper) {
        component.set('v.showcontent', 'false');
        try {
            var userlanguage = window.localStorage.getItem('userlanguage');
            if (userlanguage != '') {
                component.set("v.userlanguage", userlanguage);
                component.set("v.selectedlanguage", userlanguage);
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
                component.set('v.showcontent', 'true');
            }), 500);
    },
    openEntrenamientos: function(component, event, helper) {
        console.log('in open');
        var siteContaxt=$A.get("$Label.c.sitecontext");
        var openURL = siteContaxt+"entrenamientos";
        var urlEvent = $A.get("e.force:navigateToURL");
        if (urlEvent) {
            urlEvent.setParams({
                "url": openURL
            });
            urlEvent.fire();
        } else {
           /* window.open(response.getReturnValue(), "_self") */  
        }
    },
    handleLanguageChangeEvent: function(component, event, helper) {
        console.log("handleLanguageChangeEvent");
        var currentLanguage = event.getParam("selectedLanguage");
        console.log("currentLanguage" + currentLanguage);
        component.set("v.userlanguage", currentLanguage);
    },
    handleActive: function(cmp, event, helper) {
        helper.loadTabs(cmp, event);
    },
    showModal: function(component, event, helper) {
        var action = component.get("c.getDosage");
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
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
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
    openInfDate: function(component, event, helper) {
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
           /* window.open(response.getReturnValue(), "_self") */
        }
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    activeLink: function(component, event, helper) {
        var idx = event.target.id;
        if (idx == 'QUICKLINK') {
            window.localStorage.setItem('activelink', '');
        } else {
            window.localStorage.setItem('activelink', idx);
        }
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
    }
})