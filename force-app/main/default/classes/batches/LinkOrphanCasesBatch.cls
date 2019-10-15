/*
 * Apex batch class which links orphan service Cases to appropriate Trips and Accounts
 *
 * @author Paul Drozd
 */
global with sharing class LinkOrphanCasesBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, Description FROM Case WHERE Status != :Label.CaseStatus_Closed AND Origin = :Label.CaseOrigin_Email]);
    }

    global void execute(Database.BatchableContext BC, List<Case> scope) {
        Map<String, Case> tripIdToCase = this.groupCasesByTripId(scope);
        Map<String, Trip__c> tripIdToTrip = new TripSelector().getGrouppedByTripIds(new List<String>(tripIdToCase.keySet()));
        List<Case> casesToUpdate = new List<Case>();
        for  (String tripId : tripIdToCase.keySet()) {
            Case serviceCase = tripIdToCase.get(tripId);
            Trip__c trip = tripIdToTrip.get(tripId);
            if (trip != null) {
                serviceCase.Trip__c = trip.Id;
                serviceCase.AccountId = trip.Account__c;
                casesToUpdate.add(serviceCase);
            }
        }
        if (!casesToUpdate.isEmpty()) {
            try {
                update casesToUpdate;
            } catch (DmlException exc) {
                // TO DO: aggregate errors and send the Batch report in finish() method
                System.debug(LoggingLevel.ERROR, 'Unable to perform DML in LinkOrphanCasesBatch: ' + exc.getMessage() + ',' + exc.getStackTraceString());
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        // TO DO: send email report with batch results (success and error entries)
    }

    private Map<String, Case> groupCasesByTripId(List<Case> scope) {
        Map<String, Case> tripIdToCase = new Map<String, Case>();
        for (Case serviceCase : scope) {
            Matcher emailMatcher = EmailMessageService.TRIP_ID_PATTERN.matcher(serviceCase.Description);
            if (emailMatcher.find()) {
                tripIdToCase.put(emailMatcher.group(), serviceCase);
            }
        }
        return tripIdToCase;
    }
}
