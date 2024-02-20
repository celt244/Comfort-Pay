global with sharing class TrackLargeAmountOfDebt implements Schedulable{

    global void execute(SchedulableContext ctx) {
        List<Contact> contacts = [
            SELECT Name, Email, Debt_Electricity__c, Debt_Gas__c, Debt_Water__c
            FROM Contact
            WHERE Region__c != null
        ];
        Decimal debt;

        for(Contact contact : contacts){
            debt += contact.Debt_Electricity__c + contact.Debt_Gas__c + contact.Debt_Water__c;
            
            if(debt < -5000){ 
                UtilityEmailService.sendEmailDebtors(contact);
            }
        }
    }
}