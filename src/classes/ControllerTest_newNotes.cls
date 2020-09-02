@istest (SeeAllData=TRUE)
Private class ControllerTest_newNotes{
        
        public static testMethod void test_Controller_newNotes(){
        
            Account acc = new Account();
        
            acc = TestUtilities.createAccount();
            
            opportunity o = new opportunity();
            
            o.name = 'Test';
            o.stagename = 'test';
            o.CloseDate = system.today();
            o.LeadSource = 'source';
            o.accountid = acc.id;
            o.HECM_Type__c = 'test';
            o.Pitch_scheduled_date_time__c = system.now();
            
            insert o;
            
            Con_Log__c c = new Con_Log__c();
            c.opportunity__c = o.id;
            c.Notes__c = 'test';
            insert c;
            
            PageReference pageRef = Page.newNote;
            pageRef.getParameters().put('opportunityID', o.id);
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(c);
            controller_newNote newNote = new controller_newNote(sc);
            
            
            newNote.getActiveUsers();
            newNote.getSelectedUsers();
            newNote.saveMe();
            newNote.cancelMe();
            
            
            
        
        }
}