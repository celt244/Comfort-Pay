public with sharing class PDFBillController {

    private Id currentPaymentId;
    String userName;
    String userRegion;

    public PDFBillController() {
        userName = [SELECT Name FROM Utility_Payment__c WHERE id ='a0H2o00001jbH6t'].Name;
        userName = [SELECT Region__c FROM Utility_Payment__c WHERE id ='a0H2o00001jbH6t'].Region__c;
    }
    
    public String getUserName(){
        return userName;
    }
    
    public String getUserRegion(){
        return userRegion;
    }
    
}