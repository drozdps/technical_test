/*
 * Static class containing methods for generating in-memory SObjects for Apex Unit Tests
 *
 * @author Paul Drozd
 */
 @isTest
public with sharing class TestUtils {

    public static List<Case> getCases(Integer num) {
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < num; i++) {
            cases.add(new Case(Subject = 'Test Case' + i,
                               Status = 'New',
                               Priority = 'Medium',
                               Origin = 'Email'));
        }
        return cases;
    }

    public static List<EmailMessage> getEmailMessages(Integer num) {
        List<EmailMessage> emails = new List<EmailMessage>();
        for (Integer i = 0; i < num; i++) {
            emails.add(getEmailMessage(i));
        }
        return emails;
    }

    public static EmailMessage getEmailMessage(Integer identifier) {
        return new EmailMessage(FromAddress = 'from' + identifier + '@mail.org',
                                Incoming = True,
                                ToAddress = 'customer_support_test_email@paul.com',
                                Subject = 'Help me! ' + identifier);
    }

    public static Account getAccount() {
        return new Account(Name = 'Test Account');
    }

    public static List<Trip__c> getTrips(Id accountId,  Integer num) {
        List<Trip__c> trips = new List<Trip__c>();
        for (Integer i = 0; i < num; i++) {
            trips.add(new Trip__c(Account__c = accountId));
        }
        return trips;
    }

    public static List<EmailMessage> generateEmailMessages() {
        List<Trip__c> trips = [SELECT Id, Name FROM Trip__c];
        List<Case> cases = [SELECT Id FROM Case];
        List<EmailMessage> emails = new List<EmailMessage>();
        for (Integer i = 0; i < trips.size(); i++) {
            EmailMessage email = TestUtils.getEmailMessage(i);
            email.TextBody = 'blablabla ' + trips[i].Name + ' blablabla';
            email.ParentId = cases[i].Id;
            emails.add(email);
        }
        return emails;
    }
}
