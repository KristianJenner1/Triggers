/*******************************************************************************************
* @Name         OpportunityService 
* @Description  Service Class for Opportunity Object, called from multiple contexts
*******************************************************************************************/
public with sharing class OpportunityService 
{
    // member variables
    public List<Opportunity> opportunities;
    public List<Opportunity> opportunitiesToUpdate;
 
    // no argument constructor
    public OpportunityService() 
    {
        this.opportunities = new List<Opportunity>();
        this.opportunitiesToUpdate = new List<Opportunity>();
    }

    public OpportunityService(List<Opportunity> opportunities) 
    {
        this.opportunities = opportunities;
        this.opportunitiesToUpdate = new List<Opportunity>();
    }

    // NOT SURE IF THIS WOULD BE BETTER AS A STATIC METHOD?>

    /**************************************************************************************
    * @Description  method to update opportunity amount by supplied fraction (reduction)
    * @Return       void
    **************************************************************************************/
    public void reduceOpportunitiesValue(Decimal reduction)
    {
        if (this.opportunities != null)
        {
            for (Opportunity oppty : opportunities)
            {
                oppty.amount *= reduction;
                this.opportunitiesToUpdate.add(oppty);
            } 
        }
    }

    /**************************************************************************************
    * @Description  method to update the opportunities
    * @Return       void
    **************************************************************************************/ 
    public void updateOpportunities()
    {
        if (opportunitiesToUpdate.size() > 0)
        {
            update opportunitiesToUpdate;
        }
    }
}
