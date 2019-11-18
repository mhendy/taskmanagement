public with sharing class TaskController {    
    @AuraEnabled     
    public static void addTask(String taskJsonDetails) {        
        try{
            ResourceTask__c taskToCreate = (ResourceTask__c) JSON.deserialize(taskJsonDetails, ResourceTask__c.class);            
            TaskServices.createTask(taskToCreate);
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }       
    }    
    @AuraEnabled     
    public static List<ResourceTask__c> getTasks() {        
        List<ResourceTask__c> allTasks = new List<ResourceTask__c>();
        try{            
            allTasks = TaskServices.getTasks();
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return allTasks;       
    }    
}
