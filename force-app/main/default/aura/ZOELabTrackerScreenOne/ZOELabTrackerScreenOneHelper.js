({
	COLUMNS: [
        {
            label: 'Fecha',
            fieldName: 'calInfusionDate',
            type: 'text',
            sortable: true,
            cellAttributes: { alignment: 'left' },
        },
        { label: 'Dia', fieldName: 'calday' },
        { label: 'Semana', fieldName: 'calweek' },
        { label: 'Corticoides', fieldName: 'doseOfInfusion' },
    ],
	columnsTRANSAMINASAS: [
        {
            label: 'Fecha',
            fieldName: 'calInfusionDate',
            type: 'text',
            sortable: true,
            cellAttributes: { alignment: 'left' },
        },
        { label: 'Dia', fieldName: 'calday' },
        { label: 'Semana', fieldName: 'calweek' },
        { label: 'ALT (U/I) KK', fieldName: 'transaminasas_AST_CalVal' },
        { label: 'AST (U/I)', fieldName: 'transaminasas_ALT_CalVal' },

    ],
    plateletsCOLUMNS: [
        {
            label: 'Fecha',
            fieldName: 'calInfusionDate',
            type: 'text',
            sortable: true,
            cellAttributes: { alignment: 'left' },
        },
        { label: 'Dia', fieldName: 'calday' },
        { label: 'Semana', fieldName: 'calweek' },
        { label: 'Plaquetas', fieldName: 'platelets' },
    ],
    CHOPINTENDCOLUMNS: [
        {
            label: 'Fecha',
            fieldName: 'calInfusionDate',
            type: 'text',
            sortable: true,
            cellAttributes: { alignment: 'left' },
        },
        { label: 'Dia', fieldName: 'calday' },
        { label: 'Semana', fieldName: 'calweek' },
        { label: 'CHOP-INTEND', fieldName: 'chopintended' },
    ],

    
    setColumns: function(cmp) {
        cmp.set('v.columns', this.COLUMNS);
        cmp.set('v.columnsTRANSAMINASAS', this.columnsTRANSAMINASAS);
        cmp.set('v.columnsplatelets', this.plateletsCOLUMNS);
        cmp.set('v.columnsCHOPINTEND', this.CHOPINTENDCOLUMNS);
        
    },

    setData: function(cmp) {
        cmp.set('v.data', this.DATA);
    },
    loadTabs: function (cmp, event) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'one' :
                break;
            case 'two' :
                this.injectComponent(cmp, event);
                break;
                default:
        }
    },
    injectComponent: function (cmp, event) {
            var tab = event.getSource();
        window.setTimeout(
            $A.getCallback(function() {
                        var action = cmp.get('c.loadChart'); 
                        $A.enqueueAction(action);
                    }), 500);
    },
    convertArrayOfObjectsToCSV : function(component,objRecords,keyCol) {
            var csvStringResult,counter,keys,lineDivider,columnDivider;
            if(objRecords===null || !objRecords.length) {
       			return null;         
            }
            columnDivider=',';
            lineDivider='\n';
            keys= keyCol;
            csvStringResult='';
            csvStringResult+=keys.join(columnDivider);
            csvStringResult+=lineDivider;
            for(var i=0;i<objRecords.length;i++)
                {
                    counter=0;
                    for(var tempKey in keys)
                        {
                            var skey=keys[tempKey];
                             if(counter>0)
                            {
                                csvStringResult+=columnDivider;
                            }
                            // Querying standard related object field
                            if(typeof objRecords[i][skey]==='object' && (skey==='Owner' || skey==='Account')){
                                csvStringResult+='"'+objRecords[i][skey].Name+'"';
                                counter ++;
                            }
                            // Querying custom related object field
                            else if(typeof objRecords[i][skey]==='object' &&  skey==='Testobject1__r'){
                                csvStringResult+='"'+objRecords[i][skey].Status__c+'"';
                                counter ++;
                            }
                            // Querying same object field
                            else{
                                csvStringResult+='"'+objRecords[i][skey]+'"';
                                counter ++;
                            }
                         
                        }
                    csvStringResult+=lineDivider;
                 
                }
         
            return csvStringResult
        },
    
         
    // This methods extract values from data and then return a 2d array including keys and values   
    convertResponseToWorksheetData: function(keys, data) {
        var values = [];
        for (let i=0; i < keys.length; i++) {
            var key = keys[i];
            values.push(data[key]);
        }
        var wsData = [keys, values];
        return wsData;
    }
})