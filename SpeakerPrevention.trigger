trigger SpeakerPrevention on Speaker_Assignment__c (before insert, before update) {
    Set<Id> sessionId = New Set<Id>();
    Set<Id> speakerId = New Set<Id>();
    if(Trigger.isBefore && Trigger.isInsert){
        for(Speaker_Assignment__c speakerAssign:Trigger.new){
            if(speakerAssign.Speaker__c!=Null ){
                sessionId.add(speakerAssign.Session__c);
                speakerId.add(speakerAssign.Speaker__c);
            }
        }
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Speaker_Assignment__c speakerAssign:Trigger.new){
            if(speakerAssign.Speaker__c!=Null && speakerAssign.Speaker__c!= Trigger.oldMap.get(speakerAssign.Id).Speaker__c ){
                speakerId.add(speakerAssign.Speaker__c);
                sessionId.add(speakerAssign.Session__c);
                sessionId.add(Trigger.oldMap.get(speakerAssign.Id).Session__c);
            }
        }
    }
    Map<Id, Session__c> sessionMap = new Map<Id, Session__c>([SELECT Id,Session_Date__c,Start_Time__c,End_Time__c FROM Session__c WHERE Id IN:sessionId]);
    
     List<Speaker_Assignment__c> existingAssignmentList = [SELECT Id,Speaker__c, Session__c, Session__r.Session_Date__c,  Session__r.Start_Time__c, Session__r.End_Time__c 
                                                           FROM Speaker_Assignment__c WHERE Speaker__c IN :speakerId];
    
    
        for(Speaker_Assignment__c speakerAssign:Trigger.new){
        Session__c newSession = sessionMap.get(speakerAssign.Session__c);
            if (newSession != null) { 
       for(Speaker_Assignment__c existingAssignment:existingAssignmentList){                 
               if (existingAssignment.Session__r.Session_Date__c == newSession.Session_Date__c && existingAssignment.Speaker__c == speakerAssign.Speaker__c) {
                    if ((newSession.Start_Time__c < existingAssignment.Session__r.End_Time__c) &&
                        (newSession.End_Time__c > existingAssignment.Session__r.Start_Time__c)) {
                        speakerAssign.addError('The speaker is already booked for this time slot.');
                    }
                }
          }
        }
    }
}