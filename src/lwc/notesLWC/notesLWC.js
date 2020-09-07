import {LightningElement, track, wire, api} from 'lwc';
import getNotes from '@salesforce/apex/notesLWC_Helper.retrieveNotes';
import saveResultToDB from '@salesforce/apex/notesLWC_Helper.saveInput';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import OPPORTUNITYID_FIELD from '@salesforce/schema/Opportunity.Id';
import {getRecord} from 'lightning/uiRecordApi';

import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import USER_OBJECT from '@salesforce/schema/User';
//import EMAIL_FIELD from '@salesforce/schema/User.';

export default class notesLWC extends LightningElement {
    @track columns = [
        {
            label: 'Created Date',
            fieldName: 'CreatedDate',
            type: 'datetime',
            sortable: true
        }
        , {
            label: 'User',
            fieldName: 'CreatedById',
            type: 'User',
            sortable: true
        },{
            label: 'Notes',
            fieldName: 'Notes__c',
            type: 'text',
            sortable: true
        }, {
            label: 'Sent To',
            fieldName: 'Selected_Users__c',
            type: 'text ',
            sortable: true
        }
    ];
    @track rows = [];
   // @track isModalOpen = false;
    //@track note = '';
    @track error;
   // @track columns = columns;
    @api recordId;
   // scoreRecordUrl = 'https://gereverse--flcdev.lightning.force.com/lightning/o/Opportunity/list?filterName=Recent';
    //  @track _selected = [];
    @wire(getNotes,{opportunityId: '$recordId'})
    wiredGetNotes({
                      error,
                      data
                  }) {
        if (data) {
            this.rows = data;
        } else if (error) {
            this.error = error;
        }
    }
    /*
    @wire(getNotes, {opportunityId: '$recordId'})
    getNotesCallback ({error, data}) {
        /console.log('message for Callback');
        if (data) {
            Array.from(data, row => {
                let rowData = {};
                rowData.CreatedDate = row.CreatedDate;
                rowData.CreatedById = row.Name;
                rowData.Notes__c = row.Notes__c;
                rowData.Selected_Users__c = row.Selected_Users__c;
                currentData.push(rowData);
                console.log(data);
            });
            this.data = currentData;
            console.log('CURRENT TABLE');
            console.log(currentData);
        } else if (error) {
            this.error = error;
            console.log('ERRROR');
        }
    }
*/

    //modal here
    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    submitDetails() {
        this.isModalOpen = true;
    }
    saveNote(event) {
        saveResultToDB({params : {'note' : this.note}})
            .then((resultNote)=> {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Score successfully saved',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.scoreRecordUrl = '/' + resultNote.noteId
                window.setTimeout(
                    () => {
                        window.open(this.scoreRecordUrl, '_blank');
                    },
                    1500
                )
            })
            .catch((error) => {
                this.message = 'Error received: code' + error.errorCode + ', ' +
                    'message ' + error.body.message;
            });
    }

    handleChanges(event){
        if (event.target.name === 'note'){
            this.note = event.target.value;
        }
    }
    //dual picklist
   @track _selected = [];
        @wire(getObjectInfo, { objectApiName: USER_OBJECT})
            objectInfo;
        @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: email})
            emailValue;
            get selected() {
            return this.selected.length ? this.selected : 'none';
        }
            handleChanges1(event) {
            this.selected = event.detail.value;
        }

}


