/*
 * Schedules LinkOrphanCasesBatch to link orphan service Cases to Trips and Accounts
 *
 * @author Paul Drozd
 */
global with sharing class LinkOrphanCasesScheduler implements Schedulable{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new LinkOrphanCasesBatch());
    }
}
