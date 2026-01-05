import { LightningElement,api,wire } from 'lwc';
import SpeakerValueMethod from '@salesforce/apex/SpeakerController.SpeakerValueMethod';
import { MessageContext,publish } from 'lightning/messageService';
import speakerchannel from '@salesforce/messageChannel/speakerchannel__c';
export default class SpeakerList extends LightningElement {
 @api speakervalue;
 @api specialityvalue;
 speakerData;
 error
 @wire(MessageContext) messageContext;
   
 columns=[
    {label: 'Name', fieldName: 'Name'},
    {label: 'Email', fieldName: 'Email__c'},
    {label: 'Speciality', fieldName: 'Speciality__c'},
    {label: 'Actions', type:'button' ,typeAttributes:{
        label:'Book Session',
        value:'Book Session'
}}
 ]
 
@wire(SpeakerValueMethod,{speakerName:'$speakervalue',speakerSpeciality:'$specialityvalue'}) 
speakerRecords({ data, error }) {
    console.log('Speaker Name:', this.speakervalue);
    console.log('Speciality:', this.specialityvalue);
    if (data) {
        this.speakerData = data;
        console.log('FIRST ROW:', JSON.stringify(data[0]));
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.speakerData = undefined;
        console.error(error);
    }
}
handleRowAction(event){
    const speakerId=event.detail.row.Id;
    console.log('id Value:', speakerId);
    publish(this.messageContext, speakerchannel,{
        speakerId:speakerId
    });
}
}