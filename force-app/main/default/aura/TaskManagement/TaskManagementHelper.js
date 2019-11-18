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
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
                this.handleErrors(errors);
            }
        });
        $A.enqueueAction(action);
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
