Feature: Testing the ability of a User with user role

  Scenario: 21) On index page should not see link to manage projects
    Given I am a user
    Given user logs in with "Email" and "Password"
    Given User is on the index page
    Then He should see link to "Enter Time for Current Week" but not "Manage Projects"

  Scenario: 22) User should be able to submit time sheet
    Given I am a user
    Given user logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And click "Save Timesheet"
    And he should see Reports page
  
  Scenario: 23) User should able to copy the timesheet from previous week
    Given I am a user
    Given user logs in with "Email" and "Password"
    Given User is on the index page
    Then user should see the link "Copy"
    Then click on the link "Copy"
    Then User clicks on the "NEW" link
    And should see "Time Entries" in "project_id" field

  Scenario: 24) When the TimeSheet is submitted, there should be no Copy Link for that week
    Given I am a user
    Given user logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And click "Save Timesheet"
    And Go to the index page
    And Expect page to have "NEW" link
    And click on the "NEW" link
    And Expect page to have link "Save Timesheet" and "Submit Timesheet"
    And click on "Submit Timesheet"
    And Expect page to have link "SUBMITTED" but not "Copy" link

  Scenario: 25) When it is first TimeSheet, there should be NEW but no Copy link
    Given I am a user
    Given user logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And click "Save Timesheet"
    And Go to the index page
    And Expect page to have link "NEW" but not "Copy"
    

  


