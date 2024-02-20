public with sharing class ManagerCabinetService {

    public static void updateRegionRates(Region__c regions){
        update regions;
    }

    public static List<Contact> getInfoAboutAllGegionByName(Id regionId){
        List<Contact> contacts = [
            SELECT  Name,
                    Debt_Electricity__c,
                    Debt_Gas__c,
                    Debt_Water__c,
                    Prev_Electricity__c,
                    Prev_Gas__c,
                    Prev_Water__c
            FROM Contact
            WHERE Region__c = :regionId
        ];
        
        return contacts;
    }

}