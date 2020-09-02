public class TriggerUtil_Task_Post {
    
    public void stampActivityText(List<Task> oldTasks, List<Task> newTasks){
        
         List<Task> leadTasks = new List<Task>();
         List<Task> accountTasks = new List<Task>();
         List<id> leadTaskIDs = new List<id>();
         List<id> accountTaskIDs = new List<id>();
         List<id> leadIDs = new List<id>();
         List<id> accountIDs = new List<id>();
         List<lead> updateLeads = new List<lead>();
         List<account> updateAccounts = new List<account>();
         Map<id,string> leadToStringMap = new Map<id,string>();
        
        
         For(integer i = 0; i<newTasks.size(); i++){
            //Get the Tasks that were just modified by the inside sales API.
            if(newTasks[i].status == 'Completed' && newTasks[i].isdc_dialer_query_name__c != NULL && oldTasks[i].isdc_dialer_query_name__c != newTasks[i].isdc_dialer_query_name__c){
                if(newTasks[i].whoID != NULL){
                    if(newTasks[i].whoID.getSobjectType() == Schema.Lead.sObjectType){
                        leadTaskIDs.add(newTasks[i].id);
                        leadIDs.add(newTasks[i].whoid);
                  }
                }
                
                if(newTasks[i].whatID != NULL){
                    if(newTasks[i].whatID.getSobjectType() == Schema.Account.sObjectType){
                        accountTaskIDs.add(newTasks[i].id);
                        accountIDs.add(newTasks[i].whatid);
                    }
                }
            }
        }
        
        //Send to workers
        if(leadTaskIDs.size() > 0){
          leadTasks = [SELECT owner.firstname, owner.lastname, whoid,isdc_dialer_query_name__c FROM task WHERE id IN: leadTaskIDs];
          updateLeads = TriggerUtil_Task_Post.leadsToUpdate(leadTasks,leadIDs);
        }
        
        if(updateLeads.size() > 0){
            update updateLeads;
        }
        
        if(accountTaskIDs.size() > 0){
          accountTasks = [SELECT owner.firstname, owner.lastname, whatid,isdc_dialer_query_name__c FROM task WHERE id IN: accountTaskIDs];
          updateAccounts = TriggerUtil_Task_Post.accountsToUpdate(accountTasks,accountIDs);
        }
        
        if(updateAccounts.size() > 0){
            update updateAccounts;
        }
           
        
    }
    
    public static List<Lead> leadsToUpdate (list<Task> leadTasks, list<id> leadIDs){
        List<Lead> leadsToUpdate = new List<Lead>();
        
        List<lead> leads = [SELECT Last_Activity__c, firstname, lastname FROM lead WHERE id IN: leadIDs];
        
        For(lead l: leads){
            For(Task e: leadTasks){
                if(l.id == e.whoid){
                    //string initials = e.owner.firstname.SubString(0,1) + e.owner.firstname.SubString(0,1);
                    l.last_activity__c = TriggerUtil_Task_Post.buildActivityText(e);
                    leadsToupdate.add(l);
                }
            }
        }

        return leadsToUpdate;
    }
    
    public static List<Account> accountsToUpdate (list<Task> accountTasks, list<id> accountIDs){
        
        List<Account> accountsToUpdate = new List<Account>();
        List<Account> Accounts = [SELECT Last_Activity__c, firstname, lastname, recordtypeid FROM account WHERE id IN: accountIDs AND recordtypeid = '012U0000000MGbW'];
        For(Account l: Accounts){
            For(Task e: accountTasks){
                if(l.id == e.whatid){
                    //string initials = e.owner.firstname.SubString(0,1) + e.owner.firstname.SubString(0,1);
                    l.last_activity__c = TriggerUtil_Task_Post.buildActivityText(e);
                    accountsToupdate.add(l);
                }
            }
        }
        return accountsToUpdate;
    }
    
    public static string buildActivityText(Task e){
        string activityText;
        
        //activityText = initials + ' | ' + TriggerUtil_Task_Post.formatDateTime(system.now()) + ' | ' + e.isdc_dialer_query_name__c;
        activityText = e.isdc_dialer_query_name__c;
        
        return activityText;
    }
    
    public static string formatDateTime(datetime activityDateTime){
        
        string formattedDate = activityDateTime.format('MM/dd/yyyy h:mm a');
        
        return formattedDate;

    }
    
                                            
                                            
                                          

}