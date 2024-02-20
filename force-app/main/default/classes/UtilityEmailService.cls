public with sharing class UtilityEmailService {

    public static void sendEmalWhenAllUtilityPay(UtilityPaymentStructure payment){
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('bill.pdf');
        attach.setInline(false);
        attach.Body = UtilityEmailTextService.getTextForAllUtilityPayment(payment);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { payment.email });
        mail.setSubject('Utility bill');
        mail.setHtmlBody('Thank you for using the services of our site. Your payment was successful!');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

     public static void sendEmalWhenOnlyGasyPay(UtilityPaymentStructure payment){
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('GasBill.pdf');
        attach.setInline(false);
        attach.Body = UtilityEmailTextService.getTextForGasPayment(payment);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { payment.email });
        mail.setSubject('Gas utility bill');
        mail.setHtmlBody('Thank you for using the services of our site. Your payment was successful!');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });     
       } 

     public static void sendEmalWhenOnlyWaterPay(UtilityPaymentStructure payment){
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('WaterBill.pdf');
        attach.setInline(false);
        attach.Body = UtilityEmailTextService.getTextForWaterPayment(payment);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { payment.email });
        mail.setSubject('Water utility bill');
        mail.setHtmlBody('Thank you for using the services of our site. Your payment was successful!');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });     
       } 

     public static void sendEmalWhenOnlyElectricityPay(UtilityPaymentStructure payment){
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('ElectricityBill.pdf');
        attach.setInline(false);
        attach.Body = UtilityEmailTextService.getTextForElectricityPayment(payment);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { payment.email });
        mail.setSubject('Electricity utility bill');
        mail.setHtmlBody('Thank you for using the services of our site. Your payment was successful!');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }

     public static void sendEmailContainsPassword(Contact contact){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {contact.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Reminder Password');
        mail.plainTextBody = UtilityEmailTextService.getTextForSendPassword(contact.Password__c);
        System.debug('forgot password');
        System.debug(mail.plainTextBody);
        //Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
     
    public static void reminderOfPayment(Contact contact){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {contact.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Reminder of Payment');
        mail.plainTextBody = UtilityEmailTextService.getTextForReminder(contact);
        System.debug('reminder Of Payment');
        System.debug(mail.plainTextBody);
        //Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    public static void sendEmailToManager(Contact manager, String email){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {manager.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('User appeal');
        mail.plainTextBody = UtilityEmailTextService.getTextFromUser(email);
        System.debug('send Email ToManager');
        System.debug(mail.plainTextBody);
        //Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
    
    public static void sendEmailDebtors(Contact contact){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {contact.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('User appeal');
        mail.plainTextBody = UtilityEmailTextService.getTextForDebtors(contact);
        System.debug('send Email Debtors');
        System.debug(mail.plainTextBody);
        //Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }

}