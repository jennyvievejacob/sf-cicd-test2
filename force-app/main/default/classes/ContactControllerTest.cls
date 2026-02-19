@IsTest
public class ContactControllerTest {

    // Utility method to create a test Contact
    private static Contact createTestContact(String firstName, String lastName, String email, String phone) {
        Contact c = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Phone = phone
        );
        insert c;
        return c;
    }

    @IsTest
    static void testSearchContacts() {
        // Arrange
        Contact c1 = createTestContact('John', 'Doe', 'john.doe@example.com', '1234567890');
        Contact c2 = createTestContact('Jane', 'Smith', 'jane.smith@example.com', '0987654321');

        // Act
        Test.startTest();
        List<Contact> results = ContactController.searchContacts('Doe');
        Test.stopTest();

        // Assert
        System.assertEquals(1, results.size(), 'Should return only one contact with last name matching Doe');
        System.assertEquals(c1.Id, results[0].Id, 'Returned contact should match the inserted Doe contact');
    }

    @IsTest
    static void testCreateContact() {
        // Act
        Test.startTest();
        Id newContactId = ContactController.createContact('Alice', 'Johnson', 'alice.johnson@example.com');
        Test.stopTest();

        // Assert
        Contact created = [SELECT FirstName, LastName, Email FROM Contact WHERE Id = :newContactId];
        System.assertEquals('Alice', created.FirstName);
        System.assertEquals('Johnson', created.LastName);
        System.assertEquals('alice.johnson@example.com', created.Email);
    }

    @IsTest
    static void testUpdateContactPhone() {
        // Arrange
        Contact c = createTestContact('Bob', 'Marley', 'bob.marley@example.com', '1111111111');

        // Act
        Test.startTest();
        ContactController.updateContactPhone(c.Id, '2222222222');
        Test.stopTest();

        // Assert
        Contact updated = [SELECT Phone FROM Contact WHERE Id = :c.Id];
        System.assertEquals('2222222222', updated.Phone, 'Phone number should be updated');
    }
}