/*
 * Selector for Trip. Extends fflib's base Selector
 *
 * @author Paul Drozd
 */
public inherited sharing class TripSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Trip__c.Id,
            Trip__c.Account__c,
            Trip__c.Name
        };
    }

    public TripSelector() {
        super(false, false, false);
    }

    public Schema.SObjectType getSObjectType() {
        return Trip__c.sObjectType;
    }

    public Map<String, Trip__c> getGrouppedByTripIds(List<String> tripIds) {
        Map<String, Trip__c> tripIdToTrip = new Map<String, Trip__c>();
        for (Trip__c trip : this.selectByTripId(tripIds)) {
            tripIdToTrip.put(trip.Name, trip);
        }
        return tripIdToTrip;
    }
    
    private List<Trip__c> selectByTripId(List<String> tripIds) {
        fflib_QueryFactory query = this.newQueryFactory(false,false,true);
        return (List<Trip__c>) Database.query(query.setCondition('Name IN :tripIds').toSOQL());
    }
}
