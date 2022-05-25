({
    doInit: function(component, event, helper) {
        component.set('v.showcontent', 'false');
        try {
            var userlanguage = window.localStorage.getItem('userlanguage');
            if (userlanguage != '') {
                component.set("v.userlanguage", userlanguage);
                component.set("v.selectedlanguage", userlanguage);
                if (userlanguage == 'English') {
                    component.find("one").set("v.label", "Indication");
                    component.find("two").set("v.label", "Basal Laboratories");
                    component.find("three").set("v.label", "Reception and handling");
                }
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
    
    bannerimg: function(component, event, helper) {
       
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
    handleLanguageChangeEvent: function(component, event, helper) {
        console.log("handleLanguageChangeEvent");
        var currentLanguage = event.getParam("selectedLanguage");
        console.log("currentLanguage" + currentLanguage);
        component.set("v.userlanguage", currentLanguage);
    },
    handleActive: function(cmp, event, helper) {
        helper.loadTabs(cmp, event);
    },
    activeLink: function(component, event, helper) {
        var idx = event.target.id;
        if (idx == 'QUICKLINK') {
            window.localStorage.setItem('activelink', '');
        } else {
            window.localStorage.setItem('activelink', idx);
        }
    }
})