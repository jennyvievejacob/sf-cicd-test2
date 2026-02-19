public with sharing class AccountController {
    public void updateAccountIndustry(List<Account> accs) {
        if (accs == null || accs.isEmpty()) {
            return;
        }

        Set<Id> accountIds = new Set<Id>();
        for (Account a : accs) {
            if (a.Id != null) {
                accountIds.add(a.Id);
            }
        }

        List<Contact> contacts = [
            SELECT Id, Description, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
        ];

        for (Contact c : contacts) {
            c.Description = 'Updated via AccountController';
        }

        for (Account a : accs) {
            a.Industry = 'Technology';
        }

        try {
            if (!contacts.isEmpty()) {
                update contacts;
            }
            if (!accs.isEmpty()) {
                update accs;
            }
        } catch (DmlException e) {
            System.debug('Error updating records: ' + e.getMessage());
        }
    }

    public void deleteOldAccounts() {
        List<Account> accts = [
            SELECT Id
            FROM Account
            WHERE CreatedDate < :System.today().addDays(-30)
        ];

        if (!accts.isEmpty()) {
            try {
                delete accts;
            } catch (DmlException e) {
                System.debug('Error deleting accounts: ' + e.getMessage());
            }
        }
    }
}