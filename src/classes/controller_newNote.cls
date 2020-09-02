public class controller_newNote {

    public string note {get;set;}
    public string opportunityID {get;set;}
    public Con_Log__c response{get; set;}
    private ApexPages.StandardController stdController;
    public boolean editing {get; set;}
    public string oppName {get;set;}
    
    public SelectOption[] selectedUsers{ get; set; }
    public SelectOption[] allUsers{ get; set; }
    public string selectedUsersString{get;set;}
    set<String> strSelectedUsers;

    public controller_newNote(ApexPages.StandardController controller) {

        this.stdController = controller;
        response = (Con_Log__c)controller.getRecord();
        
        opportunityID = ApexPages.currentPage().getParameters().get('opportunityID');
        oppName = [SELECT name FROM opportunity WHERE id =: opportunityID].name;
        
        editing = FALSE;
        //if(response.notes__c != NULL) editing = TRUE;
        
    }
    
    public pageReference saveMe() {
        
        //Get the note and add date/user name and save, then return to list
        
        try{
        
        string finalText = '';    
            if(editing == FALSE){
                finalText = system.now().format() + ' : ' + UserInfo.getName() + ' : ' + response.notes__c;
            }else{
                finalText = response.notes__c;
            }

        response.notes__c = finalText;
        response.opportunity__c = opportunityID;
        response.selected_users__c = getSelectedUsers();
        
        upsert response;
        
        List<Messaging.SingleEmailMessage> mails = new List<messaging.SingleEmailMessage>();
        
        id emailTemplateId = [Select Id, Name
                                            From EmailTemplate 
                                            Where name = 'ConLog Notification'
                                            ].id;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        string userEmails = getSelectedUsers();

            string reformatted = userEmails.replace(';',',');
            
            List<String> sendTo = new List<String>();
            String[] result = reformatted.split(',');
            system.debug(result + 'resultsss');
            for(integer i = 0; i<result.size() ; i++){
                sendTo.add(result[i].replace(',',''));
            }
            
            mail.setToAddresses(sendTo);
            
            // Step 3: Set who the email is sent from
            mail.setReplyTo(userInfo.getUserEmail());
            mail.setSenderDisplayName(userInfo.getName());
            
            // Set the activity history 
            mail.setSaveAsActivity(false);
            
            // Step 4. Set email contents - you can use variables!
              mail.setSubject('ConLog');
              String body = 'Team,<br><br> ';
              body += 'Opportunity - ' + oppName + ' has been updated with the following note:<br>';
              body += '<a href="https://gereverse.my.salesforce.com/' + opportunityID+'">Link to Opportunity</a><br><br>';
              body += response.Notes__c;
              
              mail.setHtmlBody(body);
            
            
            mails.add(mail);
            if(test.IsRunningTest() == FALSE && userEmails != ''){
                Messaging.sendEmail(mails);
            }  
                         
        pageReference pageRef = new pageReference('/apex/viewNotes?id=' + opportunityID);
        pageRef.setRedirect(true);
        return pageRef;
        
        }catch(System.DMLException ex){       
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning, ex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
        
    }
    
    
    
    public List<SelectOption> getActiveUsers() {
        selectedUsers =  new List<SelectOption>();
        strSelectedUsers = new set<String>();
        List<Con_Log__c> selectedUserList = [select id, Selected_Users__c from Con_Log__c where id =: response.id];
        if(!selectedUserList.isEmpty()){
            if(selectedUserList[0].Selected_Users__c != null){
                string[] arrSelUsers = selectedUserList[0].Selected_Users__c.split(';');
                for(String str: arrSelUsers){
                    selectedUsers.add(new SelectOption(str, str));
                    strSelectedUsers.add(str);
                }
            }
        }
        
        
        system.debug('Previously Selected Users:'+strSelectedUsers);
        List<SelectOption> availableUsers = new List<SelectOption>();
        List<user> users = [select id, isActive, email,name from User where isactive =: TRUE AND email NOT in: strSelectedUsers];
        allUsers = new List<SelectOption>();
        for (user d : users) {
            allUsers.add(new SelectOption(d.email, d.name));
        }
        return allUsers;
    }
    
    
    public string getSelectedUsers() {
    
        selectedUsersString = '';
        
        integer count = 0;
        for(integer i = 0; i<selectedUsers.size() ; i++){
            if((i + 1) == selectedUsers.size()){
                selectedUsersString += selectedUsers[i].getValue();
            }else{
                selectedUsersString += selectedUsers[i].getValue() +',';
            }
        }
        system.debug(selectedUsersString + 'asdfasdf');
        return selectedUsersString;
        
    }


    public PageReference cancelMe() {
    
        pageReference pageRef = new pageReference('/apex/viewNotes?id=' + opportunityID);
        pageRef.setRedirect(true);
        return pageRef;
    }

}