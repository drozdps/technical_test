/**
 * Domain class for EmailMessage object
 * @author Paul Drozd
*/

public with sharing class EmailMessageDomain extends fflib_SObjectDomain {

    public EmailMessageDomain(List<SObject> sObjectList) {
        super(sObjectList);
    }

    /*
     * Important note.
     * Although email content is accessible via Case Description field, we won't utilize Case Trigger, because:
     *
     * 1. Scalability. Building features on top of Email-to-Case functionality with Case Trigger is a bad practice, 
     *    because not all fields from EmailMessage are available on Cases (EmailMessage is a source of truth).
     * 2. Case Description length is limited to 32K symbols, so its value can be truncated.
     * 3. Some addons for Service Cloud can perform long-running operations on Description field.
     * 4. In some cases Case Description can be empty in Case Triigger.
     */
    public override void onAfterInsert(){
        // share the single UOW to reduce the amount of issued DMLs
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<Schema.SObjectType>{Case.SObjectType});

        EmailMessageService service = new EmailMessageService(this.records);
        uow.registerDirty(service.getReparentedCases());
        
        uow.commitWork();
    }


    //auxiliar class
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new EmailMessageDomain(sObjectList);
        }
    }
}