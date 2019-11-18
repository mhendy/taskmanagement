@isTest
private with sharing class TestTaskController {
    @isTest
    static void testTaskCreation(){
        String JSONTaskTest = '{"Name":"TestTask", "Description__c": "Test Desc", "Due_Date__c":"2019-12-27"}';
        Test.startTest();
            try{
                TaskController.addTask(JSONTaskTest);                
            } catch(Exception ex){
                System.assert(false, 'No Exceptions should be received' + ex.getMessage());
            }
        Test.stopTest();
        Date expectedDate = Date.newInstance(2019, 12, 27);
        
        List<ResourceTask__c> tasksInserted = [Select Id, Name, Description__c, Due_Date__c from ResourceTask__c];
        System.assertEquals(1, tasksInserted.size(), 'A task should have been created');
        ResourceTask__c taskInserted = tasksInserted[0];
        System.assertEquals('TestTask', taskInserted.Name,'The task should have the correct name');
        System.assertEquals('Test Desc', taskInserted.Description__c,'The task should have the correct description');
        System.assertEquals(expectedDate, taskInserted.Due_Date__c,'The task should have the correct due date');
    }

    @isTest
    static void testTaskCreation_Error(){
        String InvalidJSONTaskTest = '{"Name":"TestTask" "Description__c" "Test Desc", "Due_Date__c":"2019-12-27"}';
        String exceptionMessage;
        Test.startTest();
            try{
                TaskController.addTask(InvalidJSONTaskTest); 
                System.assert(false, 'An exception should be thrown');               
            } catch(Exception ex){
                exceptionMessage = ex.getMessage();
            }
        Test.stopTest();
        System.assertNotEquals(null, exceptionMessage, 'An exception message should be shown');          
    }

    @isTest
    static void testTaskRetrieval(){
        Date expectedDate = Date.newInstance(2019, 12, 27);
        ResourceTask__c testTask = new ResourceTask__c(Name = 'testName', Description__c = 'testDesc', Due_Date__c=expectedDate);
        insert testTask;
        List<ResourceTask__c> actualTasks = new List<ResourceTask__c>();
        Test.startTest();
            try{
                actualTasks = TaskController.getTasks();                 
            } catch(Exception ex){
                System.assert(false,'No Exception should be thrown');
            }
        Test.stopTest();
        System.assertEquals(1, actualTasks.size(), 'The correct number of tasks should be found');
        ResourceTask__c actualTask = actualTasks[0];
        System.assertEquals('testName', actualTask.Name,'The task should have the correct name');
        System.assertEquals('testDesc', actualTask.Description__c,'The task should have the correct description');
        System.assertEquals(expectedDate, actualTask.Due_Date__c,'The task should have the correct due date');         
    }
    
    @isTest
    static void testTaskRetrieval_error(){        
        Exception exceptionReceived;
        List<ResourceTask__c> actualTasks = new List<ResourceTask__c>();                
        //Use an invalid query string
        TaskServices.taskQueryBase = 'Select Ids from Accountz';
        
        Test.startTest();
            try{
                actualTasks = TaskController.getTasks();
                System.assert(false, 'An exception should be caught');
            }catch(Exception ex){
                exceptionReceived = ex;
            }
        Test.stopTest();        
        
        System.assert(exceptionReceived instanceof AuraHandledException);         
    }
}
