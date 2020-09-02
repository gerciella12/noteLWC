@isTest 
private class TriggerTests_stampActivityText{
    
    static testMethod void stampActivityTextLead() {
        Account acc = new Account();
        
        acc = TestUtilities.createAccount();
        
        TestUtilities.createTasks(1,1,acc);
        
        List<Task> Tasks = [SELECT id,isdc_dialer_query_name__c FROM Task];
        
        List<Task> TasksToUpdate = new List<Task>();
        
        For(Task e: Tasks){
            e.status = 'Completed';
            e.isdc_dialer_query_name__c = 'testing2';
            TasksToUpdate.add(e);
        }
        
        update TasksToUpdate;

    }
}