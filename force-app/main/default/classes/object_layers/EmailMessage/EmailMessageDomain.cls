/**
 * Domain class for EmailMessage object
 * @author Paul Drozd
*/

public with sharing class EmailMessageDomain extends fflib_SObjectDomain {

    public EmailMessageDomain(List<SObject> sObjectList) {
        super(sObjectList);
    }

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