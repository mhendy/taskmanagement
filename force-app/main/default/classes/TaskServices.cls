public with sharing class TaskServices {
    public static void createTask(ResourceTask__c taskToCreate){
        System.debug('Task To Create -> ' + taskToCreate);
        insert taskToCreate;
    }
}
