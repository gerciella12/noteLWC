/**************************************************************************
* File Name: TestUtilities
* Description: Test Utilities Class for creating records.
*************************************************************************/

@isTest
public with sharing class TestUtilities {
   public static Id accountId;
   public static testMethod Opportunity createOpportunity() {
      system.debug('Created Account Id'+TestUtilities.accountId);
      Opportunity opp = new Opportunity();
      opp.Name = 'Test Opportunity';
      opp.StageName = 'Qualified';
      opp.CloseDate = system.today();
      opp.LeadSource = 'Other';
      opp.AccountId = TestUtilities.accountId;
      opp.HECM_Type__c = 'HECM TO HECM';
      opp.Pitch_scheduled_date_time__c = system.now();
      try{
       insert opp;
       system.assertEquals('Test Opportunity',opp.Name);
       return opp;
     }catch(DMLException e){
       system.debug(e.getMessage());
     }
      return null;
   }
   
   public static testMethod Account createAccount() {
     Account acc = new Account();
     List<RecordType> accountTypes = new List<RecordType>([SELECT Id FROM RecordType WHERE sObjectType =: 'Account' AND DeveloperName ='PersonAccount']);
     if(accountTypes != null && accountTypes.size() > 0){
        acc.RecordTypeId = accountTypes[0].Id;
     }
     acc.firstName = 'Testing';
     acc.LastName = 'Test Account';
     acc.Contact_Status__c = 'Client';
     acc.PersonLeadSource = 'Other';
     acc.BillingCountryCode = 'US';
     acc.BillingStreet = 'Test Street';
     acc.BillingCity = 'Test City';
     acc.BillingStateCode = 'AL';
     acc.BillingPostalCode = '12345';
     acc.Property_Type__c = 'SFR';
     acc.Property_Value__c = 10;
     acc.Mortgage_Balance__c = 10;
     acc.Monthly_Payment__c = 10;
     acc.Loan_officer_value_estimate__c = 10;
     try{
       insert acc;
       system.assertEquals('Test Account',acc.LastName);
       accountId = acc.Id;
       return acc;
     }catch(DMLException e){
       system.debug(e.getMessage());
     }
     return null;
   }
   
   public static testMethod Task createTask(){
     try{
       Task task = new Task();
       task.OwnerId = userInfo.getUserId();
       task.Subject = 'test';
       task.Status = 'Not Started';
       task.Priority = 'Normal';
       insert task;
       return task;
     }catch(DMLException e){
       system.debug(e.getMessage());
     }
     return null; 
   }
   
   public static void createEvents(integer numLeads, integer numEvents, account a){
       
       
       List<lead> leads = new List<lead>();
        for (Integer p=0; p<numLeads; p++){
            leads.add(new lead(
                firstName = 'firstname',
                lastname='Test',
                state = 'ca',
                phone = '(777) 999-0000',
                email = 'someaddress@email.com',
                company = 'test'));
        }
        insert leads; 
       
        List<event> events = new List<event>();
        for (Integer m=0;m<numLeads;m++) {
            lead lead = leads[m];            
            // For each lead just inserted, add events
            for (Integer n=numEvents*m;n<numEvents*(m+1);n++) {
                events.add(new event(
                    whoID=lead.Id,
                    ActivityDateTime = system.now(),
                    DurationInMinutes = 60,
                    isdc_dialer_query_name__c = 'test'));
            }
        }
        insert events;
        
        List<event> events2 = new List<event>();
        for (Integer m=0;m<numLeads;m++) {
            lead lead = leads[m];            
            // For each lead just inserted, add events
            for (Integer n=numEvents*m;n<numEvents*(m+1);n++) {
                events2.add(new event(
                    whatID = a.id,
                    ActivityDateTime = system.now(),
                    DurationInMinutes = 60,
                    isdc_dialer_query_name__c = 'test'));
            }
        }
        insert events2;
   
   
   }
   
   public static void createtasks(integer numLeads, integer numtasks, account a){
       
       
       List<lead> leads = new List<lead>();
        for (Integer p=0; p<numLeads; p++){
            leads.add(new lead(
                firstName = 'firstname',
                lastname='Test',
                state = 'ca',
                phone = '(777) 999-0000',
                email = 'someaddress@email.com',
                company = 'test'));
        }
        insert leads; 
       
        List<task> tasks = new List<task>();
        for (Integer m=0;m<numLeads;m++) {
            lead lead = leads[m];            
            // For each lead just inserted, add tasks
            for (Integer n=numtasks*m;n<numtasks*(m+1);n++) {
                tasks.add(new task(
                    whoID=lead.Id,
                    activityDate = system.today(),
                    isdc_dialer_query_name__c = 'test'));
            }
        }
        insert tasks;
        
        List<task> tasks2 = new List<task>();
        for (Integer m=0;m<numLeads;m++) {
            lead lead = leads[m];            
            // For each lead just inserted, add tasks
            for (Integer n=numtasks*m;n<numtasks*(m+1);n++) {
                tasks2.add(new task(
                    whatID = a.id,
                    activityDate = system.today(),
                    isdc_dialer_query_name__c = 'test'));
            }
        }
        insert tasks2;
   
   
   }
   


}