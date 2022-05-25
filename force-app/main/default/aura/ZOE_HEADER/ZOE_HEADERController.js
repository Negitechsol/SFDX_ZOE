({
     doInit : function(component, event, helper) {
         var userId = $A.get("$SObjectType.CurrentUser.Id");
         component.set('v.showloader', 'false');
         window.setTimeout(
          $A.getCallback(function() {
             component.set('v.showloader', 'true');
        }), 200);
         component.set('v.showcontent', 'false');
            window.setTimeout(
            $A.getCallback(function() {
                component.set('v.showcontent', 'true');
            }), 500);
         var activelink = window.localStorage.getItem('activelink');
         if(activelink !=''){
             if(activelink == 'Pre-infusion'){
                 component.set("v.Preinfusion", "active");
                 component.set("v.Postinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink == 'Post-infusion'){
                 component.set("v.Postinfusion", "active");
                 component.set("v.Preinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink == 'Infusion'){
                 component.set("v.Infusion", "active");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink=='Training'){
                 component.set("v.Training", "active");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink=='Configuration'){
                 component.set("v.Configuration", "active");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Dashboard", "");
             }else if(activelink=='Dashboard'){
                 component.set("v.Dashboard", "active");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }else{
                 component.set("v.Dashboard", "");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }            
         }else{
                 component.set("v.Dashboard", "");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }
          try{
            var userlanguage = window.localStorage.getItem('userlanguage');
            if(userlanguage!=''){
                component.set("v.userlanguage", userlanguage);
                component.set("v.selectedlanguage", userlanguage);
                var langAppEvent = $A.get("e.c:LanguageEvent");       
                langAppEvent.setParams({
                    "selectedLanguage" : userlanguage 
                });
                langAppEvent.fire();
                    }
        }catch(e){
            console.log(e);
        }
         console.log('hostname'+window.location.hostname);
		 var action = component.get("c.currentUserRole");
         action.setCallback(this, function(response) {
        	var state = response.getState();
             console.log(response.getReturnValue());
             if (state === "SUCCESS") {
				component.set('v.linkMap',response.getReturnValue());                    
			 }
    	});
        $A.enqueueAction(action,true); 
    },
    
    mouseOver : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
                 component.set("v."+Name, "active");
    },
    mouseOut : function(component, event, helper) {
     		var activelink = window.localStorage.getItem('activelink');
         if(activelink !=''){
             if(activelink == 'Pre-infusion'){
                 component.set("v.Preinfusion", "active");
                 component.set("v.Postinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink == 'Post-infusion'){
                 component.set("v.Postinfusion", "active");
                 component.set("v.Preinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink == 'Infusion'){
                 component.set("v.Infusion", "active");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink=='Training'){
                 component.set("v.Training", "active");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink=='Configuration'){
                 component.set("v.Configuration", "active");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Dashboard", "");
             }else if(activelink=='Dashboard'){
                 component.set("v.Dashboard", "active");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }else{
                 component.set("v.Dashboard", "");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }            
         }else{
                 component.set("v.Dashboard", "");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }
    },
    handleLanguageChangeEvent : function(component, event, helper) {
       // alert('inside language event');
        console.log("handleLanguageChangeEvent in header");
        var currentLanguage = event.getParam("selectedLanguage");
         console.log("currentLanguage in header"+currentLanguage);
       // alert('selectedLanguage from event in parent'+currentLanguage)
        component.set("v.selectedlanguage", currentLanguage);
        window.localStorage.setItem('userlanguage', currentLanguage);
    },
    onLanguageChange: function (component, event, helper) {
        var languageSelected = component.find('select').get('v.value');
        console.log('languageSelected on change ZOE Header'+languageSelected);
        component.set("v.selectedlanguage", languageSelected);
        window.localStorage.setItem('userlanguage', languageSelected);
        var langAppEvent = $A.get("e.c:LanguageEvent");       
        //var languageCompEvent = component.getEvent("LanguageEvent");
        langAppEvent.setParams({
            "selectedLanguage" : languageSelected 
        });
        langAppEvent.fire();       
    },
    handleclick : function(component, event, helper){
        var selected = event.srcElement.text;
        console.log(selected);
    },
	myAction : function(component, event, helper) {
		
	},
     doneRendering: function(cmp, event, helper) {
       window.setTimeout(
           
        $A.getCallback(function() {
            $('.preloader').addClass('preloader-deactivate');
             $("#header_content").css('opacity','1');
             try{
            $('.home-slides').owlCarousel({
                loop: true,
                nav: true,
                dots: true,
                autoplayHoverPause: true,
                autoplay: true,
                smartSpeed: 750,
                autoHeight: true,
                items: 1,
                navText: [
                    "<i class='flaticon-left-chevron'></i>",
                    "<i class='flaticon-right-chevron'></i>"
                ],
            });
           jQuery('.mean-menu').meanmenu({
                meanScreenWidth: "991"
            });
           }catch(e){
               
           }
            var userId = $A.get("$SObjectType.CurrentUser.Id");
            console.log(userId);
        }), 2000
    );
          
  },
    activeLink: function(component, event, helper) {
    var idx = event.target.id;
        if(idx=='QUICKLINK'){
           window.localStorage.setItem('activelink','');  
        }else{
            window.localStorage.setItem('activelink',idx); 
        }
 },
 logout:function(component, event, helper) {
     var siteContaxt=$A.get("$Label.c.siteurl");
     siteContaxt=siteContaxt.replace('/s','');
     window.location.replace(siteContaxt+"?startURL=%2Fsecur%2Flogout.jsp");
 },
 handleMouseOver:function(component, event, helper) {
     var activelink = event.target.id;
         if(activelink !=''){
             if(activelink == 'Pre-infusion'){
                 component.set("v.Preinfusion", "active");
                 component.set("v.Postinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink == 'Post-infusion'){
                 component.set("v.Postinfusion", "active");
                 component.set("v.Preinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink == 'Infusion'){
                 component.set("v.Infusion", "active");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink=='Training'){
                 component.set("v.Training", "active");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink=='Configuration'){
                 component.set("v.Configuration", "active");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Dashboard", "");
             }else if(activelink=='Dashboard'){
                 component.set("v.Dashboard", "active");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }else{
                 component.set("v.Dashboard", "");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }            
         }else{
                 component.set("v.Dashboard", "");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }     
 },
 handleMouseOut:function(component, event, helper) {
     try{
     var activelink = window.localStorage.getItem('activelink');
         if(activelink !=''){
             if(activelink == 'Pre-infusion'){
                 component.set("v.Preinfusion", "active");
                 component.set("v.Postinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink == 'Post-infusion'){
                 component.set("v.Postinfusion", "active");
                 component.set("v.Preinfusion", "");
                 component.set("v.Infusion", "");
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink == 'Infusion'){
                 component.set("v.Infusion", "active");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Training", "");
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink=='Training'){
                 component.set("v.Training", "active");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Configuration", "");
                 component.set("v.Dashboard", "");
             }else if(activelink=='Configuration'){
                 component.set("v.Configuration", "active");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
                 component.set("v.Dashboard", "");
             }else if(activelink=='Dashboard'){
                 component.set("v.Dashboard", "active");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }else{
                 component.set("v.Dashboard", "");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }            
         }else{
                 component.set("v.Dashboard", "");
                 component.set("v.Configuration", "");
                 component.set("v.Training", "");
                 component.set("v.Infusion", "");
                 component.set("v.Postinfusion", "");
                 component.set("v.Preinfusion", ""); 
             }
         }catch(e){console.log(e);}
 }
})