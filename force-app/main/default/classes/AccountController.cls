public with sharing class AccountController {
    // BAD: No sharing keyword (defaults to without sharing, security risk)
    public void updateAccountIndustry(List<Account> accs) {
        
        for(Account a : accs) {
            // BAD: SOQL query inside a for loop (hits governor limits)
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :a.Id];
            
            for(Contact c : contacts)
                c.Description = 'Updated via bad class';
                // BAD: DML operation inside a nested loop (hits governor limits)
                update c;
            
            a.Industry = 'Technology';
            // BAD: DML inside a loop
            update a;
        }
    }
    
    // BAD: Hardcoded IDs and poor error handling
    public void deleteOldAccounts() {
        // BAD: Hardcoded IDs make deployment difficult
        List<Account> accts = [SELECT Id FROM Account WHERE CreatedDate < LAST_N_DAYS:30];
        
        // BAD: No try-catch block for DML exceptions
        delete accts; 
    }
}