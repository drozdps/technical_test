/*
 * Apex controller for parentTripsList LWC.
 * Note: this is redundant, becase Enhanced lists support the same functionality
 *
 * @author Paul Drozd
 */
public with sharing class ParentTripsListCtrl {

    @AuraEnabled(cacheable = true)
    public static List<Trip__c> getTripsFromAccount(Id caseId){
        // we're preventing the use of getRecord of UI API
        return [SELECT Id, (SELECT Id, Name, StartDate__c, Description__c FROM Trips__r) FROM Account WHERE ID IN (SELECT AccountId FROM Case WHERE Id = :caseId) LIMIT 1].Trips__r;
    }

}

