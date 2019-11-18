public with sharing class TaskController {    
    @AuraEnabled     
    public static void addTask(String taskJsonDetails) {        
        try{
            ResourceTask__c taskToCreate = (ResourceTask__c) JSON.deserialize(taskJsonDetails, ResourceTask__c.class);
            System.debug('Task To Create1 -> ' + taskJsonDetails);
            System.debug('Task To Create2 -> ' + taskToCreate);
            TaskServices.createTask(taskToCreate);
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }       
    }    
}
