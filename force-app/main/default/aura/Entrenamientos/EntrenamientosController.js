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
      var action = component.get("c.gettrainings");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state' + state);
            if (state === 'SUCCESS') {
                
                var result = response.getReturnValue();
                console.log('***************  result ********************');
                console.log('result' + JSON.stringify(response.getReturnValue()));
                component.set('v.trainings', response.getReturnValue());
                
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
        window.setTimeout(
            $A.getCallback(function() {
                component.set('v.showcontent', 'true');
            }), 500);
    },
    
       
    
    insertInfo: function(component, event, helper) {
        var action = component.get("c.insertUserInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state insertInfo' + state);
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('result insertInfo' + result);
                console.log('result insertInfo' + JSON.stringify(response.getReturnValue()));
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message insertInfo: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error insertInfo");
                }
            }
        });
        $A.enqueueAction(action);
        
    },  openQuiz: function(component, event, helper) {
        console.log("Quiz model in openquiz",component.get("v.isModal"));
        console.log("Result model in openquiz",component.get("v.finalResultModel"));
        component.set("v.isModal", true);
        component.set("v.finalResultModel",false);
    },
    
    submitQuiz: function(component, event, helper) {
        component.set("v.isModal", false);
        console.log("Quiz model",component.get("v.isModal"));
        console.log("Result model",component.get("v.finalResultModel"));
        component.set("v.finalResultModel",false);
        var value1 = component.get("v.value1");
        var value2 = component.get("v.value2");
        var value3 = component.get("v.value3");
        var value4 = component.get("v.value4"); 
        
        //if(value1!=null && value2!=null && value3!=null && value4!=null )
        if(value1 && value2 && value3 && value4)       
        {
            var action = component.get("c.getSelectedOptions");
            action.setParams({
                value1: value1,
                value2: value2,
                value3: value3,
                value4: value4               
                
            });
           action.setCallback(this, function(response){
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var finalresult = response.getReturnValue();
                    if(finalresult!==null)
                    {
                        component.set("v.finalresult",finalresult);
                        component.set("v.finalResultModel",true);
                    }
                    console.log(finalresult+'final');    
                }
                else
                {
                    component.set("v.finalResultModel",false); 
                }
            });
            $A.enqueueAction(action);
        } 
        else
        {
            if(value1== ''||value2=='' || value3=='' || value4=='')
            {
                console.log("else entered inside if");
                component.set("v.isModal", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    type: 'Error',
                    mode: 'pester',
                    message: 'Por favor complete todas las preguntas',
                });
                toastEvent.fire();
            }
        } 
    },
    openQuiz2: function(component, event, helper) {
       
        component.set("v.isModal2", true);
        component.set("v.finalResultModel2",false);
    },
    
    submitQuiz2: function(component, event, helper) {
        component.set("v.isModal2", false);
        console.log("Quiz model",component.get("v.isModal2"));
        console.log("Result model",component.get("v.finalResultModel2"));
        component.set("v.finalResultModel2",false);
        var value1 = component.get("v.value21");
        var value2 = component.get("v.value22");
        var value3 = component.get("v.value23");
        var value4 = component.get("v.value24");
        var value5 = component.get("v.value25");
        var value6 = component.get("v.value26");
        var value7 = component.get("v.value27");
               
        //if(value1!=null && value2!=null && value3!=null && value4!=null )
        if(value1 && value2 && value3 && value4 && value5 && value6 && value7)       
        {
            var action = component.get("c.getSelectedOptions2");
            action.setParams({
                value1: value1,
                value2: value2,
                value3: value3,
                value4: value4,
                 value5: value5,
                 value6: value6,
                 value7: value7
                
            });
           action.setCallback(this, function(response){
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var finalresult = response.getReturnValue();
                    if(finalresult!==null)
                    {
                        component.set("v.finalresult",finalresult);
                        component.set("v.finalResultModel2",true);
                    }
                    console.log(finalresult+'final');    
                }
                else
                {
                    component.set("v.finalResultModel2",false); 
                }
            });
            $A.enqueueAction(action);
        } 
        else
        {
            if(value1== ''||value2=='' || value3=='' || value4=='' ||value5==''||value6==''||value7=='' )
            {
                console.log("else entered inside if");
                component.set("v.isModal2", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    type: 'Error',
                    mode: 'pester',
                    message: 'Please Complete all the Questions',
                });
                toastEvent.fire();
            }
        } 
    },
      openQuiz3: function(component, event, helper) {
       
        component.set("v.isModal3", true);
        component.set("v.finalResultModel3",false);
    },
    
    submitQuiz3: function(component, event, helper) {
        component.set("v.isModal3", false);
        console.log("Quiz model",component.get("v.isModal3"));
        console.log("Result model",component.get("v.finalResultModel3"));
        component.set("v.finalResultModel3",false);
        var value1 = component.get("v.value31");
        var value2 = component.get("v.value32");
        var value3 = component.get("v.value33");
        var value4 = component.get("v.value34");
        var value5 = component.get("v.value35");
        var value6 = component.get("v.value36");
     
               
        //if(value1!=null && value2!=null && value3!=null && value4!=null )
        if(value1 && value2 && value3 && value4 && value5 && value6)      
        {
            var action = component.get("c.getSelectedOptions3");
            action.setParams({
                value1: value1,
                value2: value2,
                value3: value3,
                value4: value4,
                 value5: value5,
                 value6: value6
               
                
            });
           action.setCallback(this, function(response){
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var finalresult = response.getReturnValue();
                    if(finalresult!==null)
                    {
                        component.set("v.finalresult",finalresult);
                        component.set("v.finalResultModel3",true);
                    }
                    console.log(finalresult+'final');    
                }
                else
                {
                    component.set("v.finalResultModel3",false); 
                }
            });
            $A.enqueueAction(action);
        } 
        else
        {
            if(value1== ''||value2=='' || value3=='' || value4=='' ||value5==''||value6=='' )
            {
                console.log("else entered inside if");
                component.set("v.isModal3", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    type: 'Error',
                    mode: 'pester',
                    message: 'Por favor complete todas las preguntas',
                });
                toastEvent.fire();
            }
        } 
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
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false          
        component.set("v.finalResultModel", false);
        component.set("v.isModal", false);
        component.set("v.value1",'');
        component.set("v.value2",'');
        component.set("v.value3",'');
        component.set("v.value4",'');
        // window.location.reload();
        console.log("Quiz model in closeModel",component.get("v.isModal"));
        console.log("Result model in closeModel",component.get("v.finalResultModel"));
    },
     closeModel2: function(component, event, helper) {
        // Set isModalOpen attribute to false          
        component.set("v.finalResultModel2", false);
        component.set("v.isModal2", false);
        component.set("v.value21",'');
        component.set("v.value22",'');
        component.set("v.value23",'');
        component.set("v.value24",'');
        component.set("v.value25",''); 
        component.set("v.value26",'');
         component.set("v.value27",'');
        // window.location.reload();
        console.log("Quiz model in closeModel",component.get("v.isModal2"));
        console.log("Result model in closeModel",component.get("v.finalResultModel2"));
    },
      closeModel3: function(component, event, helper) {
        // Set isModalOpen attribute to false          
        component.set("v.finalResultModel3", false);
        component.set("v.isModal3", false);
        component.set("v.value31",'');
        component.set("v.value32",'');
        component.set("v.value33",'');
        component.set("v.value34",'');
        component.set("v.value35",''); 
        component.set("v.value36",'');

        // window.location.reload();
        console.log("Quiz model in closeModel",component.get("v.isModal3"));
        console.log("Result model in closeModel",component.get("v.finalResultModel3"));
    }
    
})