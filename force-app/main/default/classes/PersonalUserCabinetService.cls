public with sharing class PersonalUserCabinetService {

    public static void calculateValue(Decimal curentValueCounter, Contact contact, String utility){
        Region__c region = [
            SELECT Id, Rate_Cas__c, Rate_Water__c, Rate_Electricity__c
            FROM Region__c
            WHERE id = :contact.Region__c LIMIT 1
        ];

            if(utility == ConstantsUtilities.GAS){
                if(curentValueCounter > contact.Prev_Gas__c){
                	contact.Debt_Gas__c = contact.Debt_Gas__c + ((curentValueCounter - contact.Prev_Gas__c) * region.Rate_Cas__c * -1);
                    contact.Prev_Gas__c = curentValueCounter;
                }
            }

            if(utility == ConstantsUtilities.WATER){
                if(curentValueCounter > contact.Prev_Water__c){
                	contact.Debt_Water__c += (curentValueCounter - contact.Prev_Water__c) * region.Rate_Water__c * -1;
                	contact.Prev_Water__c = curentValueCounter;
                }
            }

            if(utility == ConstantsUtilities.ELECTRICITY){
                if(curentValueCounter > contact.Prev_Electricity__c){
                	contact.Debt_Electricity__c += (curentValueCounter - contact.Prev_Electricity__c) * region.Rate_Electricity__c * -1;
                	contact.Prev_Electricity__c = curentValueCounter;
                }
            }

            update contact;
    }

    public static void paySeparately(Decimal curentAmount, Decimal curentValueCounter, Contact contact, String utility){
        if(utility == ConstantsUtilities.GAS){
            contact.Debt_Gas__c = contact.Debt_Gas__c + curentAmount;

            calculateValue(curentValueCounter, contact, utility);
        }

        if(utility == ConstantsUtilities.WATER){
            contact.Debt_Water__c = contact.Debt_Water__c + curentAmount;

            calculateValue(curentValueCounter, contact, utility);
        }

        if(utility == ConstantsUtilities.ELECTRICITY){
            contact.Debt_Electricity__c = contact.Debt_Electricity__c + curentAmount;

            calculateValue(curentValueCounter, contact, utility);
        }

        update contact;
    }
    
    public static void payAllUtilities(DataForPayAllUtilitiesStructure allData){
        Region__c region = [
            SELECT Id, Rate_Cas__c, Rate_Water__c, Rate_Electricity__c
            FROM Region__c
            WHERE Id = :allData.contact.Region__c
            LIMIT 1
        ];

        if(allData.currentValueGas > allData.contact.Prev_Gas__c){
            allData.contact.Debt_Gas__c -= (allData.currentValueGas - allData.contact.Prev_Gas__c) * region.Rate_Cas__c + allData.amountGas;
            allData.contact.Prev_Gas__c = allData.currentValueGas;
        } else{
            allData.contact.Debt_Gas__c += allData.amountGas;
        }

        if(allData.currentValueWater > allData.contact.Prev_Water__c){
            allData.contact.Debt_Water__c -=(allData.currentValueWater - allData.contact.Prev_Water__c) * region.Rate_Water__c + allData.amountWater;
            allData.contact.Prev_Water__c = allData.currentValueWater;
        } else {
            allData.contact.Debt_Water__c += allData.amountWater;
        }
        
        if(allData.currentValueElectricity > allData.contact.Prev_Electricity__c){
            allData.contact.Debt_Electricity__c -=(allData.currentValueElectricity - allData.contact.Prev_Electricity__c) * region.Rate_Electricity__c + allData.amountElectricity;
            allData.contact.Prev_Electricity__c = allData.currentValueElectricity;
        } else{
            allData.contact.Debt_Electricity__c += allData.amountElectricity;
        }
        
        update allData.contact;
    }
    
    public static Id createUtilityPayment(UtilityPaymentStructure payment){
        Utility_Payment__c newPayment = new Utility_Payment__c();
        newPayment.Amount__c = payment.totalAmount;
        newPayment.Amount_for_electricity__c = payment.electricityAmount;
        newPayment.amount_for_gas__c = payment.gasAmount;
        newPayment.amount_for_water__c = payment.waterAmount;
        newPayment.used_electricity__c = payment.totalCountElectricity;
        newPayment.used_gas__c = payment.totalCountGas;
        newPayment.used_water__c = payment.totalCountWater;
        newPayment.Contact__c = payment.userId;
        newPayment.User_name__c = payment.userName;
        newPayment.Region__c = payment.region;
        newPayment.Date_of_payment__c = payment.datePay;

        insert newPayment;
        return newPayment.Id;
    }

    public static Id createUtilityPaymentForGas(UtilityPaymentStructure payment){
        Utility_Payment__c newPayment = new Utility_Payment__c();
        newPayment.amount_for_gas__c = payment.gasAmount;
        newPayment.used_gas__c = payment.totalCountGas;
        newPayment.Contact__c = payment.userId;
        newPayment.User_name__c = payment.userName;
        newPayment.Region__c = payment.region;
        newPayment.Date_of_payment__c = payment.datePay;

        insert newPayment;        
        return newPayment.Id;
    }
    
    public static Id createUtilityPaymentForWater(UtilityPaymentStructure payment){
        Utility_Payment__c newPayment = new Utility_Payment__c();
        newPayment.amount_for_water__c = payment.waterAmount;
        newPayment.used_water__c = payment.totalCountWater;
        newPayment.Contact__c = payment.userId;
        newPayment.User_name__c = payment.userName;
        newPayment.Region__c = payment.region;
        newPayment.Date_of_payment__c = payment.datePay;

        insert newPayment;        
        return newPayment.Id;
    }

    public static Id createUtilityPaymentForElectricity(UtilityPaymentStructure payment){
        Utility_Payment__c newPayment = new Utility_Payment__c();
        newPayment.Amount_for_electricity__c = payment.electricityAmount;
        newPayment.used_electricity__c = payment.totalCountElectricity;
        newPayment.Contact__c = payment.userId;
        newPayment.User_name__c = payment.userName;
        newPayment.Region__c = payment.region;
        newPayment.Date_of_payment__c = payment.datePay;
        
        insert newPayment;        
        return newPayment.Id;
    }
}