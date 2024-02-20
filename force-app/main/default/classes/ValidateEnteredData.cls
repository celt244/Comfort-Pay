public with sharing class ValidateEnteredData {

    public final static String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
    public final static String passwordRegex = '^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$';
    public final static String nameRegex = '^[a-zA-Z]+(([\',.-][a-zA-Z ])?[a-zA-Z]*)*$';

    public static Boolean validateEmail(String email) {
        Boolean result = true;

        Pattern pattern = Pattern.compile(emailRegex);
        Matcher matcher = pattern.matcher(email);
        
        if(!matcher.matches()){
            result = false;
        }
        return result;	
    }

    public static Boolean validatePassword(String password) {
        Boolean result = true;

        Pattern pattern = Pattern.compile(passwordRegex);
        Matcher matcher = pattern.matcher(password);
        
        if(!matcher.matches()){
            result = false;
        }
        return result;	
    }
    
    public static Boolean validateName(String name) {
        Boolean result = true;

        Pattern pattern = Pattern.compile(nameRegex);
        Matcher matcher = pattern.matcher(name);
        
        if(!matcher.matches()){
            result = false;
        }
        return result;	
    }


}