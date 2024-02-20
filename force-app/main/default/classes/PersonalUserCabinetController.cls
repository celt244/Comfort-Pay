public class PersonalUserCabinetController {

    public Decimal currentValueGas {get;set;}
    public Decimal currentValueWater {get;set;}
    public Decimal currentValueElectricity {get;set;}
    public Decimal amountGas {get;set;}
    public Decimal amountWater {get;set;}
    public Decimal amountElectricity {get;set;}
    public String  newCity {get;set;}
    public String  emailToManager {get;set;}
    public Boolean displayPopup {get;set;}

    private Contact contact;
    private Contact manager;
    private Id currentContactId;
    private List<Region__c> regions;
    private Id currentPaymentId;
    private String currentRegion;
    private Region__c region;


    public List<Utility_Payment__c> utilityPayments {get;set;}
    public List<Utility_Payment__c> utilityPaymentsGAS {get;set;}
    public List<Utility_Payment__c> utilityPaymentsWATER {get;set;}
    public List<Utility_Payment__c> utilityPaymentsELECTRICITY {get;set;}


    //Pagination
    public Integer tot { get; set; }
    public Integer rec { get; set; }
    integer totalRecs = 0;
    integer count = 0;
    integer LimitSize= 5;


    public PersonalUserCabinetController(ApexPages.StandardController controller) {
        // this.currentContactId = controller.getRecord().Id;
        this.currentContactId = apexpages.currentPage().getCookies().get('id').getValue();

        this.contact = [
            SELECT Id, isManager__c, Name, Email, Region__c, Debt_Gas__c, Debt_Water__c, Debt_Electricity__c, Prev_Gas__c, Prev_Water__c, Prev_Electricity__c
            FROM Contact
            WHERE Id=:currentContactId
        ];

        utilityPayments = [
            SELECT Name, User_name__c, Amount__c, amount_for_gas__c, amount_for_water__c, Amount_for_electricity__c, Date_of_payment__c, Region__c, used_gas__c, used_water__c, used_electricity__c
            FROM Utility_Payment__c 
            WHERE Contact__c = :currentContactId 
            ORDER BY CreatedDate DESC 
            LIMIT:limitsize OFFSET:count
        ];

        utilityPaymentsGAS = [
            SELECT Name, User_name__c, Amount__c, amount_for_gas__c, Date_of_payment__c, Region__c, used_gas__c
            FROM Utility_Payment__c 
            WHERE   Contact__c = :currentContactId AND
                    amount_for_gas__c > 0 
            ORDER BY CreatedDate DESC 
            LIMIT:limitsize OFFSET:count
        ];

        utilityPaymentsWATER = [
            SELECT Name, User_name__c, Amount__c, amount_for_water__c, Date_of_payment__c, Region__c, used_water__c
            FROM Utility_Payment__c 
            WHERE   Contact__c = :currentContactId AND
                    amount_for_water__c > 0
            ORDER BY CreatedDate DESC 
            LIMIT:limitsize OFFSET:count
        ];

        utilityPaymentsELECTRICITY = [
            SELECT Name, User_name__c, Amount__c, Amount_for_electricity__c, Date_of_payment__c, Region__c, used_electricity__c
            FROM Utility_Payment__c
            WHERE   Contact__c = :currentContactId AND
                    Amount_for_electricity__c > 0
            ORDER BY CreatedDate DESC
            LIMIT:limitsize OFFSET:count
        ];
                                        
        // this.currentRegion = [SELECT Name FROM Region__c WHERE id=:contact.Region__c].Name;
        this.currentRegion = [SELECT Region__r.Name FROM Contact WHERE id=:currentContactId].Region__r.Name;
        System.debug(currentRegion);
        regions = [SELECT Id, Name FROM Region__c];
        region = [SELECT Rate_Cas__c, Rate_Water__c, Rate_Electricity__c FROM Region__c WHERE id=:contact.Region__c];
        manager = [SELECT Name, Email FROM Contact WHERE Region__c = :contact.Region__c AND isManager__c = true LIMIT 1];
        tot = totalRecs = [SELECT count() FROM Utility_Payment__c WHERE Contact__c = :currentContactId];
    }

    public Pagereference CalculateGas(){
        String utilityName = ConstantsUtilities.GAS;
        PersonalUserCabinetService.calculateValue(currentValueGas, contact, utilityName);
        return null;
    }

    public Pagereference CalculateWater(){
        String utilityName = ConstantsUtilities.WATER;
        PersonalUserCabinetService.calculateValue(currentValueWater, contact, utilityName);
        return null;
    }

    public Pagereference CalculateElectricity(){
        String utilityName = ConstantsUtilities.ELECTRICITY;
        PersonalUserCabinetService.calculateValue(currentValueElectricity, contact, utilityName);
        return null;
    }

    public Pagereference PayOnlyGas(){
        String utilityName = ConstantsUtilities.GAS;
        PersonalUserCabinetService.paySeparately(amountGas, currentValueGas, contact, utilityName);
        createUtilityPaymentForGas();
        return null;
    }

    public Pagereference PayOnlyWater(){
        String utilityName = ConstantsUtilities.WATER;
        PersonalUserCabinetService.paySeparately(amountWater, currentValueWater, contact, utilityName);
        createUtilityPaymentForWater();
        return null;
    }

    public Pagereference PayOnlyElectricity(){
        String utilityName = ConstantsUtilities.ELECTRICITY;
        PersonalUserCabinetService.paySeparately(amountElectricity, currentValueElectricity, contact, utilityName);
        createUtilityPaymentForElectricity();
        return null;
    }

    public Decimal getTotalDebt(){
        return contact.Debt_Gas__c + contact.Debt_Water__c + contact.Debt_Electricity__c;
    }
    
    public Pagereference PayAllUtilities(){
        DataForPayAllUtilitiesStructure allData = new DataForPayAllUtilitiesStructure();
        allData.amountGas = amountGas;
        allData.amountWater = amountWater;
        allData.amountElectricity = amountElectricity;
        allData.currentValueGas = currentValueGas;
        allData.currentValueWater = currentValueWater;
        allData.currentValueElectricity = currentValueElectricity;
        allData.contact = contact;

        PersonalUserCabinetService.payAllUtilities(allData);
        createUtilityPayment();
        return null;
    }
    
    public void createUtilityPayment(){
        UtilityPaymentStructure createPayment = new UtilityPaymentStructure();
        createPayment.totalAmount = getTotalDebt();
        createPayment.electricityAmount = amountElectricity;
        createPayment.gasAmount  = amountGas;
        createPayment.waterAmount = amountWater;
        createPayment.totalCountElectricity = currentValueElectricity;
        createPayment.totalCountGas = currentValueGas;
        createPayment.totalCountWater = currentValueWater;
        createPayment.userName = contact.Name;
        createPayment.userId = contact.Id;
        createPayment.region = currentRegion;
        createPayment.datePay = System.now();
        createPayment.email = contact.Email;
        currentPaymentId = PersonalUserCabinetService.createUtilityPayment(createPayment);
        
        UtilityEmailService.sendEmalWhenAllUtilityPay(createPayment);
    }

    public void createUtilityPaymentForGas(){
        UtilityPaymentStructure createPayment = new UtilityPaymentStructure();
        createPayment.gasAmount = amountGas;
        createPayment.totalCountGas = currentValueGas;
        createPayment.userName = contact.Name;
        createPayment.userId = contact.Id;
        createPayment.region = currentRegion;
        createPayment.datePay = System.now();
        createPayment.email = contact.Email;
        currentPaymentId = PersonalUserCabinetService.createUtilityPaymentForGas(createPayment);

        UtilityEmailService.sendEmalWhenOnlyGasyPay(createPayment);
    }

    public void createUtilityPaymentForWater(){
        UtilityPaymentStructure createPayment = new UtilityPaymentStructure();
        createPayment.waterAmount = amountWater;
        createPayment.totalCountWater = currentValueWater;
        createPayment.userName = contact.Name;
        createPayment.userId = contact.Id;
        createPayment.region = currentRegion;
        createPayment.datePay = System.now();
        createPayment.email = contact.Email;
        currentPaymentId = PersonalUserCabinetService.createUtilityPaymentForWater(createPayment);

        UtilityEmailService.sendEmalWhenOnlyWaterPay(createPayment);
    }

    public void createUtilityPaymentForElectricity(){
        UtilityPaymentStructure createPayment = new UtilityPaymentStructure();
        createPayment.electricityAmount = amountElectricity;
        createPayment.totalCountElectricity = currentValueElectricity;
        createPayment.userName = contact.Name;
        createPayment.userId = contact.Id;
        createPayment.region = currentRegion;
        createPayment.datePay = System.now();
        createPayment.email = contact.Email;
        currentPaymentId = PersonalUserCabinetService.createUtilityPaymentForElectricity(createPayment);

        UtilityEmailService.sendEmalWhenOnlyElectricityPay(createPayment);
    }

        
    public Boolean getIsDebtor(){
        return getTotalDebt() >= 0;
    }

    public String getUserRegion(){
        return currentRegion;
    }

    public Decimal getGasUserRegion(){
        return region.Rate_Cas__c;
    }

    public Decimal getWaterUserRegion(){
        return region.Rate_Water__c;
    }

    public Decimal getElectricityUserRegion(){
        return region.Rate_Electricity__c;
    }

    public Decimal getPrevElectricity(){
        return contact.Prev_Electricity__c;
    }

    public Decimal getDebtElectricity(){
        return contact.Debt_Electricity__c;
    }

    public Decimal getPrevGas(){
        return contact.Prev_Gas__c;
    }

    public Decimal getDebtGas(){
        return contact.Debt_Gas__c;
    }

    public Decimal getPrevWater(){
        return contact.Prev_Water__c;
    }

    public Decimal getDebtWater(){
        return contact.Debt_Water__c;
    }

    public Boolean getIsManager(){
        return contact.isManager__c;
    }

    public String getUserName(){
        return contact.Name;
    }

    public String getUserEmail(){
        return contact.Email;
    }
    
    public List<SelectOption> getCities(){
        List<Selectoption> cities = new List<selectoption>();
        cities.add(new selectOption('', '- None -'));

        for(String city : ConstantsUtilities.mapOfCities.keySet()){
            cities.add(new selectOption(city, ConstantsUtilities.mapOfCities.get(city)));
        }

        return cities;     
    }
    
    public Pagereference ChangeCity(){
        Id tempId;
            if(newCity == ConstantsUtilities.DNIPRO || newCity == ConstantsUtilities.KROPYVNYTSKYY){
                for(Region__c r : regions){
                    if(r.Name == ConstantsUtilities.CENTER)
                        tempId = r.Id;
                }
            }
            if(newCity == ConstantsUtilities.KHARKIV || newCity == ConstantsUtilities.MARIUPIL){
                for(Region__c r : regions){
                    if(r.Name == ConstantsUtilities.EAST)
                        tempId = r.Id;
                }
            }
            if(newCity == ConstantsUtilities.KYIV || newCity == ConstantsUtilities.CHERNIGIV){
                for(Region__c r : regions){
                    if(r.Name == ConstantsUtilities.NORTH)
                        tempId = r.Id;
                }
            }
            if(newCity == ConstantsUtilities.ODESA || newCity == ConstantsUtilities.KHERSON){
                for(Region__c r : regions){
                    if(r.Name == ConstantsUtilities.SOUTH)
                        tempId = r.Id;
                }
            }
            if(newCity == ConstantsUtilities.LVIV || newCity == ConstantsUtilities.UZGOROD){
                for(Region__c r : regions){
                    if(r.Name == ConstantsUtilities.WEST)
                        tempId = r.Id;
                }
            }
        contact.Region__c = tempId;
        update contact;

        return null;
    }
    
    public Pagereference followOnManagerCabinetPage(){
        PageReference ref = Page.ManagerCabinet;
        // ref.getParameters().put('id', currentContactId);
        ref.setCookies(new Cookie[]{new Cookie('id', currentContactId, null, 3000, true, 'None')});
        ref.setRedirect(true);
        return ref;
    }

    public Pagereference followBackLoginPage(){
        PageReference ref = Page.login;
        ref.setCookies(new Cookie[]{new Cookie('id', '', null, -1, true)});
        return ref;
    }

    public Pagereference sendEmailToManager(){
        UtilityEmailService.sendEmailToManager(manager, emailToManager);
        return null;
    }
    
    //Popup
    
    public void showPopupWithRate(){
        displayPopup = true;
    }
    
    public void closePopup(){
        displayPopup = false;
    }

    //Pagination

    public PageReference Firstbtn() {
        count=0;
        updatePage();
        return null;
    }

    public PageReference prvbtn() {
        count=count-limitsize;
        updatePage();
        return null;
    }

    public PageReference Nxtbtn() {
        count=count+limitsize;
        updatePage();
        return null;
    }
    
    public PageReference lstbtn() {
        count= totalrecs - math.mod(totalRecs,LimitSize);
        updatePage();
        return null;
    }

    public Boolean getPrv() {
        if(count== 0)
            return true;
        else
            return false;
    }

    public Boolean getNxt() {
        if((count+ LimitSize) > totalRecs)
            return true;
        else
            return false;
    }

    public void updatePage(){
        utilityPayments.clear();
        utilityPaymentsGAS.clear();
        utilityPaymentsWATER.clear();
        utilityPaymentsELECTRICITY.clear();
        limitsize=rec;

        utilityPayments = [
            SELECT Name, User_name__c, Amount__c, amount_for_gas__c, amount_for_water__c, Amount_for_electricity__c, Date_of_payment__c, Region__c, used_gas__c, used_water__c, used_electricity__c
            FROM Utility_Payment__c 
            WHERE Contact__c = :currentContactId 
            ORDER BY CreatedDate DESC 
            LIMIT:rec OFFSET:count
        ];
                            
        utilityPaymentsGAS = [
            SELECT Name, User_name__c, Amount__c, amount_for_gas__c, Date_of_payment__c, Region__c, used_gas__c
            FROM Utility_Payment__c 
            WHERE   Contact__c = :currentContactId AND
                    amount_for_gas__c > 0 
            ORDER BY CreatedDate DESC 
            LIMIT:rec OFFSET:count
        ];

        utilityPaymentsWATER = [
            SELECT Name, User_name__c, Amount__c, amount_for_water__c, Date_of_payment__c, Region__c, used_water__c
            FROM Utility_Payment__c 
            WHERE   Contact__c = :currentContactId AND
                    amount_for_water__c > 0 
            ORDER BY CreatedDate DESC 
            LIMIT:rec OFFSET:count
        ];

        utilityPaymentsELECTRICITY = [
            SELECT Name, User_name__c, Amount__c, Amount_for_electricity__c, Date_of_payment__c, Region__c, used_electricity__c
            FROM Utility_Payment__c 
            WHERE   Contact__c = :currentContactId AND
                    Amount_for_electricity__c > 0 
            ORDER BY CreatedDate DESC 
            LIMIT:rec OFFSET:count
        ];
    }
}