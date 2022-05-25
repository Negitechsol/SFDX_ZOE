({
    doInit: function(cmp, event, helper) {
        cmp.set('v.showcontent', 'false');
        try {
            var userlanguage = window.localStorage.getItem('userlanguage');
            if (userlanguage != '') {
                cmp.set("v.userlanguage", userlanguage);
                cmp.set("v.selectedlanguage", userlanguage);
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
                cmp.set('v.showcontent', 'true');
            }), 500);
        console.log('in doinit');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        cmp.set("v.showTable", false);
        helper.setColumns(cmp);
        var action = cmp.get("c.getAllUsersCalenderRec");
        action.setParams({
            "userId": userId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                cmp.set("v.lstUserCal", response.getReturnValue());
                cmp.set('v.data', response.getReturnValue());
                console.log('<<<<<uue : ' + cmp.get("v.lstUserCal"));
                cmp.set("v.showTable", true);
            } else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " +
                            errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        console.log('<<<<<<<<<< in log ' + userId);
        var action = cmp.get("c.getCalMap");
        action.setParams({
            "userId": userId
        });
        action.setCallback(this, function(data) {
            var result = data.getReturnValue()
            var opts = [];
            opts.push({
                class: "optionClass",
                label: "Seleccione el paciente...",
                value: ""
            });
            for (var i in result) {
                if (result[i] !== null) {
                    opts.push({
                        class: "optionClass",
                        label: result[i],
                        value: i
                    });
                }
            }
            cmp.set("v.calList", opts);
        });
        $A.enqueueAction(action);
        var valSel = cmp.get("v.valSel");
        if (valSel) {
            cmp.set("v.isShowView", true);
        } else {
            cmp.set("v.isShowView", false);
        }
    },
    CalTransRef: function(cmp, event, helper) {
        debugger;
        //var transaminasas_ALT =  cmp.find("transaminasas_ALT").get("v.value");
        //var transaminasas_ALT_Ref = cmp.find("transaminasas_ALT_Ref").get("v.value");
        var objs = cmp.get("v.lstUserCal");
        // Recalculation for all the items
        objs.forEach(function(item, index) {
            console.log(item);
            if (item.transaminasas_ALT != '' && item.transaminasas_ALT_Ref != '') {
                item.transaminasas_ALT_CalVal = isNaN((item.transaminasas_ALT / item.transaminasas_ALT_Ref).toFixed(2)) ? '0' : (item.transaminasas_ALT / item.transaminasas_ALT_Ref).toFixed(2);
            } else {
                item.transaminasas_ALT_CalVal = '0';
            }
            if (item.transaminasas_AST != '' && item.transaminasas_AST_Ref != '') {
                item.transaminasas_AST_CalVal = isNaN((item.transaminasas_AST / item.transaminasas_AST_Ref).toFixed(2)) ? '0' : (item.transaminasas_AST / item.transaminasas_AST_Ref).toFixed(2);
            } else {
                item.transaminasas_AST_CalVal = '0';
            }
        });
        cmp.set("v.lstUserCal", objs);
    },
    CalTransCalVal: function(cmp, event, helper) {},
    loadChart: function(cmp, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var Dosis = [];
        var TRANSAMINASAS1 = [];
        var TRANSAMINASAS2 = [];
        var TRANSAMINASAS3 = [];
        var TRANSAMINASAS4 = [];
        var PLAQUETAS = [];
        var CHOPINTEND = [];
        var SEMANA = [];
        var semArr = [];
        try {
            var PatientId = window.localStorage.getItem('id');
            var action = cmp.get("c.getAllUsersCalenderRecByPatientId");
            console.log(action);
            action.setParams({
                "userId": userId,
                "PatientId": PatientId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var chartdata = response.getReturnValue();
                    var k=0;
                    for (var i = 0; i < chartdata.length; i++) {

                        if (typeof chartdata[i].doseOfInfusion !== 'undefined') {
                            Dosis.push(chartdata[i].doseOfInfusion);
                        }
                        if (typeof chartdata[i].transaminasas_ALT_CalVal !== 'undefined') {
                            TRANSAMINASAS1.push(chartdata[i].transaminasas_ALT_CalVal);
                            TRANSAMINASAS2.push(chartdata[i].transaminasas_AST_CalVal);
                            TRANSAMINASAS3.push(chartdata[i].transaminasas_ALT);
                            TRANSAMINASAS4.push(chartdata[i].transaminasas_AST);
                            console.log(k);
                            k++;
                        }
                        if (typeof chartdata[i].platelets !== 'undefined') {
                            PLAQUETAS.push(chartdata[i].platelets);
                        }
                        if (typeof chartdata[i].chopintended !== 'undefined') {
                            CHOPINTEND.push(chartdata[i].chopintended);
                        }

                        semArr.push(chartdata[i].calweek);
                    }
					console.log('*****    TRANSAMINASAS  *****');
                    console.log(TRANSAMINASAS1);
                    console.log(TRANSAMINASAS2);
                    console.log(TRANSAMINASAS3);
                    console.log(TRANSAMINASAS4);
                    SEMANA = ["-1", "0", "2", "4", "6", "8", "10", "12", "14", "16"];

                    //removing duplicates
                    //  $.each(semArr, function(i, el){
                    //     if($.inArray(el, SEMANA) === -1) SEMANA.push(el);
                    // });
                    // sorting array
                    //  SEMANA.sort((a,b)=>a-b);

                    let Chart = this.Chart;
                    var originalLineDraw = Chart.controllers.line.prototype.draw;
                    Chart.helpers.extend(Chart.controllers.line.prototype, {
                        draw: function() {
                            originalLineDraw.apply(this, arguments);

                            var chart = this.chart;
                            var ctx = chart.chart.ctx;

                            var index = chart.config.data.lineAtIndex;
                            if (index) {
                                var xaxis = chart.scales['x-axis-0'];
                                var yaxis = chart.scales['y-axis-0'];
                                ctx.save();
                                ctx.beginPath();
                                ctx.setLineDash([3]);
                                ctx.moveTo(xaxis.getPixelForValue(undefined, index), yaxis.top);
                                ctx.strokeStyle = '#19ce67';
                                ctx.lineTo(xaxis.getPixelForValue(undefined, index), yaxis.bottom);
                                ctx.fillStyle = "#19ce67";
                                ctx.fillText('Día de Infusión', xaxis.getPixelForValue(undefined, index - 0.1), yaxis.bottom + 40);
                                ctx.textAlign = 'center';
                                ctx.stroke();
                                ctx.restore();
                            }
                        }
                    });
                    // draw background
                    var backgroundColor = 'white';
                    Chart.plugins.register({
                        beforeDraw: function(c) {
                            var ctx = c.chart.ctx;
                            ctx.fillStyle = backgroundColor;
                            ctx.fillRect(0, 0, c.chart.width, c.chart.height);
                        }
                    });
                    var el = cmp.find('chart1').getElement();
                    var ctx = el.getContext('2d');
                    ctx.clearRect(0, 0, 100, 100);
                    ctx = el.getContext('2d');
                    const dosisChart = new Chart(ctx, {
                        type: "line",
                        data: {
                            label: 'SEMANA',
                            labels: SEMANA,
                            datasets: [{
                                label: 'Dosis (mg/kg/día)',
                                data: Dosis,
                                borderColor: "blue",
                                fill: false
                            }],
                            lineAtIndex: 1
                        },
                        options: {
                            responsive: true,
                            legend: {
                                position: 'bottom',
                            },
                            hover: {
                                mode: 'label'
                            },
                            scales: {
                                xAxes: [{
                                    display: true,
                                    gridLines: {
                                        drawOnChartArea: false
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Semanas'
                                    }
                                }],
                                yAxes: [{
                                    display: true,
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'mg/kg/día'
                                    },
                                    ticks: {
                                        max: 4,
                                        min: 0,
                                        stepSize: 0.5
                                    }
                                }]
                            },
                            title: {
                                display: true,
                                text: 'Dosis (mg/kg/día)'
                            }
                        }
                    });

                    $("#DosisImg").unbind("click").click(function() {
                        $("#DosisImg-down").attr('href', dosisChart.toBase64Image());
                        $("#DosisImg-down").prop('download', 'DosisdeCorticoides-' + PatientId + '.png');
                        var element = document.getElementById('DosisImg-down');
                        element.click();
                    });
                    var el = cmp.find('chart2').getElement();
                    var ctx = el.getContext('2d');
                    const transChart = new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: SEMANA,
                            datasets: [{
                                type: 'line',
                                label: 'ALT X UNL',
								yAxisID: 'A',
                                data: TRANSAMINASAS1,
                                borderColor: "orange",
                                fill: false
                            }, {
                                type: 'line',
                                label: 'AST X UNL',
								yAxisID: 'A',
                                data: TRANSAMINASAS2,
                                borderColor: "green",
                                fill: false
                            }, {
                                type: 'bar',
                                label: 'ALT (valor real)',
								yAxisID: 'A',
                                data: TRANSAMINASAS3,
                                backgroundColor: "#a7a6a6",
                                strokeColor: "brown",
                                borderWidth: 1,
                                fill: true
                            }, {
                                type: 'bar',
                                label: 'AST (valor real)',
								yAxisID: 'A',
                                data: TRANSAMINASAS4,
                                backgroundColor: "#fdde05",
                                strokeColor: "brown",
                                borderWidth: 1,
                                fill: true
                            }],
                        },
                        options: {
                            responsive: true,
                            legend: {
                                position: 'bottom',
                            },
                            hover: {
                                mode: 'label'
                            },
                             scales: {
                                 xAxes: [{
                                      offset: true,
                                    display: true,
                                    ticks: {
                                        min: -2,
	                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Semanas'
                                    }
                                }],
                                yAxes: [{
                                    id: 'A',
                                    type: 'linear',
                                    position: 'right',
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'X UNL'
                                    },
                                    ticks: {
                                        max: 20,
                                        min: 0,
                                        stepSize: 2,
                                    },
                                    gridLines: {
                                        color: "rgba(0, 0, 0, 0)",
                                    }
                                }, {
                                    id: 'B',
                                    type: 'linear',
                                    position: 'left',
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Valor Real'
                                    },
                                    ticks: {
                                        max: 1000,
                                        min: 0,
										stepSize: 100
                                    },
                                    gridLines: {
                                        color: "rgba(0, 0, 0, 0)",
                                    }
                                }]
                            },
                            title: {
                                display: true,
                                text: ''
                            }
                        }
                    });
                    $("#TransImg").unbind("click").click(function() {
                        $("#TransImg-down").attr('href', transChart.toBase64Image());
                        $("#TransImg-down").prop('download', 'Transaminasas-' + PatientId + '.png');
                        var element = document.getElementById('TransImg-down');
                        element.click();
                    });

                    var el = cmp.find('chart3').getElement();
                    var ctx = el.getContext('2d');
                    const plaquetasChart = new Chart(ctx, {
                        type: "line",
                        data: {
                            labels: SEMANA,
                            datasets: [{
                                label: 'plaquetas',
                                data: PLAQUETAS,
                                borderColor: "cyan",
                                fill: false
                            }],
                            lineAtIndex: 1
                        },
                        options: {
                            responsive: true,
                            legend: {
                                position: 'bottom',
                            },
                            hover: {
                                mode: 'label'
                            },
                            scales: {
                                xAxes: [{
                                    display: true,
                                    gridLines: {
                                        drawOnChartArea: false
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Semanas'
                                    }
                                }],
                                yAxes: [{
                                    display: true,
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'mm3  (miles)'
                                    }
                                }]
                            },
                            title: {
                                display: true,
                                text: 'Recuento de plaquetas'
                            }
                        }
                    });

                    $("#PlaquetasImg").unbind("click").click(function() {
                        $("#PlaquetasImg-down").attr('href', plaquetasChart.toBase64Image());
                        $("#PlaquetasImg-down").prop('download', 'Plaquetas-' + PatientId + '.png');
                        var element = document.getElementById('PlaquetasImg-down');
                        element.click();
                    });

                    var el = cmp.find('chart4').getElement();
                    var ctx = el.getContext('2d');
                    const chopChart = new Chart(ctx, {
                        type: "line",
                        data: {
                            labels: SEMANA,
                            datasets: [{
                                label: 'CHOPINTEND',
                                data: CHOPINTEND,
                                borderColor: "brown",
                                fill: false
                            }],
                            lineAtIndex: 1
                        },
                        options: {
                            legend: {
                                display: false,
                                position: 'bottom'
                            },
                            title: {
                                display: true,
                                gridLines: {
                                    drawOnChartArea: false
                                },
                                text: 'CHOP-INTEND'
                            },
                            responsive: true,
                            hover: {
                                mode: 'label'
                            },
                            scales: {
                                xAxes: [{
                                    display: true,
                                    gridLines: {
                                        drawOnChartArea: false
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Semanas'
                                    }
                                }],
                                yAxes: [{
                                    display: true,
                                    ticks: {
                                        max: 60,
                                        min: 0,
                                        stepSize: 1
                                    }
                                }]
                            }
                        }
                    });

                    $("#CHOP-INTENDImg").unbind("click").click(function() {
                        $("#CHOP-INTENDImg-down").attr('href', chopChart.toBase64Image());
                        $("#CHOP-INTENDImg-down").prop('download', 'CHOP-INTEND-' + PatientId + '.png');
                        var element = document.getElementById('CHOP-INTENDImg-down');
                        element.click();
                    });
                } else if (state === "INCOMPLETE") {
                    alert('Response is Incompleted');
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " +
                                errors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }


    },
    onChangeMultiChart: function(cmp, evt, helper) {
        
        $("#chart5DOSIS").css('display','none');
        $("#chart5ALT-REAL").css('display','none');
        $("#chart5AST-REAL").css('display','none');
        $("#chart5ALT-XUNL").css('display','none');
        $("#chart5AST-XUNL").css('display','none');
        $("#chart5PLAQUETAS").css('display','none');
        $("#chart5CHOP-INTEND").css('display','none');       
        
        var multiChartSel = cmp.find("MultiChart").get("v.value")
        console.log('********  :'+multiChartSel);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var Dosis = [];
        var TRANSAMINASAS1 = [];
        var TRANSAMINASAS2 = [];
        var TRANSAMINASAS3 = [];
        var TRANSAMINASAS4 = [];
        var PLAQUETAS = [];
        var CHOPINTEND = [];
        var SEMANA = [];
        var semArr = [];
        var ticksmin,ticksmax,stepSize,labelString,title;
        var pt='';
        var dataArray = [];
		var dtColor = ['#2C8FC9', '#9CB703', '#F5BB00', '#FF4A32', '#B56CE2', '#45A597', '#2C66C9', '#9C7703', '#F5DD00', '#FFAA32', '#B588E2', '#45BB97','#00FFFF', '#C0C0C0', '#0000FF', '#808080', '#00008B', '#000000', '#ADD8E6', '#FFA500', '#800080', '#A52A2A', '#FFFF00', '#800000', '#00FF00', '#008000', '#FF00FF', '#808000', '#FFC0CB', '#7FFD4'];
        try {
            var PatientId = window.localStorage.getItem('id');
            var action = cmp.get("c.getAllUsersCalenderAllRecs");
            action.setParams({
                "userId": userId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var chartdata = response.getReturnValue();
                    console.log(chartdata);
                    for (var i = 0; i < chartdata.length; i++) {
						if(pt==''){
                               pt=chartdata[i].paitentName;
                            }else if(pt != chartdata[i].paitentName){
                                pt=chartdata[i].paitentName;
                            } 
                                console.log(chartdata[i].paitentName);
                                if(multiChartSel == 'DOSIS'){
                                    $("#chart5DOSIS").css('display','block');
                                if(Dosis.length > 0){
                                    dataArray.push({
                                       label: pt,
                                       data: Dosis,
                                       borderColor:'',
                                       fill: false
                                    });
                                    ticksmin=0;
                                    ticksmax=4;
                                    stepSize=0.5;
                                    Dosis = [];
                                    labelString='mg/kg/día';
                                    title='Dosis (mg/kg/día)';
                                }
                               
                                }else if(multiChartSel == 'ALT-REAL'){
                                    $("#chart5ALT-REAL").css('display','block');
                                     if(TRANSAMINASAS3.length > 0){
                                    dataArray.push({
                                       label: pt,
                                       data: TRANSAMINASAS3,
                                       borderColor:'',
                                       fill: false
                                    });
                                    ticksmin=0;
                                    ticksmax=1000;
                                    stepSize=100;
                                    labelString='Valor Real';
                                    title='Evolución de Transaminasas - ALT (valor real)';
                                    TRANSAMINASAS3 = [];
                                }
                              }else if(multiChartSel == 'AST-REAL'){   
                                   $("#chart5AST-REAL").css('display','block');
                                     if(TRANSAMINASAS4.length > 0){
                                    dataArray.push({
                                       label: pt,
                                       data: TRANSAMINASAS4,
                                       borderColor:'',
                                       fill: false
                                    });
                                    ticksmin=0;
                                    ticksmax=1000;
                                    stepSize=100;
                                    labelString='Valor Real';
                                    title='Evolución de Transaminasas - AST (valor real)';
                                    TRANSAMINASAS4 = [];
                                }
                              }else if(multiChartSel == 'ALT-XUNL'){ 
                                  $("#chart5ALT-XUNL").css('display','block');
                                     if(TRANSAMINASAS1.length > 0){
                                    dataArray.push({
                                       label: pt,
                                       data: TRANSAMINASAS1,
                                       borderColor:'',
                                       fill: false
                                    });
                                    ticksmin=0;
                                    ticksmax=20;
                                    stepSize=2;
                                    labelString='X UNL';
                                    title='Evolución de Transaminasas - ALT (X UNL)';
                                    TRANSAMINASAS1 = [];
                                }
                              }else if(multiChartSel == 'AST-XUNL'){  
									$("#chart5AST-XUNL").css('display','block');                                  
                                     if(TRANSAMINASAS2.length > 0){
                                    dataArray.push({
                                       label: pt,
                                       data: TRANSAMINASAS2,
                                       borderColor:'',
                                       fill: false
                                    });
                                    ticksmin=0;
                                    ticksmax=20;
                                    stepSize=2;
                                    labelString='X UNL';
                                    title='Evolución de Transaminasas - AST (X UNL)';
                                    TRANSAMINASAS2 = [];
                                }
                              }else if(multiChartSel == 'PLAQUETAS'){ 
                                  $("#chart5PLAQUETAS").css('display','block');
                                     if(PLAQUETAS.length > 0){
                                    dataArray.push({
                                       label: pt,
                                       data: PLAQUETAS,
                                       borderColor:'',
                                       fill: false
                                    });
                                    ticksmin=0;
                                    ticksmax=60;
                                    stepSize=1;
                                    labelString='mm3 (miles)';
                                    title='Evolución de Recuento de Plaquetas';
                                    PLAQUETAS = [];
                                }
                              }else if(multiChartSel == 'CHOP-INTEND'){    
                                  $("#chart5CHOP-INTEND").css('display','block');
                                     if(CHOPINTEND.length > 0){
                                    dataArray.push({
                                       label: pt,
                                       data: CHOPINTEND,
                                       borderColor:'',
                                       fill: false
                                    });
                                    ticksmin=0;
                                    ticksmax=60;
                                    stepSize=1;
                                    labelString='';
                                    title='Evolución de Evaluación CHOP-INTEND';
                                    CHOPINTEND = [];
                                }
                              }

                    
                        if (typeof chartdata[i].doseOfInfusion !== 'undefined') {
                            Dosis.push(chartdata[i].doseOfInfusion);
                        }
                        if (typeof chartdata[i].transaminasas_ALT_CalVal !== 'undefined') {
                            TRANSAMINASAS1.push(chartdata[i].transaminasas_ALT_CalVal);
                            TRANSAMINASAS2.push(chartdata[i].transaminasas_AST_CalVal);
                            TRANSAMINASAS3.push(chartdata[i].transaminasas_ALT);
                            TRANSAMINASAS4.push(chartdata[i].transaminasas_AST);
                        }
                        if (typeof chartdata[i].platelets !== 'undefined') {
                            PLAQUETAS.push(chartdata[i].platelets);
                        }
                        if (typeof chartdata[i].chopintended !== 'undefined') {
                            CHOPINTEND.push(chartdata[i].chopintended);
                        }

                        semArr.push(chartdata[i].calweek);
                    }

                    try{
                        for(var k=0;k<dataArray.length;k++){
                            dataArray[k].borderColor=dtColor[k];                            
                            console.log(dataArray[k]);
                    	}
                    }catch(e){
                        console.log(e);
                    }

                    console.log('  dataArray  ');
                    console.log(dataArray);
                    var mainObj=[];
                    dataArray.forEach(item => {
                        if(mainObj.some(e => e.label === item.label)){
                        var foundIndex = mainObj.findIndex(x => x.label == item.label);
                        mainObj[foundIndex].data.push(item.data[0]);
                        }else{
                        mainObj.push(item);
                        }
                    });
                    console.log(mainObj);
                    SEMANA = ["-1", "0", "2", "4", "6", "8", "10", "12", "14", "16"];
                    let Chart = this.Chart;
            		var chartId='chart5'+multiChartSel;
                    try{                        
                    var el = cmp.find(chartId).getElement();
                    var ctx = el.getContext('2d');
                    window.setTimeout(
                    $A.getCallback(function() {
        				const multiChart = new Chart(ctx, {
                        type: "line",
                        data: {
                            label: 'SEMANA',
                            labels: SEMANA,
                            datasets: mainObj,
                            lineAtIndex: 1
                        },
                        options: {
                            responsive: true,
                            legend: {
                                position: 'bottom',
                            },
                            hover: {
                                mode: 'label'
                            },
                            scales: {
                                xAxes: [{
                                    display: true,
                                    gridLines: {
                                        drawOnChartArea: false
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Semanas'
                                    }
                                }],
                                yAxes: [{
                                    display: true,
                                    scaleLabel: {
                                        display: true,
                                        labelString: labelString
                                    },
                                    ticks:{
                                         min: ticksmin,
                                         max: ticksmax,
                                         stepSize:stepSize
                                    }
                                }]
                            },
                            title: {
                                display: true,
                                text: title
                            }
                        }
                    });
                        
                        $("#CHART5Img").unbind("click").click(function() {
                        $("#CHART5Img-down").attr('href', multiChart.toBase64Image());
                        $("#CHART5Img-down").prop('download', title + '.png');
                        var element = document.getElementById('CHART5Img-down');
                        element.click();
                        //multiChart.destroy();
                    	}); 
                    }), 500);
                    
                        
                        }catch(e){
                        console.log(e);
                    }
    
                } else if (state === "INCOMPLETE") {
                    alert('Response is Incompleted');
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " +
                                errors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
    },
    onChange: function(cmp, evt, helper) {
        cmp.set("v.objUserCalendarEvents", []);
        var valSel = cmp.get("v.valSel");
        if (valSel) {
            cmp.set("v.isShowView", true);
        } else {
            cmp.set("v.isShowView", false);
        }

        console.log(cmp.get('v.valSel') + ' Id of record.');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var PatientId = cmp.get('v.valSel');
        window.localStorage.setItem('id', PatientId);
        window.setTimeout(
            $A.getCallback(function() {
                var action = cmp.get('c.onPageReferenceChange');
                $A.enqueueAction(action);
            }), 500);

    },
    onPageReferenceChange: function(cmp, evt, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set('v.showcontent', 'true');
            }), 500);
        debugger;
        var v = window.localStorage.getItem('id');
        cmp.set("v.idOfUserInfusion", v);
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

        var userId = $A.get("$SObjectType.CurrentUser.Id");
        try {
            var PatientId = window.localStorage.getItem('id');

            var action = cmp.get("c.getAllUsersCalenderRecByPatientId");
            console.log(action);
            action.setParams({
                "userId": userId,
                "PatientId": PatientId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    window.setTimeout(
                        $A.getCallback(function() {
                            console.log(response.getReturnValue());
                            cmp.set("v.lstUserCal", response.getReturnValue());
                            cmp.set('v.data', response.getReturnValue());
                            console.log(cmp.get("v.lstUserCal"));
                            cmp.set("v.showTable", true);
                        }), 500);

                } else if (state === "INCOMPLETE") {
                    alert('Response is Incompleted');
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " +
                                errors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log(e);
        }
        window.setTimeout(
            $A.getCallback(function() {
                var action = cmp.get('c.loadChart');
                $A.enqueueAction(action);
            }), 500);
    },
    saveRecord: function(component, event, helper) {
        helper.saveData(component, event, helper);
    },
    handleActive: function(cmp, event, helper) {
        helper.loadTabs(cmp, event);
    },
    dateChange1: function(component, event, helper) {

        var selectDate = event.getSource().get("v.value");
        var infDate = component.find("infusiondate").get("v.value");
        var start = new Date(infDate);
        var end = new Date(selectDate);
        var diffDate = (end - start) / (1000 * 60 * 60 * 24);
        var days = Math.round(diffDate);
        var weeks = Math.round(diffDate / 7);

        var data = component.get('v.data');
        var responseVal = [];
        for (var i = 0; i < data.length; i++) {
        
            if (data[i].calInfusionDate == selectDate) {
                data[i].calday = days;
                data[i].calweek = weeks;
            }
            responseVal.push(data[i]);
        }
        component.set("v.data", responseVal);

        component.find("oDate_Day").set("v.value", days);
        component.find("oDate_Week").set("v.value", weeks);
        console.log(":::::::::::::::" + days);
        console.log(":::::::::::::::" + weeks);
    },
    dateChange2: function(component, event, helper) {
        console.log("onChange", event.getSource().get("v.value"));
        var selectDate = event.getSource().get("v.value");
        var infDate = component.find("infusiondate").get("v.value");
        var start = new Date(infDate);
        var end = new Date(selectDate);
        var diffDate = (end - start) / (1000 * 60 * 60 * 24);
        var days = Math.round(diffDate);
        var weeks = Math.round(diffDate / 7);
        var data = component.get('v.data');
        var responseVal = [];
        for (var i = 0; i < data.length; i++) {
            console.log('data[i]: ' + data[i]);
            console.log('data[i].calInfusionDate: ' + data[i].calInfusionDate);
            if (data[i].calInfusionDate == selectDate) {
                data[i].calday = days;
                data[i].calweek = weeks;
            }
            responseVal.push(data[i]);
        }
        component.set("v.data", responseVal);

        component.find("oDate2_Day").set("v.value", days);
        component.find("oDate2_Day1").set("v.value", days);
        component.find("oDate2_Week").set("v.value", weeks);
        component.find("oDate2_Week1").set("v.value", weeks);
    },
    CalTransRef1: function(component, event, helper) {
        var ALT = component.find("ALT").get("v.value");
        var ALT_normal = component.find("ALT_normal").get("v.value");
        var kk = isNaN((ALT / ALT_normal).toFixed(2)) ? '0' : (ALT / ALT_normal).toFixed(2);
        if (kk == 'Infinity') {
            kk = '0';
        }
        component.find("ALT_val").set("v.value", kk);
    },
    CalTransRef2: function(component, event, helper) {
        var AST = component.find("AST").get("v.value");
        var AST_normal = component.find("AST_normal").get("v.value");
        var kk = isNaN((AST / AST_normal).toFixed(2)) ? '0' : (AST / AST_normal).toFixed(2);
        if (kk == 'Infinity') {
            kk = '0';
        }
        component.find("AST_val").set("v.value", kk);
    },
    dateChange3: function(component, event, helper) {
        console.log("onChange", event.getSource().get("v.value"));
        var selectDate = event.getSource().get("v.value");
        var infDate = component.find("infusiondate").get("v.value");
        var start = new Date(infDate);
        var end = new Date(selectDate);
        var diffDate = (end - start) / (1000 * 60 * 60 * 24);
        var days = Math.round(diffDate);
        var weeks = Math.round(diffDate / 7);
        var data = component.get('v.data');
        var responseVal = [];
        for (var i = 0; i < data.length; i++) {
            console.log('data[i]: ' + data[i]);
            console.log('data[i].calInfusionDate: ' + data[i].calInfusionDate);
            if (data[i].calInfusionDate == selectDate) {
                data[i].calday = days;
                data[i].calweek = weeks;
            }
            responseVal.push(data[i]);
        }
        component.set("v.data", responseVal);
        component.find("oDate3_Day").set("v.value", days);
        component.find("oDate3_Week").set("v.value", weeks);
    },
    dateChange4: function(component, event, helper) {
        console.log("onChange", event.getSource().get("v.value"));
        var selectDate = event.getSource().get("v.value");
        var infDate = component.find("infusiondate").get("v.value");
        var start = new Date(infDate);
        var end = new Date(selectDate);
        var diffDate = (end - start) / (1000 * 60 * 60 * 24);
        var days = Math.round(diffDate);
        var weeks = Math.round(diffDate / 7);
        var data = component.get('v.data');
        var responseVal = [];
        for (var i = 0; i < data.length; i++) {
            console.log('data[i]: ' + data[i]);
            console.log('data[i].calInfusionDate: ' + data[i].calInfusionDate);
            if (data[i].calInfusionDate == selectDate) {
                data[i].calday = days;
                data[i].calweek = weeks;
            }
            responseVal.push(data[i]);
        }
        component.set("v.data", responseVal);
        component.find("oDate4_Day").set("v.value", days);
        component.find("oDate4_Week").set("v.value", weeks);
    },
    astcalval: function(component, event, helper) {
        var selectedValue = event.getSource().get("v.validity").valid;

        if (!selectedValue) {
            component.set('v.isTransBtnActive', true);
        } else {
            component.set('v.isTransBtnActive', false);
        }

        var data = component.get('v.data');
        var responseVal = [];
        for (var i = 0; i < data.length; i++) {
            console.log('data[i]: ' + data[i]);
            console.log('data[i].transaminasas_AST: ' + data[i].transaminasas_AST);
            if (data[i].transaminasas_AST != '' && data[i].transaminasas_AST_Ref != '' &&
                typeof data[i].transaminasas_AST !== 'undefined' && typeof data[i].transaminasas_AST_Ref !== 'undefined') {
                data[i].transaminasas_AST_CalVal = (data[i].transaminasas_AST / data[i].transaminasas_AST_Ref).toFixed(2);
            }
            if (data[i].transaminasas_ALT != '' && data[i].transaminasas_ALT_Ref != '' &&
                typeof data[i].transaminasas_ALT !== 'undefined' && typeof data[i].transaminasas_ALT_Ref !== 'undefined') {
                data[i].transaminasas_ALT_CalVal = (data[i].transaminasas_ALT / data[i].transaminasas_ALT_Ref).toFixed(2);
            }
            responseVal.push(data[i]);
        }
        component.set("v.data", responseVal);
    },
    updateUserCalRec: function(component, event, helper) {
        try {
            var PatientId = component.get('v.valSel');
            window.localStorage.setItem('id', PatientId);
            component.find("Id_spinner").set("v.class", 'slds-show');
            var data = component.get('v.data');

            var action = component.get("c.updateDose");
            action.setParams({
                "wrapperList": data
            });
            action.setCallback(this, function(response) {
                component.find("Id_spinner").set("v.class", 'slds-hide');
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log(response.getReturnValue());
                    component.set("v.lstChartdata", response.getReturnValue());
                    component.find('notifyId').showToast({
                        "variant": "Success",
                        "title": "Success!",
                        "message": "Record Updated Successfully."
                    });

                    var tabledata = response.getReturnValue();
                    tabledata.sort(function(a, b) {
                        if (Number(a['calday']) > Number(b['calday']))
                            return 1;
                        else if (Number(a['calday']) < Number(b['calday']))
                            return -1;

                        return 0;
                    });
                    component.set('v.data', tabledata);
                    var action = component.get('c.rerenderChart');
                    $A.enqueueAction(action);
                    /*component.set('v.valSel',PatientId);
                    window.setTimeout(
                        $A.getCallback(function() {
                            var action1 = component.get('c.onPageReferenceChange'); 
                            $A.enqueueAction(action1);
                        }), 500);*/

                } else if (state === "INCOMPLETE") {
                    alert('Response is Incompleted');
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " +
                                errors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        } catch (e) {}
    },
    addDoseRow: function(component, event, helper) {
        //get the data List from component 
        try {
            var data = component.get('v.data');
            var UserCalWrapper = {
                calInfusionDate: "",
                calday: "",
                calweek: "",
                doseOfInfusion: "",
                isDoseInfusionTable: "true",
                paitentName: "",
                paitentid: "",
                recId: "",
                calInfusionId: component.get("v.idOfUserInfusion"),
                userInfustionDate: component.find("infusiondate").get("v.value")
            };
            var data = [...data, UserCalWrapper];
            component.set("v.data", data);
        } catch (e) {
            debugger;
        }
    },
    addTransRow: function(component, event, helper) {
        //get the data List from component 
        try {
            var data = component.get('v.data');
            var UserCalWrapper = {
                calInfusionDate: "",
                calday: "",
                calweek: "",
                transaminasas_AST_CalVal: "",
                transaminasas_ALT_CalVal: "",
                isTRANSAMINASASTable: "true",
                paitentName: "",
                paitentid: "",
                recId: "",
                calInfusionId: component.get("v.idOfUserInfusion"),
                userInfustionDate: component.find("infusiondate").get("v.value")
            };
            var data = [...data, UserCalWrapper];
            component.set("v.data", data);
        } catch (e) {
            debugger;
        }
    },
    addPlaqRow: function(component, event, helper) {
        //get the data List from component 
        try {
            var data = component.get('v.data');
            var UserCalWrapper = {
                calInfusionDate: "",
                calday: "",
                calweek: "",
                platelets: "",
                isPLAQUETASTable: "true",
                paitentName: "",
                paitentid: "",
                recId: "",
                calInfusionId: component.get("v.idOfUserInfusion"),
                userInfustionDate: component.find("infusiondate").get("v.value")
            };
            var data = [...data, UserCalWrapper];
            component.set("v.data", data);
        } catch (e) {
            debugger;
        }
    },
    addChopRow: function(component, event, helper) {
        //get the data List from component 
        try {
            var data = component.get('v.data');
            var UserCalWrapper = {
                calInfusionDate: "",
                calday: "",
                calweek: "",
                chopintended: "",
                isCHOPTable: "true",
                paitentName: "",
                paitentid: "",
                recId: "",
                calInfusionId: component.get("v.idOfUserInfusion"),
                userInfustionDate: component.find("infusiondate").get("v.value")
            };
            var data = [...data, UserCalWrapper];
            component.set("v.data", data);
        } catch (e) {
            debugger;
        }
    },
    handleLanguageChangeEvent: function(component, event, helper) {
        console.log("handleLanguageChangeEvent");
        var currentLanguage = event.getParam("selectedLanguage");
        console.log("currentLanguage" + currentLanguage);
        // alert('selectedLanguage from event in parent'+currentLanguage)
        component.set("v.userlanguage", currentLanguage);
    },
    onLanguageChange: function(component, event, helper) {
        var languageSelected = component.find('select').get('v.value');
        console.log('languageSelected on change ZOE Header' + languageSelected);
        component.set("v.selectedlanguage", languageSelected);
        window.localStorage.setItem('userlanguage', languageSelected);
        var langAppEvent = $A.get("e.c:LanguageEvent");
        //var languageCompEvent = component.getEvent("LanguageEvent");
        langAppEvent.setParams({
            "selectedLanguage": languageSelected
        });
        langAppEvent.fire();
    },
    rerenderChart: function(cmp, event, helper) {

        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var Dosis = [];
        var TRANSAMINASAS1 = [];
        var TRANSAMINASAS2 = [];
        var TRANSAMINASAS3 = [];
        var TRANSAMINASAS4 = [];
        var PLAQUETAS = [];
        var CHOPINTEND = [];
        var SEMANA = [];
        var semArr = [];

        try {

            var chartdata = cmp.get("v.lstChartdata");
            chartdata.sort(function(a, b) {
                if (Number(a['calday']) > Number(b['calday']))
                    return 1;
                else if (Number(a['calday']) < Number(b['calday']))
                    return -1;

                return 0;
            });
            for (var i = 0; i < chartdata.length; i++) {
                if (typeof chartdata[i].doseOfInfusion !== 'undefined') {
                    Dosis.push(chartdata[i].doseOfInfusion);
                }
                if (typeof chartdata[i].transaminasas_ALT_CalVal !== 'undefined') {
                    TRANSAMINASAS1.push(chartdata[i].transaminasas_ALT_CalVal);
                    TRANSAMINASAS2.push(chartdata[i].transaminasas_AST_CalVal);
                    TRANSAMINASAS3.push(chartdata[i].transaminasas_ALT);
                    TRANSAMINASAS4.push(chartdata[i].transaminasas_AST);
                }
                if (typeof chartdata[i].platelets !== 'undefined') {
                    PLAQUETAS.push(chartdata[i].platelets);
                }
                if (typeof chartdata[i].chopintended !== 'undefined') {
                    CHOPINTEND.push(chartdata[i].chopintended);
                }

                semArr.push(chartdata[i].calweek);
            }

            SEMANA = ["-1", "0", "2", "4", "6", "8", "10", "12", "14", "16"];
            try{
                let Chart = this.Chart;
            }catch(e){
                console.log(e);
            }
			
            var el = cmp.find('chart1').getElement();
            var ctx = el.getContext('2d');
            ctx.clearRect(0, 0, 100, 100);
            ctx = el.getContext('2d');
            const myChart = new Chart(ctx, {
                type: "line",
                data: {
                    label: 'SEMANA',
                    labels: SEMANA,
                    datasets: [{
                        label: 'Dosis de corticoesteroides',
                        data: Dosis,
                        borderColor: "blue",
                        fill: false
                    }],
                    lineAtIndex: 1
                },
                options: {
                    responsive: true,
                    legend: {
                        position: 'bottom',
                    },
                    hover: {
                        mode: 'label'
                    },
                    scales: {
                        xAxes: [{
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'Semanas'
                            }
                        }],
                        yAxes: [{
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'mg/kg/día'
                            },
                            ticks: {
                                max: 4,
                                min: 0,
                                stepSize: 0.5
                            }
                        }]
                    },
                    title: {
                        display: true,
                        text: 'Dosis (mg/kg/día)'
                    }
                }

            });
            $("#DosisImg-down").attr('href', myChart.toBase64Image());

            var el = cmp.find('chart2').getElement();
            var ctx = el.getContext('2d');
            const updateChart = new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: SEMANA,
                            datasets: [{
                                type: 'line',
                                label: 'ALT X UNL',
								yAxisID: 'A',
                                data: TRANSAMINASAS1,
                                borderColor: "orange",
                                fill: false
                            }, {
                                type: 'line',
                                label: 'AST X UNL',
								yAxisID: 'A',
                                data: TRANSAMINASAS2,
                                borderColor: "green",
                                fill: false
                            }, {
                                type: 'bar',
                                label: 'ALT (valor real)',
								yAxisID: 'A',
                                data: TRANSAMINASAS3,
                                backgroundColor: "#a7a6a6",
                                strokeColor: "brown",
                                borderWidth: 1,
                                fill: true
                            }, {
                                type: 'bar',
                                label: 'AST (valor real)',
								yAxisID: 'A',
                                data: TRANSAMINASAS4,
                                backgroundColor: "#fdde05",
                                strokeColor: "brown",
                                borderWidth: 1,
                                fill: true
                            }],
                        },
                        options: {
                            responsive: true,
                            legend: {
                                position: 'bottom',
                            },
                            hover: {
                                mode: 'label'
                            },
                             scales: {
                                 xAxes: [{
                                      offset: true,
                                    display: true,
                                    ticks: {
                                        min: -2,
	                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Semanas'
                                    }
                                }],
                                yAxes: [{
                                    id: 'A',
                                    type: 'linear',
                                    position: 'right',
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'X UNL'
                                    },
                                    ticks: {
                                        max: 20,
                                        min: 0,
                                        stepSize: 2,
                                    },
                                    gridLines: {
                                        color: "rgba(0, 0, 0, 0)",
                                    }
                                }, {
                                    id: 'B',
                                    type: 'linear',
                                    position: 'left',
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Valor Real'
                                    },
                                    ticks: {
                                        max: 1000,
                                        min: 0,
										stepSize: 100
                                    },
                                    gridLines: {
                                        color: "rgba(0, 0, 0, 0)",
                                    }
                                }]
                            },
                            title: {
                                display: true,
                                text: ''
                            }
                        }
                    });
            $("#TransImg-down").attr('href', updateChart.toBase64Image());

            var el = cmp.find('chart3').getElement();
            var ctx = el.getContext('2d');
            let updateChart1 = new Chart(ctx, {
                type: "line",
                data: {
                    labels: SEMANA,
                    datasets: [{
                        label: 'plaquetas',
                        data: PLAQUETAS,
                        borderColor: "cyan",
                        fill: false
                    }],
                    lineAtIndex: 1
                },
                options: {
                    responsive: true,
                    legend: {
                        position: 'bottom',
                    },
                    hover: {
                        mode: 'label'
                    },
                    scales: {
                        xAxes: [{
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'Semanas'
                            }
                        }],
                        yAxes: [{
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'mm3  (miles)'
                            }
                        }]
                    },
                    title: {
                        display: true,
                        text: 'Recuento de plaquetas'
                    }
                }
            });
            $("#PlaquetasImg-down").attr('href', updateChart1.toBase64Image());

            var el = cmp.find('chart4').getElement();
            var ctx = el.getContext('2d');
            let updateChart2 = new Chart(ctx, {
                type: "line",
                data: {
                    labels: SEMANA,
                    datasets: [{
                        label: 'CHOPINTEND',
                        data: CHOPINTEND,
                        borderColor: "brown",
                        fill: false
                    }],
                    lineAtIndex: 1
                },
                options: {
                    legend: {
                        display: false,
                        position: 'bottom'
                    },
                    title: {
                        display: true,
                        text: 'CHOP-INTEND'
                    },
                    responsive: true,
                    /*      legend: {
                            position: 'bottom',
                          }, */
                    hover: {
                        mode: 'label'
                    },
                    scales: {
                        xAxes: [{
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'Semanas'
                            }
                        }],
                        yAxes: [{
                            display: true,
                            ticks: {
                                max: 60,
                                min: 0,
                                stepSize: 1
                            }
                        }]
                    }
                }
            });
            $("#CHOP-INTENDImg-down").attr('href',updateChart2.toBase64Image());
            var action = this.action;
            $A.enqueueAction(action);
        } catch (e) {

        }
    },
    checkDoseFields: function(cmp, event, helper) {
        var selectedValue = event.getSource().get("v.validity").valid;
        if (!selectedValue) {
            cmp.set('v.isDosBtnActive', true);
        } else {
            cmp.set('v.isDosBtnActive', false);
        }
    },
    checkPalqFields: function(cmp, event, helper) {
        var selectedValue = event.getSource().get("v.validity").valid;
        if (!selectedValue) {
            cmp.set('v.isPalqBtnActive', true);
        } else {
            cmp.set('v.isPalqBtnActive', false);
        }
    },
    checkChopFields: function(cmp, event, helper) {
        var selectedValue = event.getSource().get("v.validity").valid;
        if (!selectedValue) {
            cmp.set('v.isChopBtnActive', true);
        } else {
            cmp.set('v.isChopBtnActive', false);
        }
    },
    downloadData: function(cmp, event, helper) {
        
        var allRec = cmp.get("v.data");
        var finalList =[];
        for(var i=0;i < allRec.length;i++)
            {
                if(allRec[i].isDoseInfusionTable !== null && allRec[i].isDoseInfusionTable !== undefined)
                {
                    finalList.push(allRec[i]);
                }
            }
        
        var csv=helper.convertArrayOfObjectsToCSV(cmp,finalList,['calInfusionDate','doseOfInfusion']); 
        if(csv===null)
        {
          return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='Dosis_de_Corticoides_Data_Export.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        
    },
    downloadTransaminasasData: function(cmp, event, helper) {
        
        var allRec = cmp.get("v.data");
        var finalList =[];
        for(var i=0;i < allRec.length;i++)
            {
                if(allRec[i].isTRANSAMINASASTable !== null && allRec[i].isTRANSAMINASASTable !== undefined)
                {
                 
                    finalList.push(allRec[i]);

                }
             
            }
        
        var csv=helper.convertArrayOfObjectsToCSV(cmp,finalList,['calInfusionDate','transaminasas_AST','transaminasas_ALT','transaminasas_AST_Ref','transaminasas_ALT_Ref','transaminasas_AST_CalVal','transaminasas_ALT_CalVal']); 
        if(csv===null)
        {
          return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='Transaminasas_Data_Export.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        
    },
    downloadPlaquetas: function(cmp, event, helper) {
        
        var allRec = cmp.get("v.data");
        var finalList =[];
        for(var i=0;i < allRec.length;i++)
            {
                if(allRec[i].isPLAQUETASTable !== null && allRec[i].isPLAQUETASTable !== undefined)
                {
                 
                    finalList.push(allRec[i]);

                }
             
            }
        
        var csv=helper.convertArrayOfObjectsToCSV(cmp,finalList,['calInfusionDate','platelets']); 
        if(csv===null)
        {
          return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='PLAQUETASTable_Data_Export.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        
    },
    downloadChopIntend: function(cmp, event, helper) {
        
        var allRec = cmp.get("v.data");
        var finalList =[];
        for(var i=0;i < allRec.length;i++)
            {
                if(allRec[i].isCHOPTable !== null && allRec[i].isCHOPTable !== undefined)
                {
                 
                    finalList.push(allRec[i]);

                }
             
            }
        
        var csv=helper.convertArrayOfObjectsToCSV(cmp,finalList,['calInfusionDate','chopintended']); 
        if(csv===null)
        {
          return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='CHOP_INTEND_Data_Export.csv';
        document.body.appendChild(elementLink);
        elementLink.click();        
    },
    downloadImgs: function(cmp, event, helper) {
        
    },
    downloadAllTable: function(cmp, event, helper) {
        
        var allRec = cmp.get("v.data");
        var lstChop =[];
        var lstPlaq =[];
        for(var i=0;i < allRec.length;i++)
            {
                if(allRec[i].isCHOPTable !== null && allRec[i].isCHOPTable !== undefined)
                {
                 
                    lstChop.push(allRec[i]);

                }
                
                if(allRec[i].isPLAQUETASTable !== null && allRec[i].isPLAQUETASTable !== undefined)
                {
                 
                    lstPlaq.push(allRec[i]);

                }
             
            }
        
        // Preparing keys for data mapping
        var chopkeys = ['calInfusionDate','chopintended'];
        var plaqkeys = ['calInfusionDate','platelets'];
        
        // Parsing and Converting the data in required format (Array of Arrays) 
        var ws1Data = helper.convertResponseToWorksheetData(chopkeys, lstChop);    
        var ws2Data = helper.convertResponseToWorksheetData(plaqkeys, lstPlaq);;
        var XLSX = require('xlsx');
        // Creating Worksheets for Excel Workbook
        var ws1 = XLSX.utils.aoa_to_sheet(ws1Data);
        var ws2 = XLSX.utils.aoa_to_sheet(ws2Data);
        
        // Creating Excel Workbook
        var wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws1, "CHOP");      // (workbook, worksheet, sheetTitle)
        XLSX.utils.book_append_sheet(wb, ws2, "PLAQ");
        
        // Downloading and Closing
        XLSX.writeFile(wb, 'ALL.xls');
        $A.get("e.force:closeQuickAction").fire();
        
               
    }
})