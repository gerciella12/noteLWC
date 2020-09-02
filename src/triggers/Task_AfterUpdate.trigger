trigger Task_AfterUpdate on Task (after update) {

        TriggerUtil_Task_Post taskFunctions = new TriggerUtil_Task_Post();
        taskFunctions.stampActivityText(Trigger.old, Trigger.new);


}