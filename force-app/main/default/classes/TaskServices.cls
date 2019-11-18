public with sharing class TaskServices {
    @TestVisible
    private static String taskQueryBase {
        get{
            if(taskQueryBase == null){
                taskQueryBase = 'SELECT id, Name, Due_Date__c, Description__c, Completed__c'
                                  +' FROM ResourceTask__c'
                                  +' WHERE OwnerId = ';                                  
            }
            return taskQueryBase;
        }
        set;
    }

    public static void createTask(ResourceTask__c taskToCreate){        
        insert taskToCreate;
    }
    public static void completeTask(String taskIdToComplete){        
        ResourceTask__c taskRecordToComplete = new ResourceTask__c(Id = taskIdToComplete);
        taskRecordToComplete.Completed__c = true;
        update taskRecordToComplete;
    }
    
    public static void deleteTask(String taskIdToDelete){        
        ResourceTask__c taskRecordToDelete = new ResourceTask__c(Id = taskIdToDelete);        
        delete taskRecordToDelete;
    }
    public static List<ResourceTask__c> getTasks(){        
        List<ResourceTask__c> tasksFound = new List<ResourceTask__c>();

        for(ResourceTask__c taskFound : database.query(taskQueryBase + '\''+ UserInfo.getUserId()+'\'')){
            tasksFound.add(taskFound);
        }
        return tasksFound;
    }
    public static List<ResourceTask__c> getFilteredTasks(String additionalFilter){        
        List<ResourceTask__c> tasksFound = new List<ResourceTask__c>();

        String finalQuery = taskQueryBase + '\''+ UserInfo.getUserId()+'\'' + additionalFilter;
        for(ResourceTask__c taskFound : database.query(finalQuery)){
            tasksFound.add(taskFound);
        }
        return tasksFound;
    }
}
