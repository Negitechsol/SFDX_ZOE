({
	myAction : function(component, event, helper) {
		
	},
    // terms & conditions
    opencModel: function(component, event, helper) {
      component.set("v.isModalOpen", true);
   },
  
   closecModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },
  
/*   submitDetails: function(component, event, helper) {
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