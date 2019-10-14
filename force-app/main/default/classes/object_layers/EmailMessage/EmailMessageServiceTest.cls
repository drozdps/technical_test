@isTest
private with sharing class EmailMessageServiceTest {

    private static final Integer RECORDS_NUMBER = 5;

    @TestSetup
    static void makeData(){
        Account account = TestUtils.getAccount();
        insert account;
        insert TestUtils.getCases(RECORDS_NUMBER);
        insert TestUtils.getTrips(account.Id, RECORDS_NUMBER);
        
    }

    @isTest
    static void test_LinkOrphanCaseToTripAndAccount_Positive() {
        List<EmailMessage> emails = generateEmailMessages();

        Test.startTest();
        insert emails;
        Test.stopTest();

        Account account = [SELECT Id FROM Account LIMIT 1];
        for (Case serviceCase : [SELECT Id, AccountId, Trip__c FROM Case]) {
            System.assertEquals(account.Id, serviceCase.AccountId, 'Service Case should be properly linked to an Account.');
            System.assertNotEquals(null, serviceCase.Trip__c, 'Service Case Trip__c lookup should be populated if TripId is mentioned in the email.');
        }
    }

    @isTest
    static void test_LinkOrphanCaseToTripAndAccount_Negative() {
        List<EmailMessage> emails = generateEmailMessages();
        for (EmailMessage email : emails) {
            email.TextBody = 'Text Body without TripId';
        }

        Test.startTest();
        insert emails;
        Test.stopTest();

        Account account = [SELECT Id FROM Account LIMIT 1];
        for (Case serviceCase : [SELECT Id, AccountId, Trip__c FROM Case]) {
            System.assertEquals(null, serviceCase.AccountId, 'Service Case should not be reparented if the origin email doesnt contain TripId');
            System.assertEquals(null, serviceCase.Trip__c, 'Service Case should not be reparented if the origin email doesnt contain TripId');
        }
    }

    private static List<EmailMessage> generateEmailMessages() {
        List<Trip__c> trips = [SELECT Id, Name FROM Trip__c];
        List<Case> cases = [SELECT Id FROM Case];
        List<EmailMessage> emails = new List<EmailMessage>();
        for (Integer i = 0; i < trips.size(); i++) {
            EmailMessage email = TestUtils.getEmailMessage(i);
            email.TextBody = 'blablabla ' + trips[i].Name + ' blablabla';
            email.ParentId = cases[i].Id;
            emails.add(email);
            system.debug(LoggingLevel.error, 'Email:' + email);
        }
        return emails;
    }


}
