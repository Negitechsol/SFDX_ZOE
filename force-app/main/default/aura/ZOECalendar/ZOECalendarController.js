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
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getUserCalendarEvents");
        action.setParams({
            "userId": userId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.objUserCalendarEvents", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        var action = component.get("c.getCalMap");
        action.setParams({
            "userId": userId
        });
        action.setCallback(this, function(data) {
            var result = data.getReturnValue()
            var opts = [];
            opts.push({
                class: "optionClass",
                label: "All",
                value: "all"
            });
            var k=0;
            for (var i in result) {
				if(typeof result[i] === 'string'){
                console.log(i);
                opts.push({
                    class: "optionClass",
                    label: result[i],
                    value: i
                });
                    k++;
                }
            }
            $("#datalength").html(k);
            component.set("v.calList", opts);
        });
        $A.enqueueAction(action);
        try {
            var action = component.get("c.getUserCalendarEventsByPatient");
            action.setParams({
                "userId": userId,
                "PatientId": 'all'
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.objUserCalendarEvents", response.getReturnValue());
                    console.log(response.getReturnValue());
                    window.setTimeout(
                        $A.getCallback(function() {
                            var action = component.get('c.loadJs');
                            $A.enqueueAction(action);
                        }), 2000);
                }
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
    },
    onCalChange : function (component,event, helper){
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
        if(Name == 'cal'){
            var cmpTarget = component.find('fulcal');
            $A.util.removeClass(cmpTarget, 'btn-active');
            var cmpdst = component.find('cal');
            $A.util.addClass(cmpdst, 'btn-active');
           $("#fulcalendar").css("display","none");
           $("#calendar").css("display","block");
        }else{
			var cmpTarget = component.find('cal');
            $A.util.removeClass(cmpTarget, 'btn-active');
            var cmpdst = component.find('fulcal');
            $A.util.addClass(cmpdst, 'btn-active');
            $("#calendar").css("display","none");
            $("#fulcalendar").css("display","block");            
        }
    },
    onPageReferenceChange: function(cmp, evt, helper) {
        cmp.set('v.showcontent', 'false');
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set('v.showcontent', 'true');
            }), 500);
        debugger;
        var v = window.localStorage.getItem('id');
        window.localStorage.setItem('id', '');
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        if (sPageURL !== '') {
            window.localStorage.setItem('id', '');
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');

                if (sParameterName[0] === 'c__id') {
                    if (sParameterName[1] !== undefined) {
                        cmp.set("v.id", sParameterName[1]);
                        window.localStorage.setItem('id', sParameterName[1]);
                    }
                }
            }
        }
        var PatientId = window.localStorage.getItem('id');
        if (PatientId != '') {
            var userId = $A.get("$SObjectType.CurrentUser.Id");
            try {

                var action = cmp.get("c.getUserCalendarEventsByPatient");
                console.log(action);
                action.setParams({
                    "userId": userId,
                    "PatientId": PatientId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        cmp.set("v.objUserCalendarEvents", response.getReturnValue());
                        window.setTimeout(
                            $A.getCallback(function() {
                                var action = cmp.get('c.loadJs');
                                $A.enqueueAction(action);
                            }), 500);
                    } else {
                        window.setTimeout(
                            $A.getCallback(function() {
                                var action = cmp.get('c.loadJs');
                                $A.enqueueAction(action);
                            }), 500);
                    }
                });
                $A.enqueueAction(action);
            } catch (e) {
                console.log(e);
            }
        }

    },
    onChange: function(cmp, evt, helper) {
        cmp.set("v.objUserCalendarEvents", []);
        console.log(cmp.get('v.valSel') + ' Id of record.');
       // $('.calendar').calendar();
        $('#fulcalendar').fullCalendar('destroy');
		$('#fulcalendar').fullCalendar();
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        try {
            var PatientId = cmp.get('v.valSel');
            var action = cmp.get("c.getUserCalendarEventsByPatient");
            console.log(action);
            action.setParams({
                "userId": userId,
                "PatientId": PatientId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set("v.objUserCalendarEvents", response.getReturnValue());
                    window.setTimeout(
                        $A.getCallback(function() {
                            var action = cmp.get('c.loadJs');
                            $A.enqueueAction(action);
                        }), 500);
                }
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }        
    },
    loadJs: function(component, event, helper) {
        
        var dataFromApex = component.get("v.objUserCalendarEvents");
        var currentYear = new Date().getFullYear();
        var fulcalcontent=[];
        if (dataFromApex !== null) {
            console.log(' dataFromApex ' + dataFromApex.length);
            var calcontent = [];
            var actcontent = [];
            var checkprefid = '';
            var charcode = '';
            var datalength = 0;
            var k = 0,
                s = 0,
                act = 1;
            var legend = '';
            var ptlegend = '';
            var legendsize = 0;
            
            var dtColor = ['#2C8FC9', '#9CB703', '#F5BB00', '#FF4A32', '#B56CE2', '#45A597', '#2C66C9', '#9C7703', '#F5DD00', '#FFAA32', '#B588E2', '#45BB97'];
            for (var i = 0; i < dataFromApex.length; i++) {
                var PatientRefID = dataFromApex[i].User_Infusion_Date_Id__r.Patient_Reference_ID__c;
                var PatientName = dataFromApex[i].User_Infusion_Date_Id__r.Name;
                if (checkprefid != PatientRefID) {
                    checkprefid = PatientRefID;
                    charcode = Math.random().toString(16).substr(-6);
                    datalength++;
                    k = 0;
                    s++;
                    act = 1;
                    ptlegend = ptlegend + "<li><span style='background: #" + charcode + ";'></span><label>" + PatientName + "</label></li>";
               		var infcalDate = new Date(dataFromApex[i].User_Infusion_Date_Id__r.Infusion_Date__c);
                    var infcalyr = infcalDate.getFullYear();
                    var infcalmon = infcalDate.getMonth();
                    var infcalday = infcalDate.getDate();
                    var actobj = new Object();
                    actobj.seq = 1,
                    actobj.year = infcalyr,
                    actobj.month = infcalmon,
                    actobj.day = infcalday,
                    actobj.color = '#8a199c'
                    actcontent.push(actobj);
                
                }
                if (s == 1) {
                    legend = legend + "<li><span style='border: 2px solid " + dtColor[k] + ";'></span><label>" + dataFromApex[i].Calendar_Activity__c + "</label></li>";
                    legendsize++;
                }
                var kk=dataFromApex[i].Calendar_Activity_Date__c;
                kk=kk.split(' ');
                var infusionDate = dataFromApex[i].User_Infusion_Date_Id__r.Infusion_Date__c;
                var calDate = new Date(dataFromApex[i].Calendar_Activity_Date__c);
                var calyr = calDate.getFullYear();
                var calmon = calDate.getMonth();
                var calday = calDate.getDate();
                var fDate= dataFromApex[i].Calendar_Activity_Date__c;
 				infusionDate=infusionDate.split("-");
                var calInfusionDate=infusionDate[2]+'/'+infusionDate[1]+'/'+infusionDate[0];
                //console.log(calDate+'calyr :: '+calyr+'calmon :: '+calmon+'calday ::'+calday);                   
                var obj = new Object();
                var fulobj = new Object();
                    obj.id = i,
                    obj.name = '<b>ID de referencia del paciente :</b>' + PatientRefID + '<br> <b>Nombre del paciente :</b>' + PatientName,
                    obj.location = '<b>Dia de infusión :</b>' + calInfusionDate + '<br> <b>Etapa :</b>' + dataFromApex[i].Calendar_Activity__c,
                    obj.startDate = new Date(calyr, calmon, calday),
                    obj.endDate = new Date(calyr, calmon, calday),
                    // obj.background='#'+charcode,
                    obj.color = '#' + charcode
                // obj.color=dtColor[k]
                // 
                try{
                fulobj.id= act,
                fulobj.title=dataFromApex[i].Calendar_Activity__c,
                fulobj.start=kk[0],
                fulobj.name = '<b>ID de referencia del paciente :</b>' + PatientRefID + '<br> <b>Nombre del paciente :</b>' + PatientName+'<br><b>Dia de infusión :</b>' + calInfusionDate + '<br> <b>Etapa :</b>' + dataFromApex[i].Calendar_Activity__c,
                fulobj.color = '#' + charcode
                fulcalcontent.push(fulobj);
                }catch(e){console.log(e)}
                
                calcontent.push(obj);
                k++;
                act++;
            }
        }


        try {
            if (calcontent != "") {
                $('#calendar').calendar({
                    // style:'background',
                    language: 'es',
                    customDayRenderer: function(element, date) {
                        for (const kk of Object.entries(actcontent)) {
                            // console.log(kk[0]+' ::: '+kk[1].seq +' ::: '+kk[1].date+' :::'+kk[1].color);
                            for (var j = 1; j <= legendsize; j++) {
                                if (j == kk[1].seq) {
                                    var actDateTime = new Date(kk[1].year, kk[1].month, kk[1].day).getTime();
                                    if (date.getTime() == actDateTime) {
                                        $(element).css('border', '2px solid ' + kk[1].color);
                                        $(element).css('border-radius', '15px');
                                    }
                                }
                            }
                        }
                    },
                    mouseOnDay: function(e) {
                        if (e.events.length > 0) {
                            {
                            var content = '';

                            for (var i in e.events) {
                                if(e.events!==null){
                                content += '<div class="event-tooltip-content">' +
                                    '<div class="event-name" style="color:' + e.events[i].color + '">' + e.events[i].name + '</div>' +
                                    '<div class="event-location">' + e.events[i].location + '</div>' +
                                    '</div>';
                                }
                            }

                            $(e.element).popover({
                                trigger: 'manual',
                                container: 'body',
                                html: true,
                                content: content
                            });

                            $(e.element).popover('show');
                        }
                        }
                    },
                    mouseOutDay: function(e) {
                        if (e.events.length > 0) {
                            $(e.element).popover('hide');
                        }
                    },
                    dayContextMenu: function(e) {
                        $(e.element).popover('hide');
                    },
                    dataSource: calcontent
                });
               // $("#datalength").html(datalength);
                $("#legendcontent").html(legend);
                $("#ptlegendcontent").html(ptlegend);

            } else {
                $('#calendar').calendar({
                    language: 'es'
                });
                $("#datalength").html(0);
            }

        } catch (e) {
            console.log(e);
        }
        
         window.setTimeout(
         	$A.getCallback(function() {
            $('#fulcalendar').fullCalendar('destroy');
        try{
            $('#fulcalendar').fullCalendar({
                  header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,basicWeek,basicDay'
                  },
                  navLinks: true, // can click day/week names to navigate views
                  editable: true,
                  eventLimit: true, // allow "more" link when too many events
                events: fulcalcontent,
                eventRender: function(event, element) {
                    $(element).tooltip({title: event.name ,placement: 'right',html:true,animation:true,container: "body"});
                }
            });
       } catch (e) {
            console.log(e);
       }
			$A.enqueueAction(action);
         }), 500);
		
        
        $('#save-event').click(function() {
           /* saveEvent(); */
        });
    },
    handleLanguageChangeEvent: function(component, event, helper) {
        //alert('inside language event');
        console.log("handleLanguageChangeEvent");
        var currentLanguage = event.getParam("selectedLanguage");
        console.log("currentLanguage" + currentLanguage);
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