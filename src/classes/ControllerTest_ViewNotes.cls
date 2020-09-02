@istest 
Private class ControllerTest_ViewNotes{
        
        public static testMethod void test_Controller_ViewNotes(){
        
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
            
            
            ApexPages.StandardController sc = new ApexPages.StandardController(o);
            Controller_ViewNotes viewNotes = new Controller_ViewNotes(sc);
            
            PageReference pageRef = Page.viewNotes;
            pageRef.getParameters().put('id', String.valueOf(o.Id));
            Test.setCurrentPage(pageRef);

            viewNotes.newNote();
            viewNotes.getNotes();
            
        
        }
        
        static testMethod void testMultiselectController() {
            MultiselectController c = new MultiselectController();
            
            c.leftOptions = new List<SelectOption>();
            c.rightOptions = new List<SelectOption>();
    
            c.leftOptionsHidden = 'A&a&b&b&C&c';
            c.rightOptionsHidden = '';
            
            System.assertEquals(c.leftOptions.size(), 3);
            System.assertEquals(c.rightOptions.size(), 0);
    }
}