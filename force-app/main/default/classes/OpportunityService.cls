/*******************************************************************************************
* @Name         OpportunityService 
* @Description  Service Class for Opportunity Object, called from multiple contexts
*******************************************************************************************/
public with sharing class OpportunityService 
{

    // no argument constructor
    public OpportunityService() 
    {
    }

    /**************************************************************************************
    * @Description  method to update opportunity amount by supplied fraction (reduction)
    * @Return       void
    **************************************************************************************/
    public void reduceOpportunitiesValue(Decimal reduction, List<Opportunity> opportunities)
    {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        for (Opportunity oppty : opportunities)
        {
            oppty.amount *= reduction;
            opportunitiesToUpdate.add(oppty);
        } 

        if (opportunitiesToUpdate.size() > 0)
        {
            update opportunitiesToUpdate;
        }
    }
}
