public with sharing class TaskController {    
    @TestVisible    
    private static String OVER_DUE_QUERY_FILTER {
        get{
            if(OVER_DUE_QUERY_FILTER == null){
                OVER_DUE_QUERY_FILTER = ' AND Due_Date__c < TODAY AND Completed__c = false';                                  
            }
            return OVER_DUE_QUERY_FILTER;
        }
        set;
    }    
        
    private static final String SOON_DUE_QUERY_FILTER = ' AND (Due_Date__c = TODAY OR Due_Date__c = TOMORROW) AND Completed__c = false';
    private static final String COMPLETED_QUERY_FILTER = ' AND Completed__c = true';

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
    @AuraEnabled     
    public static void completeTask(String taskId) {                
        try{            
            TaskServices.completeTask(taskId);
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }        
    }    
    @AuraEnabled     
    public static void deleteTask(String taskId) {                
        try{            
            TaskServices.deleteTask(taskId);
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }        
    } 
    @AuraEnabled     
    public static List<ResourceTask__c> getOverDueTasks() {        
        List<ResourceTask__c> allTasks = new List<ResourceTask__c>();
        try{            
            allTasks = TaskServices.getFilteredTasks( OVER_DUE_QUERY_FILTER );
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return allTasks;       
    }   
    @AuraEnabled     
    public static List<ResourceTask__c> getSoonDueTasks() {        
        List<ResourceTask__c> allTasks = new List<ResourceTask__c>();
        try{            
            allTasks = TaskServices.getFilteredTasks( SOON_DUE_QUERY_FILTER );
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return allTasks;       
    }   
    @AuraEnabled     
    public static List<ResourceTask__c> getCompletedTasks() {        
        List<ResourceTask__c> allTasks = new List<ResourceTask__c>();
        try{            
            allTasks = TaskServices.getFilteredTasks( COMPLETED_QUERY_FILTER );
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return allTasks;       
    }   
}
