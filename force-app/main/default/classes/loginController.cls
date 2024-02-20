public with sharing class loginController {

    public String mobile {get;set;}
    public String password {get;set;}

    public loginController(ApexPages.StandardController controller) {

    }

    public PageReference login(){
        try{
            Contact contact = [SELECT Id, MobilePhone, Password__c FROM Contact WHERE MobilePhone =:mobile LIMIT 1];
            String id = contact.Id;

                if((mobile == '' || mobile == null) || (password == '' || password == null)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, ConstantsErrorMessage.BLANK_FIELD_ON_LOGIN_PAGE));
                }
                if((mobile != '' && mobile != null && contact.MobilePhone != mobile) || 
                    (password != '' && password != null && contact.Password__c != password)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ConstantsErrorMessage.INVALID_VALUE));
                }

                if((contact.MobilePhone == mobile) && (contact.Password__c == password)){
                    PageReference page = Page.PersonalUserCabinet;
                    // page.getParameters().put('id', contact.Id);
                    page.setCookies(new Cookie[]{new Cookie('id', contact.Id, null, 300, true, 'None')});
                    page.setRedirect(true);
                    return page;
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }

    public Pagereference redirectToRegistrationPage(){
        PageReference ref = Page.registration;
        return ref;
    }
    
    public Pagereference redirectToForgotPasswordPage(){
        PageReference ref = Page.ForgotPassword;
        return ref;
    }

}