@IsTest
public class AccountControllerTest {

    @testSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = acc.Id
            ));
        }
        insert contacts;
    }

    @IsTest
    static void testUpdateAccountIndustryUpdatesAccountsAndContacts() {
        List<Account> accs = [SELECT Id, Industry FROM Account];
        AccountController ctrl = new AccountController();

        ctrl.updateAccountIndustry(accs);

        List<Account> updatedAccounts = [SELECT Id, Industry FROM Account];
        for (Account a : updatedAccounts) {
            System.assertEquals('Technology', a.Industry, 'Industry should be updated to Technology');
        }

        List<Contact> updatedContacts = [SELECT Id, Description FROM Contact];
        for (Contact c : updatedContacts) {
            System.assertEquals('Updated via AccountController', c.Description, 'Description should be updated');
        }
    }

    @IsTest
    static void testDeleteOldAccountsRemovesRecords() {
        Account oldAcc = new Account(Name = 'Old Account');
        insert oldAcc;

        Test.startTest();
        AccountController ctrl = new AccountController();
        ctrl.deleteOldAccounts();
        Test.stopTest();

        List<Account> remaining = [SELECT Id FROM Account WHERE Name = 'Old Account'];
        System.assertEquals(0, remaining.size(), 'Old accounts should be deleted');
    }
}