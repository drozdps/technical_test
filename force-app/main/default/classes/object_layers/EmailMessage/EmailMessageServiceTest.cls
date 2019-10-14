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
        List<EmailMessage> emails = TestUtils.generateEmailMessages();

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
        List<EmailMessage> emails = TestUtils.generateEmailMessages();
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

}
