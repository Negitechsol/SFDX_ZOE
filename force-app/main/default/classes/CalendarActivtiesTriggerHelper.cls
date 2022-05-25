/**********************************************************************************************
@Description: This Apex Trigger Helper is for inserting the activvities based on the infusion date.
----------------------------------------------------------------------------------------------
Version Date(DD-MM-YYYY)    Author              Version History 
-----------------------------------------------------------------------------------------------
1.1     11-01-2022          Microgrid           Initial Draft
***********************************************************************************************/
public with sharing class CalendarActivtiesTriggerHelper {
    public static void afterInsertHelper( list<User_Infusion_Dates__c>  infusion_DateList){
			if (Trigger.isUpdate) {
                List< User_Calendar__c > lstUserCalendar = new List<User_Calendar__c>();
                List< Notification__c > lstNotifications = new List<Notification__c>();
                if (Schema.sObjectType.User_Calendar__c.isAccessible()){
                lstUserCalendar =  [SELECT Id,Name,Event_Type__c FROM User_Calendar__c WHERE User_Infusion_Date_Id__r.Id=:infusion_DateList[0].Id];
                }
                if(lstUserCalendar.size() > 0){
                    for (User_Calendar__c ucal : lstUserCalendar) {
                        List< Notification__c > lstNotification = new List<Notification__c>();
                        if (Schema.sObjectType.Notification__c.isAccessible())
                        lstNotification =  [select id from Notification__c where RecordId__c=:ucal.Id];
                        ucal.Event_Type__c=ucal.Event_Type__c+'-U';
                        if(lstNotification.size() > 0){
                            for (Notification__c nf : lstNotification) {
                                lstNotifications.add(nf); 
                            }                           
                        }
                    
                    }                   
                    if(Schema.sObjectType.User_Calendar__c.isUpdateable()){
                    		update lstUserCalendar;
                    }
                    if(lstNotifications.size() > 0){
                        if(Schema.sObjectType.Notification__c.isDeletable()){
                    		delete lstNotifications;
                    	} 
                    }   
                }                
            } // update end here
        
            List<User_Calendar__c> userCalendarList=new List<User_Calendar__c>();
            List<User_Calendar__c> userLabTrackerList=new List<User_Calendar__c>();
        
             
            Date infusion_Date = infusion_DateList[0].Infusion_Date__c;
            
           
            List<Audit_Log__c> lstAudit = new List<Audit_Log__c>();
            Audit_Log__c objAudit_Log = MasterConfigController.createAuditRecord(infusion_DateList[0].Id,JSON.serialize(trigger.new),'User_Infusion_Dates__c','Insert');
            lstAudit.add(objAudit_Log);
            if( (!lstAudit.isEmpty() && lstAudit.size() > 0) && (Schema.sObjectType.Audit_Log__c.isCreateable()) ) {
             insert lstAudit;
           }
        
         if(Schema.sObjectType.Master_Configuration__c.isAccessible()){
           List<Master_Configuration__c> mcList =[SELECT Calendar_Activity__c,Calendar_Activity_desc__c,Calendar_Activity_duration__c,Calendar_Activity_duration_Type__c,Calendar_email_template__c,First_Notification__c,Second_Notification__c 
                                                FROM Master_Configuration__c where RecordType.Name='Calendar Activities'];
            for (Master_Configuration__c calAct : mcList) {    
            if(calAct.Calendar_Activity_duration__c!=null ){
                String durationType=calAct.Calendar_Activity_duration_Type__c;
                Integer duration=integer.valueof(calAct.Calendar_Activity_duration__c);
                String day='';
                String Week='';
                String FirstNotification=''; 
                String SecondNotification='';
                Integer numberDaysDue;
                Date Dateone;
                if(durationType.equalsignorecase('Month')){
                    Dateone = infusion_Date.addMonths(duration);
                    numberDaysDue = infusion_Date.daysBetween(Dateone);
                }else if(durationType.equalsignorecase('Year')){
                    Dateone = infusion_Date.addYears(duration);
                    numberDaysDue = infusion_Date.daysBetween(Dateone);
                }else if(durationType.equalsignorecase('Week')){
                    duration=duration*7;
                    Dateone = infusion_Date.addDays(duration);
                    numberDaysDue = infusion_Date.daysBetween(Dateone);
                }else{
                    Dateone = infusion_Date.addDays(duration);
                    numberDaysDue = infusion_Date.daysBetween(Dateone);
                }
                if(calAct.First_Notification__c !=null && calAct.First_Notification__c !=''){
                    Integer nDuration=integer.valueof(calAct.First_Notification__c);
                    Date nDate=infusion_Date.addDays(nDuration);
                    FirstNotification = string.valueofGmt(nDate);
                }
                if(calAct.Second_Notification__c !=null && calAct.Second_Notification__c !=''){
                    Integer nDuration=integer.valueof(calAct.Second_Notification__c);
                    Date nDate=infusion_Date.addDays(nDuration);
                    SecondNotification = string.valueofGmt(nDate);            
                }
                day=string.valueof(numberDaysDue);
                week=string.valueof(numberDaysDue/7);
                string Datestr = string.valueofGmt(Dateone);
                if(Schema.sObjectType.User_Calendar__c.isCreateable()){
                User_Calendar__c userCalendar=new User_Calendar__c();
                User_Calendar__c labtracker=new User_Calendar__c();
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Activity__c.isCreateable())
                userCalendar.Calendar_Activity__c=calAct.Calendar_Activity_desc__c;
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_email_template__c.isCreateable())
                userCalendar.Calendar_email_template__c=calAct.Calendar_email_template__c;
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Activity_Date__c.isCreateable())
                userCalendar.Calendar_Activity_Date__c=Datestr;
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Week__c.isCreateable())
                userCalendar.Calendar_Week__c=week;
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Day__c.isCreateable())
                userCalendar.Calendar_Day__c=day;
                if(Schema.sObjectType.User_Calendar__c.fields.Second_Notification_Date__c.isCreateable())
                userCalendar.Second_Notification_Date__c=SecondNotification;
                if(Schema.sObjectType.User_Calendar__c.fields.First_Notification_Date__c.isCreateable())
                userCalendar.First_Notification_Date__c=FirstNotification;
                if(Schema.sObjectType.User_Calendar__c.fields.User_Infusion_Date_Id__c.isCreateable())
                userCalendar.User_Infusion_Date_Id__c=infusion_DateList[0].id;
                if(Schema.sObjectType.User_Calendar__c.fields.Event_Type__c.isCreateable())
                userCalendar.Event_Type__c='CALENDAR';
                userCalendarList.add(userCalendar);
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Activity__c.isCreateable())
                labtracker.Calendar_Activity__c=calAct.Calendar_Activity_desc__c;
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Activity_Date__c.isCreateable())
                labtracker.Calendar_Activity_Date__c=Datestr;
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Week__c.isCreateable())
                labtracker.Calendar_Week__c=week;
                if(Schema.sObjectType.User_Calendar__c.fields.Calendar_Day__c.isCreateable())
                labtracker.Calendar_Day__c=day;
                if(Schema.sObjectType.User_Calendar__c.fields.User_Infusion_Date_Id__c.isCreateable())
                labtracker.User_Infusion_Date_Id__c=infusion_DateList[0].id;
                if(Schema.sObjectType.User_Calendar__c.fields.Event_Type__c.isCreateable())
                labtracker.Event_Type__c='LABTRACKER';
                userLabTrackerList.add(labtracker);

                }
                
            }
        
        }
         }
            if(userCalendarList.size() > 0){
                if (Schema.sObjectType.User_Calendar__c.isCreateable()){
                 insert userCalendarList;
                }
                 insert userLabTrackerList[0];
            }
            // Insert end here
    }

}