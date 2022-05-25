({
	myAction : function(component, event, helper) {
		
	},
    carouselLoad : function(component, event, helper) {
            $('.owl-carousel').owlCarousel({
                loop: false,
                nav: true,
                dots: true,
                autoplayHoverPause: true,
                autoplay: false,
                smartSpeed: 750,
                autoHeight: 400,
                items: 1,
                navText: [
                    "<i class='flaticon-left-chevron'></i>",
                    "<i class='flaticon-right-chevron'></i>"
                ],
            });
    },
    handleLanguageChangeEvent : function(component, event, helper) {
        //alert('inside language event');
        console.log("handleLanguageChangeEvent in footer");
        var currentLanguage = event.getParam("selectedLanguage");
         console.log("currentLanguage in footer"+currentLanguage);
       // alert('selectedLanguage from event in parent'+currentLanguage)
        component.set("v.userlanguage", currentLanguage);
    },
    //terms & CONDITIONS
    opencModel: function(component, event, helper) {
      component.set("v.isModalOpen", true);
   },
  
   closecModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },
  
 /*  submitDetails: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   }, */
    // for privacy policies
    openModel: function(component, event, helper) {
      component.set("v.isModal", true);
   },
  
   closeModel: function(component, event, helper) {
      component.set("v.isModal", false);
   },
  
   submitDetails: function(component, event, helper) {
      component.set("v.isModal", false);
   }
})