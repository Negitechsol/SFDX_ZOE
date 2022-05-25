({
    init: function (cmp, event, helper) {
        var action=cmp.get("c.getInfusionCenterDetails");
        /*videoframe.contentWindow.document.addEventListener('click',function(){
            alert('hi');
        });*/
         
         //action.setParams({ weight : component.get("v.weight") });
         action.setCallback(this,function(response){
             var state=response.getState();
             console.log('state'+state);
             if(state==='SUCCESS'){
                 
                 var result=response.getReturnValue();
                 //console.log('result '+result);
                 var jsonlist=[];
                 for(var i in result){
                     if(typeof result[i] === 'object'){
                         
                     console.log(JSON.parse(result[i]) );
                     jsonlist.push(JSON.parse(result[i]));
                         
                     }
                 }
                 
                 cmp.set('v.mapMarkers',jsonlist);
                /* cmp.set('v.mapMarkers', [
                     {
                         "title" : "Sanatorio dela Trinidad Palermo",
                         "description" : "Av. Cerviño 4720, Buenos Aires, Argentina",
                         "location" : {
                             "Street" : "Av. Cerviño 4720, Buenos Aires, Argentina",
                             "State" : "",
                             "PostalCode" : "",
                             "Country" : "Argentina",
                             "City" : ""
                         }
                     }, {
                         "title" : "Hospital Italiano de Buenos Aires",
                         "description" : "Tte. Gral. Juan Domingo Perón 4190, Argentina",
                         "location" : {
                             "Street" : "Tte. Gral. Juan Domingo Perón 4190, Argentina",
                             "State" : "",
                             "PostalCode" : "",
                             "Country" : "Argentina",
                             "City" : ""
                         }
                     }, {
                         "title" : "Sanatorio Sagrado Corazon",
                         "description" : "BARTOLOME MITRE 1955 - (C1039AAC) CDAD. DE BS. AS. ,  Argentina",
                         "location" : {
                             "Street" : "BARTOLOME MITRE 1955 - (C1039AAC) CDAD. DE BS. AS. ,  Argentina",
                             "State" : "",
                             "PostalCode" : "",
                             "Country" : "Argentina",
                             "City" : ""
                         }
                     }, {
                         "title" : "Sanatorio Los Arcos",
                         "description" : "Av. Juan B. Justo 909, C1425 FSD, Buenos Aires, Argentina",
                         "location" : {
                             "Street" : "Av. Juan B. Justo 909, C1425 FSD, Buenos Aires, Argentina",
                             "State" : "",
                             "PostalCode" : "",
                             "Country" : "Argentina",
                             "City" : ""
                         }
                     }
                 ]);*/
                
                 cmp.set('v.center', {
                     location: {
                         City: 'Buenos Aires'
                     }
                 });
                 cmp.set('v.zoomLevel', 10);
                 cmp.set('v.markersTitle', 'Infusion Centers in Argentina');
                 cmp.set('v.showFooter', true);
                 
             }else if (state === "ERROR") {
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
         
         cmp.set('v.zoomLevel', 4);
         cmp.set('v.markersTitle', 'Salesforce locations in United States');
         cmp.set('v.showFooter', false);
     }
})