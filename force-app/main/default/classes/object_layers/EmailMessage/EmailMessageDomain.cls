/**
 * Domain class for EmailMessage object
 * @author Paul Drozd
*/

public with sharing class EmailMessageDomain extends fflib_SObjectDomain {

    public EmailMessageDomain(List<SObject> sObjectList) {
        super(sObjectList);
    }

    public override void onAfterInsert(){
    }


    //auxiliar class
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new EmailMessageDomain(sObjectList);
        }
    }
}