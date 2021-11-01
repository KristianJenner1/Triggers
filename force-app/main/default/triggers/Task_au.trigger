/*******************************************************************************************
* @Name         Task_au 
* @Description  After Update trigger on Task
*******************************************************************************************/
trigger Task_au on Task (after update) 
{
    
    // 1. if tasks have a subject of ‘Reduce Value’ and the status has been changed to ‘Completed’, update the associated opportunity to reduce the amount by 50%.
    private static Decimal reduction = 0.5; // amount to reduce related opportuities by
    
    // 1.1 fitler Tasks that have changed to Completed
    TaskService TaskService = New TaskService(trigger.oldMap,trigger.newMap);
    List<Task> newlyCompletedTasks = TaskService.getCompletedTasks();

    // 1.2 get related Opportunities for the Tasks
    List<Opportunity> oppsToReduce = TaskService.getRelatedOppsforReduceValueTasks(newlyCompletedTasks);

    // 1.3 update the Opportunity amount by the reduction (decimal)
    if (oppsToReduce.size() > 0)
    {
        OpportunityService OpportunityService = new OpportunityService(oppsToReduce);
        OpportunityService.reduceOpportunitiesValue(reduction);
        OpportunityService.updateOpportunities();
    }



}