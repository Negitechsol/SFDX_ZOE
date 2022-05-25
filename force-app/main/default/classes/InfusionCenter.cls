/**********************************************************************************************
@Description: An apex page controller that exposes the Infusion Center functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class InfusionCenter {
    
    //@Description: This method used get infusion Centers Details from Master Configurations
    @AuraEnabled
    public static List<Object> getInfusionCenterDetails() {
        List<mapdata> locations=new List<mapdata>();    
         if(Schema.sObjectType.Master_Configuration__c.isAccessible()){
        List<Master_Configuration__c> infusionCenters=[select Id,Infusion_Center_Id__c, Infusion_Center_Name__c, Infusion_Center_Address__c,Street__c,City__c,Country__c,PostalCode__c from Master_Configuration__c where RecordType.Name=:ZOE_Constant.MC_INFUSION_CENTERS];
        for(Master_Configuration__c masterConfig:infusionCenters){
            String description='';
            mapdata data=new mapdata();
            location locn=new location();
            if(masterConfig.Infusion_Center_Name__c!=null){
                data.title=masterConfig.Infusion_Center_Name__c; 
            }
            if(masterConfig.Street__c!=null){
                description+=masterConfig.Street__c;
                locn.street=masterConfig.Street__c;
            }
            if(masterConfig.City__c!=null){
                description+=', '+masterConfig.City__c;
                locn.city=masterConfig.City__c;
            }
            if(masterConfig.Country__c!=null){
                description+=', '+masterConfig.Country__c;
                locn.country=masterConfig.Country__c;
            }
            if(masterConfig.PostalCode__c!=null){
                description+=', '+masterConfig.PostalCode__c;
                locn.PostalCode=masterConfig.PostalCode__c;
            }
            data.description=description;
            data.loc=locn;
            locations.add(data);
        }
         }
        List<Object> mapjson=generateJsonnrequest(locations);
        return mapjson;
    }
    
    //@Description: This method used get Dosage Details from Master Configurations
    @AuraEnabled
    public static Map<String,String> getDosage() {
        Map<String,String> dosages=new Map<String,String>();
        if(Schema.sObjectType.Master_Configuration__c.isAccessible()){
        List<Master_Configuration__c> zkitDosage=[select Start_Weight__c, End_Weight__c, Dosage__c,Weight_Range__c,Vial5_5__c,Vial8_3__c,Viales_Totales__c from Master_Configuration__c where RecordType.Name=:ZOE_Constant.MC_Z_KIT];
        for(Master_Configuration__c masterConfig:zkitDosage){
            if(masterConfig.Weight_Range__c!=null && masterConfig.Vial5_5__c!=null && masterConfig.Vial8_3__c!=null && masterConfig.Viales_Totales__c!=null){
                String dosage= String.valueOf(masterConfig.Vial5_5__c)+'-'+String.valueOf(masterConfig.Vial8_3__c)+'-'+String.valueOf(masterConfig.Viales_Totales__c);
                dosages.put(masterConfig.Weight_Range__c,dosage);
            }
        }
        }
        FeatureUsage.insertFeatureUsage(ZOE_Constant.MC_Z_KIT);
        return dosages;
    }
    
    //@Description: This method used for insert Feature usage
    @AuraEnabled
    public static void updateFeatureUsage( String eventName ){
        FeatureUsage.insertFeatureUsage(eventName);
    }
    
    //@Description: This is map object wrapper
    public class mapdata{
        public location loc;
        public string description='';
        public string icon='';
        public string title=''; 
    }
    //@Description: This is location object wrapper
    public class location{
        public string Street='';
        public string City='';
        public string PostalCode='';
        public string Country='';
    }
    
    //@Description: This method used to get List of locations as json
    public Static List<Object> generateJsonnrequest(List<mapdata> locations){
        List<Object> mapjson=new List<Object>();
        for(mapdata requestdata:locations){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(requestdata.icon!=null){
                gen.writeStringField('icon', requestdata.icon); 
            }
            if(requestdata.title!=null){
                gen.writeStringField('title', requestdata.title);
            }
            if(requestdata.description!=null){
                gen.writeStringField('description', requestdata.description);
            }
            if(requestdata.loc!=null){
                gen.writeFieldName('location');
                gen.writeObject(requestdata.loc);
            } 
            gen.writeEndObject();
            String requestBody = gen.getAsString();
            mapjson.add(requestBody);
        }       
        return mapjson;
    }
}