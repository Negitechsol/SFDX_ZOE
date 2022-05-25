/**********************************************************************************************
@Description: An apex page controller that exposes the CryptoEncryptDecrypt Functionalities
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class CryptoEncryptDecryptTest {
    	static testmethod void testEncryptPassword() {
            CryptoEncryptDecrypt objCryptoEncryptDecrypt = new CryptoEncryptDecrypt();
            objCryptoEncryptDecrypt.strActualPassword = 'Test data to encrypted';
            CryptoEncryptDecrypt.strKey = '00000000000000000000000000000000';
            
            Test.startTest();
     	    	objCryptoEncryptDecrypt.EncryptPassword();
            	objCryptoEncryptDecrypt.strActualPassword = objCryptoEncryptDecrypt.strResult;
            	objCryptoEncryptDecrypt.DecryptPassword();
            Test.stopTest();
            System.assertEquals('Test data to encrypted', objCryptoEncryptDecrypt.strResult);
		}
}