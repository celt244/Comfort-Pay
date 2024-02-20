public with sharing class ManagerCabinetController {

    public Decimal gas {get;set;}
    public Decimal water {get;set;}
    public Decimal electricity {get;set;}
    public List<Contact> RegionUsers {get;set;}

    private Contact contact;
    private Id currentContactId;
    private Id managerRegionId;
    public Region__c region;


    public ManagerCabinetController(ApexPages.StandardController controller) {
        //this.contact = (Contact)controller.getRecord();

        // this.currentContactId = controller.getRecord().Id;
        this.currentContactId = apexpages.currentPage().getCookies().get('id').getValue();
        this.contact = [SELECT Id, FirstName, Region__c FROM Contact WHERE id = :currentContactId];
        this.managerRegionId = contact.Region__c;
        region = [SELECT Id, Rate_Cas__c, Rate_Water__c, Rate_Electricity__c FROM Region__c WHERE id = :managerRegionId];
        RegionUsers = gerUsersByRegionName();
    }

    public Pagereference updateDefoultRateGas(){
        region.Rate_Cas__c = gas;
        ManagerCabinetService.updateRegionRates(region);
        return null;
    }

    public Pagereference updateDefoultRateWater(){
        region.Rate_Water__c = water;
        ManagerCabinetService.updateRegionRates(region);
        return null;
    }

    public Pagereference updateDefoultRateElectricity(){
        region.Rate_Electricity__c = electricity;
        ManagerCabinetService.updateRegionRates(region);
        return null;
    }

    public String getFirstName(){
        return contact.FirstName;
    }

    public Double getRateCas(){
        return region.Rate_Cas__c;
    }

    public Double getRateWater(){
        return region.Rate_Water__c;
    }

    public Double getRateElectricity(){
        return region.Rate_Electricity__c;
    }

    public List<Contact> gerUsersByRegionName(){
        List<Contact> contacts = ManagerCabinetService.getInfoAboutAllGegionByName(managerRegionId);
        return contacts;
    }

    public Pagereference followBackToUserCabinet(){
        PageReference ref = new PageReference('/apex/PersonalUserCabinet');
        ref.setCookies(new Cookie[]{new Cookie('id', currentContactId, null, 300, true, 'None')});
        ref.setRedirect(true);
        return ref;
    }

    public Pagereference followBackToLoginPage(){
        PageReference ref = new PageReference('/apex/login');
        ref.setCookies(new Cookie[]{new Cookie('id', '', null, -1, true)});
        return ref;
    }
}