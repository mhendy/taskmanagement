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

    @isTest
    static void testTaskCompletion(){
        Date taskDate = Date.newInstance(2019, 12, 27);
        ResourceTask__c testTask = new ResourceTask__c(Name = 'testName', 
                                                       Description__c = 'testDesc', 
                                                       Due_Date__c=taskDate,
                                                       Completed__c = false);
        insert testTask;
        
        Test.startTest();
            try{
                TaskController.completeTask(testTask.Id);                
            } catch(Exception ex){
                System.assert(false, 'No Exceptions should be received' + ex.getMessage());
            }
        Test.stopTest();        
        
        List<ResourceTask__c> tasksInserted = [Select Id, Completed__c from ResourceTask__c];
        System.assertEquals(1, tasksInserted.size(), 'A task should have been created');
        ResourceTask__c taskInserted = tasksInserted[0];
        System.assertEquals(true, taskInserted.Completed__c,'The task should be completed');        
    }

    @isTest
    static void testTaskCompletion_Error(){        
        String exceptionMessage;
        String fakeId = 'ABC';
        Test.startTest();
            try{
                TaskController.completeTask(fakeId); 
                System.assert(false, 'An exception should be thrown');               
            } catch(Exception ex){
                exceptionMessage = ex.getMessage();
            }
        Test.stopTest();
        System.assertNotEquals(null, exceptionMessage, 'An exception message should be shown');          
    }

    @isTest
    static void testTaskDeletion(){
        Date taskDate = Date.newInstance(2019, 12, 27);
        ResourceTask__c testTask = new ResourceTask__c(Name = 'testName', 
                                                       Description__c = 'testDesc', 
                                                       Due_Date__c=taskDate,
                                                       Completed__c = false);
        insert testTask;        
        
        Test.startTest();
            try{
                TaskController.deleteTask(testTask.Id);                
            } catch(Exception ex){
                System.assert(false, 'No Exceptions should be received' + ex.getMessage());
            }
        Test.stopTest();        
        
        List<ResourceTask__c> tasksInserted = [Select Id, Completed__c from ResourceTask__c];
        System.assertEquals(0, tasksInserted.size(), 'No tasks should exist');                
    }

    @isTest
    static void testTaskDeletion_Error(){        
        String exceptionMessage;
        String fakeId = 'ABC';
        Test.startTest();
            try{
                TaskController.deleteTask(fakeId); 
                System.assert(false, 'An exception should be thrown');               
            } catch(Exception ex){
                exceptionMessage = ex.getMessage();
            }
        Test.stopTest();
        System.assertNotEquals(null, exceptionMessage, 'An exception message should be shown');          
    }

    @isTest
    static void testTaskOverDueRetrieval_error(){        
        Exception exceptionReceived;
        List<ResourceTask__c> actualTasks = new List<ResourceTask__c>();                
        //Use an invalid query string
        TaskController.OVER_DUE_QUERY_FILTER = 'and where things are not goodz in this query';
        
        Test.startTest();
            try{
                actualTasks = TaskController.getOverDueTasks();
                System.assert(false, 'An exception should be caught');
            }catch(Exception ex){
                exceptionReceived = ex;
            }
        Test.stopTest();        
        
        System.assert(exceptionReceived instanceof AuraHandledException);         
    }

    @isTest
    static void testTaskFilteredRetrieval(){
        Date pastDueDate = Date.Today().addDays(-1);
        Date soonDueDate = pastDueDate.addDays(2);
        Date futureDate = pastDueDate.addYears(2);
        
        ResourceTask__c testPastDueTask = new ResourceTask__c(Name = 'testName', Description__c = 'testDesc', Due_Date__c=pastDueDate);
        ResourceTask__c testSoonDueTask = new ResourceTask__c(Name = 'testName', Description__c = 'testDesc', Due_Date__c=soonDueDate);
        ResourceTask__c testCompletedTask = new ResourceTask__c(Name = 'testName', 
                                                                Description__c = 'testDesc', 
                                                                Due_Date__c=futureDate,
                                                                Completed__c = true);
        
        insert new List<ResourceTask__c>{testPastDueTask, testSoonDueTask, testCompletedTask};

        List<ResourceTask__c> actualPastDueTasks = new List<ResourceTask__c>();
        List<ResourceTask__c> actualSoonDueTasks = new List<ResourceTask__c>();
        List<ResourceTask__c> actualCompletedTasks = new List<ResourceTask__c>();
        Test.startTest();
            try{
                actualPastDueTasks = TaskController.getOverDueTasks();                 
                actualSoonDueTasks = TaskController.getSoonDueTasks();                 
                actualCompletedTasks = TaskController.getCompletedTasks();                 
            } catch(Exception ex){
                System.assert(false,'No Exception should be thrown');
            }
        Test.stopTest();
        System.assertEquals(1, actualPastDueTasks.size(), 'The correct number of tasks should be found');
        System.assertEquals(1, actualSoonDueTasks.size(), 'The correct number of tasks should be found');
        System.assertEquals(1, actualCompletedTasks.size(), 'The correct number of tasks should be found');
        
        ResourceTask__c actualPastDueTask = actualPastDueTasks[0];
        ResourceTask__c actualSoonDueTask = actualSoonDueTasks[0];
        ResourceTask__c actualCompletedTask = actualCompletedTasks[0];

        System.assertEquals(testPastDueTask.Id, actualPastDueTask.Id,'The correct task should be found');
        System.assertEquals(testSoonDueTask.Id, actualSoonDueTask.Id,'The correct task should be found');
        System.assertEquals(testCompletedTask.Id, actualCompletedTask.Id,'The correct task should be found');             
    }
}
