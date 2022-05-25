/**********************************************************************************************
@Description: Test class for ZOE_LoginCntrl coverage on method forgotPassword
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class ZOE_LoginCntrlTest {
    static testmethod void loginTest(){
        test.startTest();
        
          String result = ZOE_LoginCntrl.login('testuserName1','testPassword1');
           System.assertNotEquals(result,null,'Result is not null for Login return method');
         
             test.stopTest();
         }
    static testmethod void forgotPasswordTest(){
               test.startTest();
              String str=ZOE_LoginCntrl.forgotPassword('testUserName');
            System.assertNotEquals(str,null,'str is not null for ForgotPassword return method');
        test.stopTest();
         }
}