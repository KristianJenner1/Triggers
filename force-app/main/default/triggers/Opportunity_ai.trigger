/*******************************************************************************************
* @Name         Opportunity_ai 
* @Description  After Insert trigger on Opportnity
*******************************************************************************************/
trigger Opportunity_ai on Opportunity (after insert) 
{
    
    // 1. create Tasks for Opportunities
    TaskService TaskService = new TaskService();
    
    // 1.1 create 'follow up' tasks for all opportunities
    TaskService.createFollowUpTasksForSobjects(trigger.new, 10);

    // 1.2 create 'reduce value' tasks for opportunities where amount > 500000
    List<Opportunity> opportunitiesToReduce = new List<Opportunity>();
    for (Opportunity opp : trigger.new)
    {
        if (opp.amount > 500000)
        {
            opportunitiesToReduce.add(opp);
        }
    }
    if (opportunitiesToReduce.size() > 0)
    {
        TaskService.createReduceValueTasksForSobjects(opportunitiesToReduce, 2);
    }

}