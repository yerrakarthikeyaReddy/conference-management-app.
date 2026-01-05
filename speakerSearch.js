import { LightningElement} from 'lwc';

export default class SpeakerSearch extends LightningElement {
    
    selectespeaker='';
    selectespeciality='';
    
    
    handleInput(Event){
        this.selectespeaker=Event.target.value ;
        console.debug('input search'+this.selectespeaker);
    }
     
    specialityOptions = [
        { label: 'Apex', value: 'Apex' },
        { label: 'LWC', value: 'LWC' },
        { label: 'Integrations', value: 'Integrations' },
        { label: 'Architecture', value: 'Architecture' }
    ];

    handlechange(Event){
      this.selectespeciality=Event.detail.value ;
      console.debug('pick value'+this.selectespeciality);
    }

    searchspeaker='';
    selected='';
    handleSearch(){
    this.searchspeaker=this.selectespeaker;
    this.selected=this.selectespeciality;
    console.debug('speaker'+this.searchspeaker);
    }
}