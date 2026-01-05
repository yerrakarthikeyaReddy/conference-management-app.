import { LightningElement,wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import speakerchannel from '@salesforce/messageChannel/speakerchannel__c';
import SpeakerDetailsByIds from '@salesforce/apex/SpeakerController.SpeakerDetailsByIds';
import SpeakerAvailability from '@salesforce/apex/SpeakerController.SpeakerAvailability';
import creatingSpeakerAssignment from '@salesforce/apex/SpeakerController.creatingSpeakerAssignment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BookSession extends LightningElement {
 
 speakerIdss;   
speakerRecord;
selectDate;
isCreateDisabled  = false;


    @wire(MessageContext) messageContext;

    connectedCallback() {
    subscribe(this.messageContext,speakerchannel, (parameter) => {
        this.speakerIdss=parameter.speakerId;
        console.debug('Id -->',this.speakerIdss);
    });
}
@wire(SpeakerDetailsByIds, { speakeridd: '$speakerIdss' })
    wiredSpeaker({ data }) {
        if (data) {
            this.speakerRecord = data[0];
            console.log('FIRST ROW:', JSON.stringify(data[0]));

        }
    }
    today = new Date().toISOString().split('T')[0];
    handleDateChange(event) {
        this.selectedDate = event.target.value;
        this.isCreateDisabled = false;

        SpeakerAvailability({
            speakerId: this.speakerIdss,
            selectedDate: this.selectedDate
        })
        .then((isAvailable) => {
            if (isAvailable) {
                this.isCreateDisabled = true;
                console.debug('-->',isAvailable);
            } else {
                this.isCreateDisabled  = false;
                this.showToast(
                    'error',
                    'Speaker already booked on this date'
                    
                );
            }
        })
        .catch(() => {
            this.showToast(
                 'error',
                'Error checking speaker availability'
                
            );
        });
    }

    handleCreateAssignment() {
        creatingSpeakerAssignment({
            speakerId: this.speakerIdss,
            selectedDate: this.selectedDate
        })
        .then(() => {
            this.showToast('Success', 'Speaker assignment created successfully');
        })
        .catch((error) => {
            this.showToast(error.body?.message);
        });
    }

    showToast(title, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message
            })
        );
    }
}