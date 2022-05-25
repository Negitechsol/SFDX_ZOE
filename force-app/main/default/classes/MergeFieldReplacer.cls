/**********************************************************************************************
@Description: Generic class to replace the merge fields
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/

public with sharing class MergeFieldReplacer {

    /******************************************************************************************************************************************
    @description: Method to replcae merge fields
    @return Type: String
    @param : Email Body, Process name, record Id
    ******************************************************************************************************************************************/
        public static String replaceMergeFields( String strContents, String processName
                                               , Id recordId , Set<String> setApiNames
                                               , List<Merge_Field_Mapping__mdt> listMergeFldMdt ) {
                                                   
                                                   String replacedContents =null;
  
            if( String.isNotBlank( strContents )
            && String.isNotBlank( processName )
            && recordId != null ) {
                
                String objectName = recordId.getSObjectType().getDescribe().getName();
                 if( String.isNotBlank( objectName ) ) {      
                    
                    if( !setApiNames.isEmpty() && !listMergeFldMdt.isEmpty() ) {
                        
                        //@description:Build query
                        String strQuery = 'SELECT ';
                        for( String apiName : setApiNames ) {
                            strQuery += apiName + ' ,';
                        }
                        strQuery = strQuery.removeEnd( ',');
                        strQuery = strQuery 
                                + ' FROM ' + objectName
                                + ' WHERE Id=\'' + recordId + '\'';                       
                       
                            List<sObject> listQueryResult = new List<sObject>();
                               //String escquery = String.escapeSingleQuotes(strQuery);
                                listQueryResult = Database.query( strQuery );
       
                            //@description:Replacing merge fields
                            if( !listQueryResult.isEmpty() ) {
                                
                                for( Merge_Field_Mapping__mdt mdt : listMergeFldMdt) {
                                    if( strContents.contains( mdt.Merge_Field__c ) ) {
        
                                        //@description:call method to get string value
                                        String strVal = getStringValue( mdt.Field_API_Name__c, listQueryResult[0]);
                                        
                                        if( String.isNotBlank( strVal ) ) {
                                            replacedContents = strContents.replace( mdt.Merge_Field__c , strVal );
                                        } else {
                                            replacedContents = strContents.replace( mdt.Merge_Field__c, '');
                                        }
                                    } 
                                }
                                return replacedContents;
                            }
                        
                    }//@description: End setApiName if
                }//@description: End objectName if
            }//@description:End main if
            return null;  
        }//@description: End replaceMergeFields method
     
    /******************************************************************************************************************************************
    @description:Method : Method to return String value from record
	@return     : String
    @param     : Api Name, sObject Instance    
    ******************************************************************************************************************************************/
        public static String getStringValue( String fieldApiName, sObject obj ) {
            
            if( fieldApiName.contains('.') ) {
                String strAfter = fieldApiName.subStringAfter('.');
                String relatedObject1 = fieldApiName.subStringBefore('.');
                if( strAfter.contains('.') ) {
                    
                    String relatedObject2 = strAfter.subStringBefore('.');
                    strAfter = strAfter.subStringAfter('.');
    
                    if( strAfter.contains('.') ) {
    
                        //@description: 3 level parenting
                        String relatedObject3 = strAfter.subStringBefore('.');
                        String fieldOfRelatedObj = strAfter.subStringAfter('.');                    
                        if( obj.getSobject( relatedObject1 ) != null 
                        && obj.getSobject( relatedObject1 ).getSobject( relatedObject2 ) != null
                        && obj.getSobject( relatedObject1 ).getSobject( relatedObject2 ).getSobject( relatedObject3 ) != null
                        && obj.getSobject( relatedObject1 ).getSobject( relatedObject2 ).getSobject( relatedObject3 ).get( fieldOfRelatedObj ) != null ) {
                            return String.valueOf( 
                                    obj.getSobject( relatedObject1 ).getSobject( relatedObject2 ).getSobject( relatedObject3 ).get( fieldOfRelatedObj ) 
                                );
                        } else {
                            return null;
                        }
                    }
                    else {
    
                        //@description: 2 level parenting
                        String fieldOfRelatedObj = strAfter;      
                        if(obj.getSobject( relatedObject1 ) != null 
                        && obj.getSobject( relatedObject1 ).getSobject( relatedObject2 ) != null
                        && obj.getSobject( relatedObject1 ).getSobject( relatedObject2 ).get( fieldOfRelatedObj ) != null) {
                            return String.valueOf( obj.getSobject( relatedObject1 ).getSobject( relatedObject2 ).get( fieldOfRelatedObj ) );
                        } else {
                            return null;
                        }
                    }
                }
                else {
    
                    //@description: 1 level parenting
                    if(obj.getSobject( relatedObject1 ) != null && obj.getSobject( relatedObject1 ).get( strAfter ) != null) {
                        return String.valueOf( obj.getSobject( relatedObject1 ).get( strAfter ) );
                    } else {
                        return null;
                    }
                }
            }
            else {            
                if( obj.get( fieldApiName ) != null ) {
                    return String.valueOf( obj.get( fieldApiName ) );
                } else {
                    return null;
                }
            }
        }
    }