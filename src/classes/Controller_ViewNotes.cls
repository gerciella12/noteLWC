public class Controller_ViewNotes {
 

    public Controller_ViewNotes(ApexPages.StandardController controller) {
     
        opportunityID = ApexPages.currentPage().getParameters().get('id');
        
        
    }


    public string opportunityID {get; set;}
    
    public Controller_ViewNotes(){
        opportunityID = ApexPages.currentPage().getParameters().get('id');

        
  
        
    }
    
    
    public Void setPageSize(Integer pageSize){
       
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT id, notes__c, createdDate, opportunity__c, name FROM Con_Log__c WHERE opportunity__c =: opportunityID ORDER BY createddate DESC]));
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<Con_Log__c> getNotes() {
        setCon.setpagesize(500);
        return (List<Con_Log__c>) setCon.getRecords();
    }
    
    
    public PageReference newNote() {
    
        pageReference pageRef = new pageReference('/apex/newNote?opportunityID=' + opportunityID);
        pageRef.setRedirect(true);
        return pageRef;
    }

    

}