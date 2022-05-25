/**********************************************************************************************
@Description: An apex page controller that exposes the CryptoEncryptDecrypt functionality
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public  with Sharing  class CryptoEncryptDecrypt {
    public string strActualPassword{get;set;}
    public string strResult{get;set;}
    public static string strKey = label.CryptoKey;
    public static Blob keyblobval;
    public CryptoEncryptDecrypt() {
        strActualPassword = '';
        strResult = '';
    }
    public void EncryptPassword(){
        if(strActualPassword!=null && strActualPassword!=''){
            strResult = getEncryptedValue(strActualPassword);
         }
    }
    public void DecryptPassword(){
        strResult = getDecryptedValue(strActualPassword);
    }
    @auraEnabled
    public static string getEncryptedValue(string strActualPassword){
        keyblobval = getProtectedKey();
        Blob EncryptedPasswordBlob = Crypto.encryptWithManagedIV('AES256', keyblobval, Blob.valueOf(strActualPassword));
        string strEncryptedPasswordText = EncodingUtil.base64Encode(EncryptedPasswordBlob); 
        return strEncryptedPasswordText;
    }
    @auraEnabled
    public static string getDecryptedValue(string strActualPassword){
        keyblobval = getProtectedKey();
        Blob encodedEncryptedBlob = EncodingUtil.base64Decode(strActualPassword);
        Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', keyblobval, encodedEncryptedBlob);
        String decryptedPasswordText = decryptedBlob.toString();
         return decryptedPasswordText;
    }
    @auraEnabled
    public static Blob getProtectedKey(){
        if (Schema.sObjectType.CryptoKeyDetails__c.isCreateable()){
        List<CryptoKeyDetails__c> lstCryptoKeyDetails = [SELECT Id,Name,Key__c FROM CryptoKeyDetails__c WHERE Name = 'Encryptionkey' LIMIT 1];
		if( lstCryptoKeyDetails == null ) {
            CryptoKeyDetails__c objCryptoKeyDetails = new CryptoKeyDetails__c();
    		objCryptoKeyDetails.Name = 'Encryptionkey';
            objCryptoKeyDetails.key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
            insert objCryptoKeyDetails;
        }else if(lstCryptoKeyDetails!=null && lstCryptoKeyDetails.isEmpty()){
            CryptoKeyDetails__c objCryptoKeyDetails = new CryptoKeyDetails__c();
    		objCryptoKeyDetails.Name = 'Encryptionkey';
            objCryptoKeyDetails.key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
            insert objCryptoKeyDetails;
        }
        }
        return EncodingUtil.base64Decode(CryptoKeyDetails__c.getInstance('Encryptionkey').key__c);
    }
}