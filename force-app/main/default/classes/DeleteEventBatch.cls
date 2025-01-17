// Two Access modifier can be used global and public but private can not be used.
/*
global class DeleteEventBatch implements Database.Batchable<sObject> {

    // Start Method
    global Database.QueryLocator start(Database.BatchableContext batchContext){
    }

    // Execute Method
    global void execute(Database.BatchableContext batchContext, List<Event__c> eventList ){
    }

    // Finish Method
    global void finish(Database.BatchableContext batchContext){
    }
}
*/

public class DeleteEventBatch implements Database.Batchable<sObject> {

    // Start Method
    public Database.QueryLocator start(Database.BatchableContext batchContext){
        // LAST_N_DAYS:2, LAST_N_MONTHS:2, LAST_N_YEARS:2 => BuildIn Salesforce feature.
        String Query = 'Select Id, Name from Event__c where Live__c = false and End_Date_Time__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(Query);
    }

    // Execute Method
    public void execute(Database.BatchableContext batchContext, List<Event__c> eventList ){
        if(!eventList.isEmpty()){
            // delete eventList;
            List<Database.DeleteResult> deleteResult = Database.delete(eventList);

            for(Database.DeleteResult dr:deleteResult){
                if(!dr.isSuccess()){
                    list<Database.Error> errors = dr.getErrors();
                    String errorInString = String.join(errors, ' , ');
                    TransactionLogHandeler.doHandleExceptionWithError(errorInString, 'DeleteEventBatch');
                }
            }
        }
    }

    // Finish Method
    public void finish(Database.BatchableContext batchContext){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setSubject('Batch Processing Completed');
        List<String> toAddress = new List<String>();
        toAddress.add('debarghya.cts@gmail.com');
        mail.setToAddresses( toAddress );
        mail.setSenderDisplayName('Deba951');
        
        mail.setHtmlBody('The DeleteEventBatch Batch Prcoessing has been Completed');
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage> {mail};
        Messaging.sendEmail(emails);
    }
}