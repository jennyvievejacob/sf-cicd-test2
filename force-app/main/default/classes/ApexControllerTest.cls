@isTest
public class AccountControllerTest {

    // BAD: No meaningful test method names
    static void test1() {
        // BAD: No setup data isolation, using existing org data
        List<Account> accs = [SELECT Id, Industry FROM Account LIMIT 5];

        // BAD: Directly calling production code without assertions
        AccountController ctrl = new AccountController();
        ctrl.updateAccountIndustry(accs);
    }

    // BAD: No assertions, no validation of results
    static void test2() {
        AccountController ctrl = new AccountController();
        ctrl.deleteOldAccounts();
    }

    // BAD: Hardcoded IDs in test
    static void test3() {
        Account acc = new Account(Id = '001000000000001AAA');
        List<Account> accs = new List<Account>{ acc };

        AccountController ctrl = new AccountController();
        ctrl.updateAccountIndustry(accs);
    }
}
