public with sharing class notesLWC_Helper {
    @AuraEnabled(Cacheable=true)
 public static Map<String, Object> retrieveNotes(String opportunityId) {
        System.debug('==> OpportunityId'+ opportunityId );
        Map<String, Object> status = new Map<String, Object>{'__status' => 'error'};
       List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Id =: opportunityId];
        if (!opportunities.isEmpty()) {
            List<Con_Log__c> conLogs = [
                   // SELECT id, notes__c, createdDate, opportunity__c, name, Selected_Users__c
                   SELECT Id, CreatedDate, CreatedBy.Id, CreatedBy.Name, Opportunity__c, Notes__c, Selected_Users__c
                    FROM Con_Log__c
                    WHERE Opportunity__c =: opportunities[0].Id
                    ORDER BY CreatedDate DESC
            ];
            System.debug('==> OppENt'+ conLogs );
            List<Map<String, Object>> wraps = new List<Map<String, Object>>();
            for (Con_Log__c conLog : conLogs) {
                wraps.add(new Map<String, Object>{
                        'id' => conLog.Id,
                        'CreatedDate' => conLog.CreatedDate.format('MM/dd/yyyy h:mm a'),
                        'CreatedById' => new Map<String, Object>{
                                'id' => conLog.CreatedBy.Id,
                                'name' => conLog.CreatedBy.Name
                        },
                        'note' => conLog.Notes__c
                });
            }
            System.debug('==> wraps'+ wraps );

            status = new Map<String, Object>{
                    '__status' => 'success',
                    'wraps' => wraps
            };
        } else {
            status.put('__msg', 'Empty Record');
        }
        return status;
    }

   /* @AuraEnabled(cacheable=true)
    public static List<Opportunity> retrieveNotes2() {
       List<Con_Log__c> conLogs = [
                // SELECT id, notes__c, createdDate, opportunity__c, name, Selected_Users__c
                SELECT id, CreatedDate, CreatedBy.Id, CreatedBy.Name, Opportunity__c, Notes__c, Selected_Users__c
                FROM Con_Log__c
                WHERE Opportunity__c =: opportunityId
                ORDER By CreatedDate DESC
        ];
        List<Opportunity> conLogs = [
                // SELECT id, notes__c, createdDate, opportunity__c, name, Selected_Users__c
                SELECT id, CreatedDate, CreatedBy.Id
                FROM Opportunity
                LIMIT 5

        ];
        return conLogs;
    } */

    //new note save
    @AuraEnabled
    public static Map<String, Object> saveInput(Map<String, Object> params) {
        Map<String, Object> status = new Map<String, Object>{'__status' => 'error'};
       // List<Opportunity> opportunities2 = [SELECT Id FROM Opportunity WHERE id =: opportunityId2];
        try {
            //Need to get Opp related ConLog
                    Con_Log__c note = new Con_Log__c(
                    Notes__c = (String) params.get('note')
                    );
                    insert note;
                    status = new Map<String, Object>{
                    '__status' => 'success',
                    'noteId' => note.Id
        };
       } catch (Exception e) {
           status.put('__msg', e.getMessage());
        }
        return status;
        }

    //selectedUsers

}