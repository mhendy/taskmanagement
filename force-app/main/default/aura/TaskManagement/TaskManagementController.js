({
    init : function(component, event, helper) {
        var actions = helper.getRowActions.bind(this, component);        
        component.set('v.columns', [
            {label: 'Task Status Indicator', 
                cellAttributes: { 
                    iconName: {fieldName: 'displayIconName'},
                    iconPosition: 'left' }
            },
            {label: 'Task Name', fieldName: 'Name', type: 'text'},
            {label: 'Task Description', fieldName: 'Description__c', type: 'text'},
            {label: 'Due Date', fieldName: 'Due_Date__c', type: 'date-local'},
            {label: 'Completed', fieldName: 'Completed__c', type: 'boolean'},
            {label:'Actions', type: 'action', typeAttributes: { rowActions: actions }, fixedWidth: 100 }            
        ]);            
        helper.getTasks(component);
    },
    showCreateTask : function(component, event, helper) {        
        component.set('v.createMode', true);
        component.set('v.selectedTaskIdToView', null);
    },
    handleCreateTaskClickEvent : function(component, event, helper) {
        var taskName = event.getParam('taskName');         
        var taskDueDate = event.getParam('taskDueDate');         
        var taskDescription = event.getParam('taskDescription');
        var taskToCreate = {'Name':taskName, 'Due_Date__c':taskDueDate, 'Description__c':taskDescription};                
        helper.createTask(component, event, taskToCreate);
    },
    handleCancelTaskClickEvent : function(component, event, helper) {        
        component.set('v.createMode', false);
    },
    applyFilter : function(component, event, helper) {
        component.set('v.selectedTaskIdToView', null);        
        helper.applyFilter(component);
    },
    handleRowAction: function (component, event, helper) {        
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'show_details':                
                component.set('v.selectedTaskIdToView', row.Id);
                break;
            case 'delete':                
                helper.deleteTask(component, row.Id);                
                break;
            case 'complete':
                helper.completeTask(component, row.Id);                
                break;
        }
    }
})
