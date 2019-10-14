trigger EmailMessageTrigger on EmailMessage (after insert) {
    fflib_SObjectDomain.triggerHandler(EmailMessageDomain.class);
}