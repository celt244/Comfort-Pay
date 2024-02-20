public with sharing class ForgotPasswordController {

    public String mobile {get; set;}  
    public Contact contact;

    public Pagereference followOnForgotPasswordMessagePage(){

        if(mobile == '' || mobile == null){
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, ConstantsErrorMessage.EMPTY_FIELD_MOBILE));
       		return null;
        }

        try{
            contact = [SELECT Email, Password, MobilePhone FROM Contact WHERE MobilePhone =:mobile LIMIT 1];
            UtilityEmailService.sendEmailContainsPassword(contact);
            PageReference ref = Page.ForgotPasswordMessage;
            return ref;
        }catch(QueryException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ConstantsErrorMessage.MOBILE_NOT_FOUND));
        	return null;
        }
    }

    public Pagereference followBackToLoginPage(){
        PageReference ref = Page.login;
        return ref;
    }

}