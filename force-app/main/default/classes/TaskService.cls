/*******************************************************************************************
* @Name         TaskService 
* @Description  Service Class for Task Object, called from multiple contexts
*******************************************************************************************/
public with sharing class TaskService 
{
    // constants
    public static final String TASK_SUBJECT_FOLLOW_UP = 'Follow Up';
    public static final String TASK_SUBJECT_REDUCE_VALUE = 'Reduce Value';
    public static final String TASK_STATUS_NEW = 'New';
    public static final String TASK_STATUS_COMPLETED = 'Completed';

    // member variables
    public Id taskOwner;
    public List<Task> tasksToInsert;
    public Map<Id,Task> oldTasksMap;
    public Map<Id,Task> newTasksMap;

    // no argument constructor
    public TaskService() 
    {
        this.taskOwner = UserInfo.getUserId();
        this.tasksToInsert = new List<Task>();
    }

    public TaskService(Map<Id,Task> oldTasksMap, Map<Id,Task> newTasksMap) 
    {
        this.oldTasksMap = oldTasksMap;
        this.newTasksMap = newTasksMap;
    }

    /**************************************************************************************
    * @Description  method to create 'follow up' tasks for the supplied SObject List with a
    *               due date set to today + the supplied number of days
    * @Return       void
    **************************************************************************************/ 
    public void createFollowUpTasksForSobjects(List<Sobject> objects, Integer daysToDueDate)
    {
        date dueDate = Date.Today() + daysToDueDate;
        createTasksForSObjects(objects, TASK_SUBJECT_FOLLOW_UP, dueDate);
    }
    
    /**************************************************************************************
    * @Description  method to create 'reduce value' tasks for the supplied SObject List 
    *               with a due date set to today + the supplied number of days
    * @Return       void
    **************************************************************************************/ 
    public void createReduceValueTasksForSobjects(List<Sobject> objects, Integer daysToDueDate)
    {
        date dueDate = Date.Today() + daysToDueDate;
        createTasksForSObjects(objects, TASK_SUBJECT_REDUCE_VALUE, dueDate);
    }

    /**************************************************************************************
    * @Description  private method to create a task linked to supplied SObject List
    * @Return       void
    **************************************************************************************/ 
    private void createTasksForSObjects(List<Sobject> objects, String taskSubject, Date dueDate)
    {   
        for (SObject obj : objects)
        {
            Task task = new Task();
            task.whatId = obj.Id;
            task.subject = taskSubject;
            task.ActivityDate = dueDate;
            task.OwnerId = taskOwner;
            this.tasksToInsert.add(task);
        }
    }

    /**************************************************************************************
    * @Description  method to return tasks with a Completed status, comparing old and new
    * @Return       List<Task>
    **************************************************************************************/ 
    public List<Task> getCompletedTasks()
    {
        List<Task> completedTasks = new List<Task>();
        // compare task status in new/old to check for newly completed tasks
        for (Task task : newTasksMap.values()) 
        {
            if (task.status == TASK_STATUS_COMPLETED && oldTasksMap.get(task.Id).status != TASK_STATUS_COMPLETED) 
            {
                completedTasks.add(task);
            }
       }
       return completedTasks;
    }

    /**************************************************************************************
    * @Description  method to get Opportunities related to tasks to reduce in value
    * @Return       List<Opportunity>
    **************************************************************************************/ 
    public List<Opportunity> getRelatedOppsforReduceValueTasks(List<Task> reduceValueTasks)
    {   
        List<Opportunity> opportunities = new List<Opportunity>();
        List<ID> opptyIDs = new List<ID>();

        for (Task task : reduceValueTasks)
        {
            if (task.subject == TASK_SUBJECT_REDUCE_VALUE && task.status == TASK_STATUS_COMPLETED && task.WhatId.getSObjectType() == Opportunity.sObjectType)
            {
                opptyIDs.add(task.WhatId);
            }
        }

        if (opptyIDs.size() > 0)
        {
            opportunities = [
                                SELECT Id, amount 
                                FROM Opportunity
                                WHERE Id IN: opptyIDs 
                            ];
        } 
        
        return opportunities;
    }

    /**************************************************************************************
    * @Description  method insert the tasks
    * @Return       void
    **************************************************************************************/ 
    public void insertTasks()
    {
        if (tasksToInsert.size() > 0)
        {
            insert tasksToInsert;
        }
    }


}
