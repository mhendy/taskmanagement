({
    fireCreateTask : function(component, event, helper) {
        var addTaskEvt = component.getEvent("addClickedEvt");
        var taskName = component.get('v.taskName');
        var taskDate = component.get('v.taskDate');
        var taskDescription = component.get('v.taskDescription');
        addTaskEvt.setParams({
            "taskName": taskName,
            "taskDueDate": taskDate,
            "taskDescription": taskDescription
        });              
        addTaskEvt.fire();
    },
    fireCancelCreateTask : function(component, event, helper) {
        var cancelAddTaskEvt = component.getEvent("cancelAddTaskEvt");                                     
        cancelAddTaskEvt.fire();
    }
})
