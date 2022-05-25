public with sharing class Testdatafactoryuser {
    @future
    public static void insertUser() {
        Profile objProfile ;
        UserRole r;
        PermissionSet ps ;
        if(Schema.sObjectType.Profile.isAccessible())
           objProfile = [SELECT Id FROM Profile WHERE Name='Customer Community Plus User'];
        if(Schema.sObjectType.UserRole.isAccessible())
          r = [SELECT Id FROM UserRole WHERE Name='	NEUROLOGIST Customer User'];
        
  User objUser = new User(Alias = 'standt', Email='standarduser@novartis.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = objProfile.Id, 	userroleid = r.Id,
                                TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest@novartis.com');
        if(Schema.sObjectType.User.isCreateable())
        insert objUser;
        if(Schema.sObjectType.PermissionSet.isAccessible())
          ps = [SELECT Id FROM PermissionSet WHERE Name = 'Customer Community Plus'];
        if(Schema.sObjectType.PermissionSetAssignment.isCreateable())
insert new PermissionSetAssignment(AssigneeId = objUser.id, PermissionSetId = ps.Id);

        //insert(objUser);
    }
}