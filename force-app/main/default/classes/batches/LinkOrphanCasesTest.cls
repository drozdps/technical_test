@isTest
private with sharing class LinkOrphanCasesTest {

    private static final Integer RECORDS_NUMBER = 5;

    @TestSetup
    static void makeData(){
        Account account = TestUtils.getAccount();
        insert account;
        List<Case> cases = TestUtils.getCases(RECORDS_NUMBER);
        insert TestUtils.getTrips(account.Id, RECORDS_NUMBER);
        List<Trip__c> trips = [SELECT Name FROM Trip__c];
        for (Integer i = 0; i < trips.size(); i++) {
            cases[i].Description = 'blablabla' + trips[i].Name + ' blabla';
        }
        insert cases;
    }

    @isTest
    static void test_LinkOrphanCasesInBatch_Positive() {

        Test.startTest();
        new LinkOrphanCasesScheduler().execute(null);
        Test.stopTest();

        for (Case serviceCase : [SELECT Trip__c, AccountId FROM Case]) {
            System.assertEquals([SELECT Id FROM Account LIMIT 1].Id, serviceCase.AccountId, 'Service Case should be properly linked to an Account.');
            System.assertNotEquals(null, serviceCase.Trip__c, 'Service Case Trip__c lookup should be populated if TripId is mentioned in the description.');
        }
    }

    @isTest
    static void test_LinkOrphanCasesInBatch_Negative() {
        List<Case> cases = [SELECT Id, Description FROM Case];
        for (Case myCase : cases) {
            myCase.Description = 'Random Description';
        }
        update cases;

        Test.startTest();
        new LinkOrphanCasesScheduler().execute(null);
        Test.stopTest();

        for (Case serviceCase : [SELECT Trip__c, AccountId FROM Case]) {
            System.assertEquals(null, serviceCase.AccountId, 'Service Case should remain being orphan.');
            System.assertEquals(null, serviceCase.Trip__c, 'Service Case Trip__c lookup should not be populated if TripId is not mentioned in the description.');
        }
    }
}

