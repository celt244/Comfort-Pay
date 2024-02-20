public class registrationController {

    public String mobile {get;set;}
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String email {get;set;}
    public String city {get;set;}
    public String password {get;set;}
    public String confirmPassword {get;set;}

    public Contact contact {get;set;}
    public Id conId;
    public List<Region__c> regions;

    private static final Id CUSTOMER_RECORD_TYPE_ID = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ComfortPay_Customer').getRecordTypeId();

    public registrationController(ApexPages.StandardController controller){
        regions = [
            SELECT Id, Name
            FROM Region__c
        ];
    }

    public List<SelectOption> getCities(){
        List<Selectoption> cities = new List<selectoption>();
        cities.add(new selectOption('', '- None -'));

        for(String city : ConstantsUtilities.mapOfCities.keySet()){
            cities.add(new selectOption(city, ConstantsUtilities.mapOfCities.get(city)));
        }

        return cities;     
    }

    public PageReference registration(){
        if(isCreatedContact()){
            List<Contact> cons = [SELECT ID FROM Contact WHERE MobilePhone =:mobile LIMIT 1];

            if(!cons.isEmpty()){
                PageReference page = Page.PersonalUserCabinet;
                //page.getParameters().put('id', cons[0].Id);
                page.setCookies(new Cookie[]{new Cookie('id', cons[0].Id, null, 300, true, 'None')});
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }

    public Boolean isCreatedContact(){
        contact = new Contact();
        Id regionId = getRegionId();
        Boolean isSuccess = true;
        Boolean isCorrectEnteredData = true;

        if(isDuplicateMobile()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ConstantsErrorMessage.DUPLICATED_MOBILE));
            isCorrectEnteredData = false;
        }

        if(regionId == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, ConstantsErrorMessage.FILL_FIELD_CITY));
            isCorrectEnteredData = false;
        }

        if(firstName == '' || lastName == '' || mobile == '' || email == '' || password == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ConstantsErrorMessage.EMPTY_FIELDS));
            isCorrectEnteredData = false;
        }

        if(password != confirmPassword){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ConstantsErrorMessage.PASSWORD_NOT_CONFIRMED));
            isCorrectEnteredData = false;
        }

        if(email != '' && !ValidateEnteredData.validateEmail(email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ConstantsErrorMessage.EMAIL_INVALID));
            isCorrectEnteredData = false;
        }
        
        if(password != '' && !ValidateEnteredData.validatePassword(password)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ConstantsErrorMessage.PASSWORD_INVALID));
            isCorrectEnteredData = false;
        }

        if(firstName != '' && !ValidateEnteredData.validateName(firstName)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ConstantsErrorMessage.FIRSTNAME_INVALID));
            isCorrectEnteredData = false;
        }

        if(lastName != '' && !ValidateEnteredData.validateName(lastName)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ConstantsErrorMessage.LASTNAME_INVALID));
            isCorrectEnteredData = false;
        }

        if(isCorrectEnteredData){
            contact.FirstName = firstName;
            contact.LastName = lastName;
            contact.MobilePhone = mobile;
            contact.Email = email;
            contact.Password__c = password;
            contact.Region__c = regionId;
            contact.RecordTypeId = CUSTOMER_RECORD_TYPE_ID;
        }

        try{
            insert contact;

        } catch(DMLException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            isSuccess = false;
        }

        return isSuccess;
    }

    public Boolean isDuplicateMobile(){
        Boolean isDuplicate = false;
        List<Contact> contact = [SELECT MobilePhone FROM Contact WHERE MobilePhone =:mobile LIMIT 1];

        if(contact.size() != 0){
            isDuplicate = true;
        }

        return isDuplicate;
    }

    public Id getRegionId(){
        Id regionId;
        
        if(city == ConstantsUtilities.DNIPRO || city == ConstantsUtilities.KROPYVNYTSKYY){
            for(Region__c region : regions){
                if(region.Name == ConstantsUtilities.CENTER)
                    regionId = region.Id;
            }

            return regionId;
        }

        if(city == ConstantsUtilities.KHARKIV || city == ConstantsUtilities.MARIUPIL){
            for(Region__c region : regions){
                if(region.Name == ConstantsUtilities.EAST)
                    regionId = region.Id;
            }

            return regionId;            
        }

        if(city == ConstantsUtilities.KYIV || city == ConstantsUtilities.CHERNIGIV){
            for(Region__c region : regions){
                if(region.Name == ConstantsUtilities.NORTH)
                    regionId = region.Id;
            }

            return regionId;            
        }

        if(city == ConstantsUtilities.ODESA || city == ConstantsUtilities.KHERSON){
            for(Region__c region : regions){
                if(region.Name == ConstantsUtilities.SOUTH)
                    regionId = region.Id;
            }

            return regionId;            
        }

        if(city == ConstantsUtilities.LVIV || city == ConstantsUtilities.UZGOROD){
            for(Region__c region : regions){
                if(region.Name == ConstantsUtilities.WEST)
                    regionId = region.Id;
            }

            return regionId;
        }

        return null;
    }

    public Pagereference backToLoginPage(){
        PageReference ref = Page.login;
        return ref;            
    }

}