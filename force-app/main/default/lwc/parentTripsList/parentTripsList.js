import { LightningElement, wire, api, track } from 'lwc';
import getTripsFromAccount from '@salesforce/apex/ParentTripsListCtrl.getTripsFromAccount';

const columns = [
    { label: 'Trip Id', fieldName: 'Name' },
    { label: 'Start Date', fieldName: 'StartDate__c'},
    { label: 'Description', fieldName: 'Description__c'},
];

export default class ParentTripsList extends LightningElement {
    @api recordId;
    @track columns = columns;
    @wire(getTripsFromAccount, {caseId : '$recordId'}) trips;
}