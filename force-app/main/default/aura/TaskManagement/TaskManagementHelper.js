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
                component.set('v.taskList', tasks);
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
