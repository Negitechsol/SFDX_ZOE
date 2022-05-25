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
         /*  window.open(response.getReturnValue(), "_self")  */
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
          /*  window.open(response.getReturnValue(), "_self")  */
        }
    },
    openTracker: function(component, event, helper) {
        var siteContaxt=$A.get("$Label.c.sitecontext");
        var openURL = siteContaxt+"zoe-labtracker";
        window.open(openURL, "_self")
    },
    handleLanguageChangeEvent: function(component, event, helper) {
        console.log("handleLanguageChangeEvent");
        var currentLanguage = event.getParam("selectedLanguage");
        console.log("currentLanguage" + currentLanguage);
        component.set("v.userlanguage", currentLanguage);
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
    }
})