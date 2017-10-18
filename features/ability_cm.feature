Feature: Testing abilities of a User with CM role

  Scenario: On the weeks index manage project link should be present
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given On the index page


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
    Then I should see contentsss and "Pending Users"
    And click on the button "Manage Projects"
    Then User should see heading "Listing projects"
    And CM Expect page to have "plus"
    Then CM clicks on the button "plus"
    Then Expect page to have "New project"
 
  Scenario: 13) 14) 4) With CM roles user should be able to Edit Projects and Add Tasks #####and Approve/Reject timesheets.
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given User is on Weeks index
    And click on the "Manage Projects"
    Then Should see "Listing projects" 
    And Should be able to see heading "Tasks"
    And Should see "Add Task"
  
  Scenario: With CM roles user should able to make a vacation request
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given User is on Weeks index
    Then CM Expect page to have "Vacation Request"
    And CM clicks on "Vacation Request" link
    Then User should see "Reports for Users CM user" 
    And User should see "Your Vacation Requests"

  Scenario: 18) With CM role user should able to create New Holiday
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given User is on Weeks index
    And click on "Holidays" link
    Then click the button "Create New Holiday"
    And Enter "Name" and "Date of holiday this year"
   
  Scenario: 21) With CM role user should be able to create Employment Types
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given User is on Weeks index
    Then Click on the "Employment Types"
    And Click on the "Create New Employment Type"
    And Enter a "Name" 
    And page should have a button "Create Employment Type"
    And click button "Create Employment Type"

  Scenario: 26) CM should able to copy the timesheet from previous week
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And click "Save Timesheet"
    And Go to the index page
    And Expect page to have "NEW" link
    Then user should see the link "COPY"
    Then cm clicks on the link "COPY"
    Then User clicks on the "NEW" link
    And should see the "8" in "hours" field

  Scenario: 27) When the TimeSheet is submitted, there should be no COPY Link for that week
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    And Expect page to have link "SUBMITTED" but not "COPY" link

  Scenario: 28) When it is first TimeSheet, there should be NEW but no COPY link
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And click "Save Timesheet"
    And Go to the index page
    And Expect page to have link "NEW" but not "COPY"

  Scenario: 29) With CM role user should able to make shared employee and assign PM role
    Given I am a customer manager
    Given CM logs in with "Email" and "Password"
    Given User is on customers index
    Then page should have "Customer Employees" link
    Then click on "Customer Employees" link
    Then click on the shared checkbox
    Then go to customer index page
    Then the shared checkbox should be checked