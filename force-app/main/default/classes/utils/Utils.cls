/*
 * Static class that aggregates useful generic util methods.
 *
 * @author Paul Drozd
 */
public with sharing class Utils {

    public static Set<Id> getParentIds(List<sObject> records, Schema.SObjectField fieldName) {
        return getParentIds(records, fieldName.getDescribe().getName());
    }

    /* 
     * Method to return set of Ids of related records
     * @param records List of sobject records
     * @param fieldName Master-detail or Lookup field API Name
     */
    public static Set<Id> getParentIds(List<sObject> records, String fieldName) {
        Set<Id> results = new Set<Id>();
        if (String.isEmpty(fieldName) || records == null || records.isEmpty()) {
            System.debug(LoggingLevel.WARN, 'Arguments must not be empty' );
            return results;
        }
        try{
            for (sObject record : records) {
                Id relatedId = (Id)record.get(fieldName);
                if (relatedId != null) {
                    results.add(relatedId);
                }
            }
        } catch(SObjectException exc) {
            System.debug(LoggingLevel.ERROR, 'Invalid relationship field name specified as a parameter for ' + exc.getStackTraceString());
            return null;
        } catch (StringException exc) {
            System.debug(LoggingLevel.ERROR, fieldName + ' refers to invalid relationship field in ' + exc.getStackTraceString());
            return null;
        }
        return results;
    }

    public static Map<Id, List<sObject>> getParentIdToChildrenMapping(List<sObject> childrenRecords, Schema.SObjectField fieldName) {
        return getParentIdToChildrenMapping(childrenRecords, fieldName.getDescribe().getName());
    }

    public static Map<Id, List<sObject>> getParentIdToChildrenMapping(List<sObject> childrenRecords, String fieldName) {
        Map<Id, List<sObject>> mappingResult = new Map<Id, List<sObject>>();
        for (sObject sObjectRecord : childrenRecords) {
            Id parentId = (Id)sObjectRecord.get(fieldName);
            if (parentId != null) {
                if(mappingResult.get(parentId) == null) {
                    mappingResult.put(parentId, new List<sObject>());
                }
                mappingResult.get(parentId).add(sObjectRecord);
            }
        }
        return mappingResult;
    }

}
