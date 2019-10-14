public with sharing class EmailMessageService {
    private List<EmailMessage> emails;
    private Map<Id, Case> parentCases;
    private Map<Id, String> emailIdToTripId;
    private Map<String, Trip__c> tripIdToTrip;

    // regular expression: Exactly 1 "T" + Exactly 1 "#" and Several digits, for example T#123456
    private static final Pattern TRIP_ID_PATTERN = Pattern.compile('T{1}#\\d+');

    public EmailMessageService(List<EmailMessage> emails) {
        this.emails = emails;
        this.fetchRelatedRecords();
    }

    public List<Case> getReparentedCases() {
        if (this.emails == null || this.emails.isEmpty()) {
            throw new InvalidArgumentException('Emails lists must not be empty. Please, check the client code.');
        }
        List<Case> reparentedCases = new List<Case>();
        for (EmailMessage email : this.emails) {
            reparentedCases.add(this.getReparentedCase(email));
        }
        return reparentedCases;
    }

    private Case getReparentedCase(EmailMessage email) {
        Case parentCase = this.parentCases.get(email.ParentId);
        String tripId = this.emailIdToTripId.get(email.Id);
        if (String.isNotBlank(tripId)) {
            Trip__c trip = this.tripIdToTrip.get(tripId);
            if (trip != null) {
                parentCase.Trip__c = trip.Id;
                parentCase.AccountId = trip.Account__c;
            }
        }
        return parentCase;
    }

    /*
     * Finds text with TripId, like T#1234
     */
    private Map<Id, String> getEmailIdToTripIdMap() {
        Map<Id, String> emailIdToTripId = new Map<Id, String>();
        for (EmailMessage email : this.emails) {
            Matcher emailMatcher = TRIP_ID_PATTERN.matcher(email.TextBody);
            if (emailMatcher.find()) {
                emailIdToTripId.put(email.Id, emailMatcher.group());
            }
        }
        return emailIdToTripId;
    }

    private void fetchRelatedRecords() {
        this.parentCases = this.getParentCases();
        this.emailIdToTripId = this.getEmailIdToTripIdMap();
        this.tripIdToTrip = new TripSelector().getGrouppedByTripIds(emailIdToTripId.values());
    }

    private Map<Id,Case> getParentCases() {
        Set<Id> caseIds = Utils.getParentIds(this.emails, EmailMessage.ParentId.getDescribe().getSObjectField());
        return new Map<Id, Case>(new CaseSelector().selectById(caseIds));
    }
    

    
}
