public with sharing class TransactionLogHandeler {

    public static void doHandleException(System.Exception ex, String processName){
        Error_Log__c transactionLog = new Error_Log__c (
            Log_Details__c = ex.getStackTraceString() + ' <br/> <strong> Message is: </strong> ' + ex.getMessage() + ' <br/> ' + ex.getCause() + ' <br/> ' + ex.getTypeName() + ' <br/> ' + ex.getLineNumber(),
            Lod_DateTime__c = System.Now(),
            Process_Name__c = processName
        );

        // if(Schema.sObjectType.Error_Log__c.isCreated()){
            insert TransactionLog;
        // }
    }
}