public with sharing class TaskServices {
    @TestVisible
    private static String taskQueryBase {
        get{
            if(taskQueryBase == null){
                taskQueryBase = 'SELECT id, Name, Due_Date__c, Description__c'
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
    public static List<ResourceTask__c> getTasks(){        
        List<ResourceTask__c> tasksFound = new List<ResourceTask__c>();

        for(ResourceTask__c taskFound : database.query(taskQueryBase + '\''+ UserInfo.getUserId()+'\'')){
            tasksFound.add(taskFound);
        }
        return tasksFound;
    }
}
