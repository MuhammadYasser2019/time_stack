Feature: Testing abilities of a User with CM role

  Scenario: On the weeks index manage project link should be present
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given On the index page
    Then I should see link to "Enter Time for Current Week" and "Manage Projects"

  Scenario: 3) With CM roles user should be able to submit time sheet
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And click "Save Timesheet"
    And he should see Reports page

  Scenario: 13) 14) 4) With PM roles user should be able to Edit Projects and Edit Tasks #####and Approve/Reject timesheets.
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