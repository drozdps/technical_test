@isTest
private class ParentTripsListCtrlTest {

    private static final Integer RECORD_NUMBER = 3;

    @TestSetup
    static void makeData(){
        Account account = TestUtils.getAccount();
        insert account;
        Case myCase = TestUtils.getCases(1)[0];
        myCase.AccountId = account.Id;
        insert myCase;
        List<Trip__c> trips = TestUtils.getTrips(account.Id, RECORD_NUMBER);
        insert trips;
    }

    @isTest
    static void test_FetchAccountsTrips_Positive() {
        List<Trip__c> trips = new List<Trip__c>();

        Test.startTest();
        trips = ParentTripsListCtrl.getTripsFromAccount([SELECT Id FROM Case LIMIT 1].Id);
        Test.stopTest();

        System.assertEquals(RECORD_NUMBER, trips.size(), RECORD_NUMBER + ' should be fetched from DB.');
    }

    @isTest
    static void test_FetchAccountsTrips_Negative() {
        delete [SELECT Id FROM Trip__c];
        List<Trip__c> trips = new List<Trip__c>();

        Test.startTest();
        trips = ParentTripsListCtrl.getTripsFromAccount([SELECT Id FROM Case LIMIT 1].Id);
        Test.stopTest();

        System.assertEquals(0, trips.size(), 'There are should not be related trips.');
    }
}
