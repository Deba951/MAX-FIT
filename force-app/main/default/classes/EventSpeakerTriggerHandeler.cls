public with sharing class EventSpeakerTriggerHandeler {
    public static void handelEvent(List<EventSpeakers__c> eventSpeakerList) {

        Set<Id> speakerIdsSet = new Set<Id>();
        Set<Id> eventIdsSet = new Set<Id>();

        for( EventSpeakers__c es : eventSpeakerList ){
            speakerIdsSet.add(es.Speaker__c);
            eventIdsSet.add(es.Event__c);
        }

        Map<Id, DateTime> requestedEvents = new Map<Id, DateTime>();

        List<Event__c> relatedEventList = [Select Id, Start_DateTime__c From Event__c Where Id IN : eventIdsSet];

        for(Event__c evt : relatedEventList ){
            requestedEvents.put(evt.Id, evt.Start_DateTime__c);
        }

        List<EventSpeakers__c> relatedEventSpeakerList = [ SELECT Id, Event__c, Speaker__c, Event__r.Start_DateTime__c From EventSpeakers__c WHERE Speaker__c IN : speakerIdsSet];

        for( EventSpeakers__c es : eventSpeakerList ){ // - Salesforce Geek
            
            DateTime bookingTime = requestedEvents.get(es.Event__c); 
            // DateTime for that event which is associated with this new Event-Speaker Record
            
            for(EventSpeakers__c es1 : relatedEventSpeakerList) {
                if(es1.Speaker__c == es.Speaker__c && es1.Event__r.Start_DateTime__c == bookingTime ){
                    es.Speaker__c.addError('The speaker is already booked at that time');
                    es.addError('The speaker is already booked at that time');
                }
            }
            
        } 
    }
}