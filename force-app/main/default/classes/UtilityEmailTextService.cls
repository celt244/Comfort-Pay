public with sharing class UtilityEmailTextService {

    public static Blob getTextForAllUtilityPayment(UtilityPaymentStructure payment){
        Blob body;
        body = Blob.valueOf(
            'UTILITY BILL FOR ALL PAYMENT' + '\n\n\n' + 'Dear ' + payment.userName +  '!\n     Your payment was successful. Information about the payment: \n' + 
            'Total Debt: '+ payment.totalAmount + '\n' + 
            'Date of Payment: ' +  payment.datePay + '\n' + 
            'Gas Amount: ' + payment.gasAmount + '\n' + 
            'Gas meter reading: '+ payment.totalCountGas + '\n' + 
            'Water Amount: '+ payment.waterAmount + '\n' + 
            'Water meter reading: '+ payment.totalCountWater + '\n' + 
            'Electricity amount: ' + payment.electricityAmount + '\n' + 
            'Electricity meter reading: ' + payment.totalCountElectricity + '\n' + 
            'Region: '+ payment.region
        );

        return body;
    }

    public static Blob getTextForGasPayment(UtilityPaymentStructure payment){
        Blob body;
        body = Blob.valueOf(
            'UTILITY BILL FOR GAS' + '\n\n\n' + 'Dear ' + payment.userName +  '!\n     Your payment was successful. Information about the payment: \n' + 
            'Date of Payment: ' +  payment.datePay + '\n' + 
            'Gas Amount: ' + payment.gasAmount + '\n' + 
            'Gas meter reading: '+ payment.totalCountGas + '\n' + 
            'Region: '+ payment.region
        );

        return body;
    }

    public static Blob getTextForWaterPayment(UtilityPaymentStructure payment){
        Blob body;
        body = Blob.valueOf(
            'UTILITY BILL FOR WATER' + '\n\n\n' + 'Dear ' + payment.userName +  '!\n     Your payment was successful. Information about the payment: \n' + 
            'Date of Payment: ' +  payment.datePay + '\n' + 
            'Water Amount: '+ payment.waterAmount + '\n' + 
            'Water meter reading: '+ payment.totalCountWater + '\n' + 
            'Region: '+ payment.region
        );

        return body;
    }

    public static Blob getTextForElectricityPayment(UtilityPaymentStructure payment){
        Blob body;
        body = Blob.valueOf(
            'UTILITY BILL FOR ALL ELECTRICITY' + '\n\n\n' + 'Dear ' + payment.userName +  '!\n     Your payment was successful. Information about the payment: \n' + 
            'Date of Payment: ' +  payment.datePay + '\n' + 
            'Electricity amount: ' + payment.electricityAmount + '\n' + 
            'Electricity meter reading: ' + payment.totalCountElectricity + '\n' + 
            'Region: '+ payment.region
        );

        return body;
    }

    public static String getTextForSendPassword(String password){
        String body = 'Your password: ' + password;
        return body;
    }
    
    public static String getTextFromUser(String email){
        String body = email;
        return body;
    }

    public static String getTextForReminder(Contact contact){
        String body = 'Dear ' + contact.Name + ', please enter the readings of the counters and make the payment before the 5th day.';
        return body;
    }
    
    public static String getTextForDebtors(Contact contact){
        String body =   'Dear ' + contact.Name + ',' + '\n' + 
                        'you have a big debt for utilities. Please pay by the end of this month.' + '\n' +
                        'Debt of Electricity: ' + contact.Debt_Electricity__c + '\n' +
                        'Debt of Gas: ' + contact.Debt_Gas__c + '\n' +
                        'Debt of Water: ' + contact.Debt_Water__c + '\n' +
                        'Waiting for payment. All the best';
        return body;
    }
}