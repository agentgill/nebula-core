/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 2019-03-01
 */

global interface AfterUpdate {

    void handleAfterUpdate(List<SObject> oldList, List<SObject> newList);
}