({
	myAction : function(component, event, helper) {
		
	},
    doInit : function(component, event, helper) {
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
    },
     doneRendering: function(cmp, event, helper) {
        window.setTimeout(
        $A.getCallback(function() {
            $('.preloader').addClass('preloader-deactivate');
            $("#header_content").css('opacity','1');
        }), 2000
    );
  }
})