({
	helperMethod : function() {
		
	},
    loadTabs: function (cmp, event) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'one' :
                break;
            case 'three' :
                this.injectSlider(cmp, event);
                break;
                default:
        }
    },
    injectSlider: function (cmp, event) {
        var tab = event.getSource();
       window.setTimeout(           
        $A.getCallback(function() {
             try{
            $('.owl-carousel').owlCarousel({
                loop:false,
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
           }catch(e){
               console.log(e);
           }
            $('#On-Demand').css('display','block');
            $('#On-DemandP').css('display','block');
        }), 500
    );
    }
})