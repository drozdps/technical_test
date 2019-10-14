/*
 * Selector for Cases. Extends fflib's base Selector
 *
 * @author Paul Drozd
 */
public inherited sharing class CaseSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Case.Id,
            Case.AccountId,
            Case.Trip__c
        };
    }

    public CaseSelector() {
        super(false, false, false);
    }

    public Schema.SObjectType getSObjectType() {
        return Case.sObjectType;
    }

    public List<Case> selectById(Set<Id> ids) {
        return (List<Case>) selectSObjectsById(ids);
    }
}
