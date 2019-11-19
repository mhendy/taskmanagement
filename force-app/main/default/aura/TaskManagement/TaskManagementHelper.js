({
    createTask : function(component, event, taskToCreate) {
        var action = component.get('c.addTask');
        action.setParams({
            taskJsonDetails: JSON.stringify(taskToCreate)            
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS") {                                                                                                            
            //refresh the tasks from the database
            this.getTasks(component);                                                           
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
                this.handleErrors(errors);
            }
        });
        $A.enqueueAction(action);
    },
    getTasks : function(component) {        
        var action = component.get('c.getTasks');        
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS") {                                                                                                            
                var tasks = response.getReturnValue();                
                this.displayTasks(component, tasks);                
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
                this.handleErrors(errors);
            }
        });
        $A.enqueueAction(action);
    },
    completeTask : function(component, taskToIdComplete) {
        var action = component.get('c.completeTask');
        action.setParams({
            taskId: taskToIdComplete            
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS") {                                                                                                                        
            this.getTasks(component);                                                           
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
                this.handleErrors(errors);
            }
        });
        $A.enqueueAction(action);
    },
    deleteTask : function(component, taskToIdDelete) {
        var action = component.get('c.deleteTask');
        action.setParams({
            taskId: taskToIdDelete            
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS") {                                                                                                                        
                var currentlyViewedTask = component.get('v.selectedTaskIdToView');                
                if(currentlyViewedTask && currentlyViewedTask === taskToIdDelete){
                    component.set('v.selectedTaskIdToView', null);    
                }                                                           
                this.getTasks(component);
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
                this.handleErrors(errors);
            }
        });
        $A.enqueueAction(action);
    },
    
    getRowActions: function(component, row, fillActionCb) {
        var actions = [];
        var actionView = {label: "View", name: "show_details"};
        var actionComplete = {label: "Complete", name: "complete", disabled: row.Completed__c == true};
        var actionDelete = {label: "Delete", name: "delete"};
        
        actions.push(actionView);
        actions.push(actionComplete);
        actions.push(actionDelete);
        
        fillActionCb(actions);
    },
    applyFilter : function(component) {        
        var filterValue = component.get('v.selectedFilterValue');
        var action;

        switch (filterValue) {
            case 'overdue':                
                action = component.get('c.getOverDueTasks');
                break;
            case 'soondue':                
                action = component.get('c.getSoonDueTasks');                
                break;
            case 'completed':
                action = component.get('c.getCompletedTasks');                
                break;
            default:
                action = component.get('c.getTasks');                
                break;
        }
                
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS") {                                                                                                            
                var tasks = response.getReturnValue();
                this.displayTasks(component, tasks); 
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
                this.handleErrors(errors);
            }
        });
        $A.enqueueAction(action);
    },
    displayTasks : function(component, tasksToDisplay) {                
        var today = new Date();
        var currentDate = new Date( today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var tomorrowDate = new Date( today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        tomorrowDate.setDate(tomorrowDate.getDate() + 1);        

        tasksToDisplay.forEach(function(record){             
            var recordDate =  new Date(record.Due_Date__c);            
            record.displayIconName = 'action:new_task';
            if(record.Completed__c) {
                record.displayIconName = 'action:approval';
            }else if(recordDate.getTime() == currentDate.getTime() || recordDate.getTime() == tomorrowDate.getTime()){
                record.displayIconName = 'action:priority';
            } else if(recordDate < currentDate) {
                record.displayIconName = 'action:close';                
            }                                                                      
        });
        component.set('v.taskList', tasksToDisplay);
    },
    handleErrors : function(errors) {        
        var toastParams = {
            title: "Error",
            message: "Unknown error",
            type: "error"
        };        
        if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }        
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
})
