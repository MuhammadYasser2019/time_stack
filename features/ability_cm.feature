Feature: Testing abilities of a User with CM role

  Scenario: On the weeks index manage project link should be present
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given On the index page
    Then I should see link to "Enter Time for Current Week" and "Manage Projects"

  Scenario: 3) 6) With CM roles user should be able to submit time sheet and View Project Reports
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And click "Save Timesheet"
    And he should see Reports page
    And when user goes to projects reports page
    And he should see "Reports for Project "

  Scenario: 9) With CM roles user should be able to Add projects
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    And click on the "Manage Projects"
    Then User should see link to "New Project"
    Then User clicks on New Project link
    Then User should see heading "New project"

  Scenario: 13) 14) 4) With CM roles user should be able to Edit Projects and Edit Tasks #####and Approve/Reject timesheets.
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given User is on Weeks index
    And click on the "Manage Projects"
    Then Should see "Listing projects" and link to the project
    And click the project link
    And Text "Editing project" should be present
    And Should be abel to visit tasks page
    And Click on the "Edit" button for a particular task
    And Should see "Editing task" and "Test Description"

  Scenario: 12) With CM role user should be able to Edit Customers but not add or delete them.
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Then Go to customers page
    Then Shoud see "Listing customers" and "Edit" link for customer
    Then Click on the edit link to edit the customer
    Then You should see "Editing customer"
    And Go to customers page
    And click on "Destroy" for a customer
    Then User should see "You are not allowed to access this page."
    And Go to customers page
    And Click on "New Customer"
    Then User should see "You are not allowed to access this page."

  Scenario: 16) With CM role user should be able to delete a project
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given User is on Weeks index
    And click on the "Manage Projects"
    Then Should see link to "Time Entries"
    Then User clicks on "Destroy" link
    Then User should not see link to "Time Entries"