global with sharing class monthlyPaymentReminder implements Schedulable{

    global void execute(SchedulableContext ctx) {
        List<Contact> contacts = [SELECT Name, Email FROM Contact WHERE Region__c != null];

        for(Contact contact : contacts){
            UtilityEmailService.reminderOfPayment(contact);
        }
    }
}