/**********************************************************************************************
@Description: An apex page controller that exposes the ZOE Master Configurations
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
@isTest
public class MasterConfigControllerTest {
    @testSetup static void setup() {
        test.startTest();
        Id zkitrecordtypeid=Schema.SObjectType.Master_Configuration__c.getRecordTypeInfosByName().get('Z-Kit Calculator').getRecordTypeId();
        Id trainingtypeid=Schema.SObjectType.Master_Configuration__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
        Id instrecordtypeid=Schema.SObjectType.Master_Configuration__c.getRecordTypeInfosByName().get('Institution Master').getRecordTypeId();
        Id calendarrecordtypeid=Schema.SObjectType.Master_Configuration__c.getRecordTypeInfosByName().get('Calendar Activities').getRecordTypeId();
        List<Master_Configuration__c> configlist=new List<Master_Configuration__c>();
        Master_Configuration__c conf=new Master_Configuration__c();
        conf.Infusion_Center_Id__c='Test';
        conf.Infusion_Center_Name__c='Test';
        conf.Infusion_Center_Address__c='Test';
        conf.Street__c='Test';
        conf.State__c='Test';
        conf.City__c='Test';
        conf.Country__c='Test';
        conf.PostalCode__c='123456';
        conf.Active__c= true;
        conf.Address_2__c='test';
         conf.Address_1__c='test';   
         conf.Address_3__c='test';
        conf.Calendar_Activity__c='test';
        conf.Calendar_Activity_desc__c='test';
        conf.Calendar_Activity_duration__c='12';
        conf.Calendar_Activity_Duration_Type__c='Day';
        conf.Calendar_email_template__c='Infusion day';
        conf.Description__c='test';
        conf.Dosage__c= 2;
        conf.End_Weight__c= 2;
        conf.First_Notification__c='test';
        conf.Institution_Id__c='test';
        conf.Institution_Name__c='test';
        conf.Link__c='www.salesforce.com';
        conf.Weight_Range__c='1-2';
        conf.Record_Status__c='t';
        conf.Second_Notification__c='test';
        conf.Spanish_Calendar_Activity__c='test';
        conf.Spanish_Calendar_Activity_Description__c='test';
        conf.Start_Weight__c= 2;
        conf.Training_Name__c='test';
        conf.Type__c='PDF';
        conf.Vial5_5__c= 1;
        conf.Vial8_3__c= 1;
        conf.Viales_Totales__c= 1;
         conf.RecordTypeId=zkitrecordtypeid;
        configlist.add(conf);
        Master_Configuration__c conf1=new Master_Configuration__c();
        
        
          conf1.Infusion_Center_Id__c='Test';
        conf1.Infusion_Center_Name__c='Test';
        conf1.Infusion_Center_Address__c='Test';
        conf1.Street__c='Test';
        conf1.State__c='Test';
        conf1.City__c='Test';
        conf1.Country__c='Test';
        conf1.PostalCode__c='123456';
        conf1.Active__c= true;
        conf1.Address_2__c='test';
         conf1.Address_1__c='test';   
         conf1.Address_3__c='test';
        conf1.Calendar_Activity__c='test';
        conf1.Calendar_Activity_desc__c='test';
        conf1.Calendar_Activity_duration__c='12';
        conf1.Calendar_Activity_Duration_Type__c='Day';
        conf1.Calendar_email_template__c='Infusion day';
        conf1.Description__c='test';
        conf1.Dosage__c= 2;
        conf1.End_Weight__c= 2;
        conf1.First_Notification__c='test';
        conf1.Institution_Id__c='test';
        conf1.Institution_Name__c='test';
        conf1.Link__c='https://www.youtube.com/embed/VSsGwM7xuCw';
        conf1.Weight_Range__c='1-2';
        conf1.Record_Status__c='t';
        conf1.Second_Notification__c='test';
        conf1.Spanish_Calendar_Activity__c='test';
        conf1.Spanish_Calendar_Activity_Description__c='test';
        conf1.Start_Weight__c= 2;
        conf1.Training_Name__c='test';
        conf1.Type__c='Video';
        conf1.Vial5_5__c= 1;
        conf1.Vial8_3__c= 1;
        conf1.Viales_Totales__c= 1;
       conf1.RecordTypeId=trainingtypeid;
        configlist.add(conf1);
        Master_Configuration__c conf2=new Master_Configuration__c();
         conf2.Infusion_Center_Id__c='Test';
        conf2.Infusion_Center_Name__c='Test';
        conf2.Infusion_Center_Address__c='Test';
        conf2.Street__c='Test';
        conf2.State__c='Test';
        conf2.City__c='Test';
        conf2.Country__c='Test';
        conf2.PostalCode__c='123456';
        conf2.Active__c= true;
        conf2.Address_2__c='test';
         conf2.Address_1__c='test';   
         conf2.Address_3__c='test';
        conf2.Calendar_Activity__c='test';
        conf2.Calendar_Activity_desc__c='test';
        conf2.Calendar_Activity_duration__c='12';
        conf2.Calendar_Activity_Duration_Type__c='Day';
        conf2.Calendar_email_template__c='Infusion day';
        conf2.Description__c='test';
        conf2.Dosage__c= 2;
        conf2.End_Weight__c= 2;
        conf2.First_Notification__c='test';
        conf2.Institution_Id__c='test';
        conf2.Institution_Name__c='test';
        conf2.Link__c='www.salesforce.com';
        conf2.Weight_Range__c='1-2';
        conf2.Record_Status__c='t';
        conf2.Second_Notification__c='test';
        conf2.Spanish_Calendar_Activity__c='test';
        conf2.Spanish_Calendar_Activity_Description__c='test';
        conf2.Start_Weight__c= 2;
        conf2.Training_Name__c='test';
        conf2.Type__c='PDF';
        conf.Vial5_5__c= 1;
        conf2.Vial8_3__c= 1;
        conf2.Viales_Totales__c= 1;
        conf2.RecordTypeId=instrecordtypeid;
        configlist.add(conf2);
        
        Master_Configuration__c conf3=new Master_Configuration__c();
        conf3.Infusion_Center_Id__c='Test';
        conf3.Infusion_Center_Name__c='Test';
        conf3.Infusion_Center_Address__c='Test';
        conf3.Street__c='Test';
        conf3.State__c='Test';
        conf3.City__c='Test';
        conf3.Country__c='Test';
        conf3.PostalCode__c='123456';
        conf3.Active__c= true;
        conf3.Address_2__c='test';
        conf3.Address_1__c='test';   
        conf3.Address_3__c='test';
        conf3.Calendar_Activity__c='test';
        conf3.Calendar_Activity_desc__c='test';
        conf3.Calendar_Activity_duration__c='12';
        conf3.Calendar_Activity_Duration_Type__c='Day';
        conf3.Calendar_email_template__c='Infusion day';
        conf3.Description__c='test';
        conf3.Dosage__c= 2;
        conf3.End_Weight__c= 2;
        conf3.First_Notification__c='test';
        conf3.Institution_Id__c='test';
        conf3.Institution_Name__c='test';
        conf3.Link__c='www.salesforce.com';
        conf3.Weight_Range__c='1-2';
        conf3.Record_Status__c='t';
        conf3.Second_Notification__c='test';
        conf3.Spanish_Calendar_Activity__c='test';
        conf3.Spanish_Calendar_Activity_Description__c='test';
        conf3.Start_Weight__c= 2;
        conf3.Training_Name__c='test';
        conf3.Type__c='PDF';
        conf3.Vial5_5__c= 1;
        conf3.Vial8_3__c= 1;
        conf3.Viales_Totales__c= 1;
        conf3.RecordTypeId=calendarrecordtypeid;
        configlist.add(conf3);
        
        insert configlist;
        test.stopTest();
       }
    static testMethod void configTest() {
        Map<String,String> dosages=new Map<String,String>();
        dosages=MasterConfigController.getDosage();
        System.assertNotEquals(dosages.size(),0,'Dosage size is greater than zero');
        Map<String,String> dosage=InfusionCenter.getDosage();
        System.assertNotEquals(null, dosage,'Dosage is not null'); 
        List<Master_Configuration__c> trainings=MasterConfigController.gettrainings();
        System.assertNotEquals(trainings.size(),0,'Trainings size is greater than zero');
        List<Master_Configuration__c> institutionCenters=MasterConfigController.getInstitutionName();
        System.assertNotEquals(institutionCenters.size(),0,'InstitutionCenters size is greater than zero');
        List<String> instituteNames=ZOE_LoginCntrl.getInstitutionName();
        System.assertNotEquals(instituteNames.size(),0,'InstitutionNames size is greater than zero');
    }
    static testMethod void getSelectedOptions() {
          String value1='puede o no tener una relación causal con el medicamento recibido';
         String value2='Dentro de las 24hs de haber tomado contacto con el mismo';
         String value3='Si, porque existe un escenario especial';
         String value4='Casilla genérica de mail, página web';
        
        Integer count = MasterConfigController.getSelectedOptions(value1,value2,value3,value4);
        System.assertNotEquals(count,0,'Count is greater than zero');
    }
     static testMethod void getSelectedOptions2() {
          String value1='– 60 °C';
         String value2='12 horas';
         String value3='Verdadero';
         String value4='Falso';
         String value5='El vial no se debe usar';
         String value6='Verdadero';
         String value7='8 horas';
        Integer count = MasterConfigController.getSelectedOptions2(value1,value2,value3,value4,value5,value6,value7);
        System.assertNotEquals(count,0,'Count is greater than zero');
     }
     static testMethod void getSelectedOptions3() {
          String value1='Todas las anteriores';
         String value2='Corticoides sistémicos (prednisolona oral 1mg/kg/día)';
         String value3='Verdadero';
         String value4='Infusión lenta, durante 60 minutos';
         String value5='Colocar un catéter primario en una vena periférica; y un catéter de respaldo';
         String value6='3 meses';
        Integer count = MasterConfigController.getSelectedOptions3(value1,value2,value3,value4,value5,value6);
        System.assertNotEquals(count,0,'Count is greater than zero');
     }
    }