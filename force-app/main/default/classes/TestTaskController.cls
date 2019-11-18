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
}
