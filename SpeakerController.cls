public with sharing class SpeakerController {
    @AuraEnabled(cacheable=true)
    public static List<Speaker__c>  SpeakerValueMethod(string speakerName,string  speakerSpeciality) {

        Boolean havingName = !String.isBlank(speakerName);
        Boolean havingSpeciality = !String.isBlank(speakerSpeciality);

        if (havingName) {
            speakerName = '%' + speakerName + '%';
        }
        if (havingSpeciality) {
            speakerSpeciality = '%' + speakerSpeciality + '%';
        }

        if( !havingSpeciality && havingName){
       return [SELECT Id,Name,Speciality__c,Email__c FROM Speaker__c WHERE name like :speakerName];
       }
        if(!havingName && havingSpeciality ){
        return [SELECT Id,Name,Speciality__c,Email__c FROM Speaker__c WHERE Speciality__c like :speakerSpeciality];
        }   
          
       return [SELECT Id,Name,Speciality__c,Email__c FROM Speaker__c WHERE Name like :speakerName OR Speciality__c like :speakerSpeciality];
     
   }

   @AuraEnabled(cacheable=true)
   public static List<Speaker__c> SpeakerDetailsByIds(Id  speakeridd){
    return [ SELECT Id, Name, Speciality__c, Bio__c FROM Speaker__c WHERE Id = :speakeridd LIMIT 1];
   } 

   @AuraEnabled
   public static Boolean SpeakerAvailability(Id speakerId, String selectedDate) {
    Date sessionDate = Date.valueOf(selectedDate);
    List<Speaker_Assignment__c> assignments = [
        SELECT Id,Speaker__c,Session__c,Session__r.Session_Date__c
        FROM Speaker_Assignment__c
        WHERE Speaker__c = :speakerId
        AND Session__r.Session_Date__c = :sessionDate
        LIMIT 1
    ];
    return assignments.isEmpty();
}

@AuraEnabled
public static void creatingSpeakerAssignment(Id speakerId, String selectedDate) {
    Date sessionDate = Date.valueOf(selectedDate);
     
    
    Session__c session;

    List<Session__c> sessions = [SELECT Id,Session_Date__c FROM Session__c WHERE Session_Date__c= :sessionDate LIMIT 1];

    if (sessions.isEmpty()) {
        
        session = new Session__c();
        session.Name = 'Session - ' + sessionDate;
        session.Session_Date__c = sessionDate;
        
        insert session;
    } else {
        session = sessions[0];
    }
    Speaker__c speakerList = [SELECT Id, Name FROM Speaker__c WHERE Id = :speakerId LIMIT 1];

    Speaker_Assignment__c assignment = new Speaker_Assignment__c();
    assignment.Name       = speakerList.Name+ ' - ' + String.valueOf(session.Session_Date__c);
    assignment.Speaker__c = speakerId;
    assignment.Session__c = session.Id;
    
    insert assignment;
}
}