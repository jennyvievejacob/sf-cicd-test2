public with sharing class ContactController {

    public ContactController() {
    }

    /**
    * @description Searches for Contacts based on a search term (matches Last Name).
    * @param searchTerm - The string to look for in the Last Name.
    * @return List<Contact> - A list of matching Contact records.
    */
    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchTerm) {
        String searchPattern = '%' + searchTerm + '%';
        return [SELECT Id, FirstName, LastName, Email, Phone, Account.Name 
                FROM Contact 
                WHERE LastName LIKE :searchPattern 
                WITH SECURITY_ENFORCED
                LIMIT 50];
    }

    /**
    * @description Creates a new contact record.
    * @param firstName - First name of the contact.
    * @param lastName - Last name of the contact.
    * @param email - Email address.
    * @return Id - The ID of the created contact.
    */
    @AuraEnabled
    public static Id createContact(String firstName, String lastName, String email) {
        Contact newContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email
        );
        
        if (Schema.sObjectType.Contact.isCreateable()) {
            insert newContact;
        }
        return newContact.Id;
    }

    /**
    * @description Updates the phone number for a specific contact.
    * @param contactId - ID of the contact to update.
    * @param newPhone - New phone number.
    */
    @AuraEnabled
    public static void updateContactPhone(Id contactId, String newPhone) {
        Contact con = [SELECT Id, Phone FROM Contact WHERE Id = :contactId LIMIT 1];
        con.Phone = newPhone;
        
        if (Schema.sObjectType.Contact.isUpdateable()) {
            update con;
        }
    }
}