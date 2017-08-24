Feature: Testing abilities of a User with PM role

  Scenario: On the weeks index manage project link should be present
    Given I am a project manager
    Given PM logs in with "Email" and "Password"
    Given On the index page
    # Then I should see link to "Enter Time for Current Week" and "Manage Projects"


  # This scenario will use the step definitions form ablity_user_step.rb
  Scenario: 3) 6) With PM roles user should be able to submit time sheet and View Project Reports
    Given I am a project manager
    Given PM logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And click "Save Timesheet"
    And he should see Reports page
    And when user goes to projects reports page
    And he should see "Reports for Project "

  #Scenario: 9) 16) With PM roles user should not be able to add or delete projects.
   # Given I am a project manager
   #Given PM logs in with "Email" and "Password"
   # And click on the button "Manage Projects"
   # Then Should see "Listing projects" and link to the project
   #Then User should see link to "New Project"
   #Then User clicks on New Project link
   #Then User should see "You are not allowed to access this page."
   #Then User clicks on "Deactivate" link
    #Then User should see "You are not allowed to access this page."


  Scenario: 13) 14) 4) With PM roles user should be able to Approve/Reject timesheets.
    Given I am a user
    Given user logs in with "Email" and "Password"
    Given If "Enter Time for Current Week" is clicked
    Then HE should go to new time entries
    And Select "Time Entries" from "project"
    And click "Save Timesheet"
    And Go to the index page
    And Expect page to have "NEW" link
    And click on the "NEW" link
    And Expect page to have link "Save Timesheet" and "Submit Timesheet"
    And click on "Submit Timesheet"
    Then click on logout
    Given PM logs in with "Email" and "Password"
    Given User is on Weeks index
    And he should see Time Sheets Submitted for Approval
    Then User should see "Approve" button
    Then User should see link to "Add Comment to Reject"
    

  Scenario: 10) With PM roles user should be able to Add Tasks
    Given I am a project manager
    Given PM logs in with "Email" and "Password"
    # And click on the button "Manage Projects"
    #Then Should see "Listing projects" and link to the project
    # And click the project link
    #And Text "Editing project" should be present
    #And Click on link "Add Task"
    #And Fill the code and description of the task
    And Should be able to see heading "Tasks"
    And Should see "Add Task"
    And Fill the code and description of the task

  Scenario: 12) 15) With PM roles user should not be able to Edit a Customer
    Given I am a project manager
    Given PM logs in with "Email" and "Password"
    Then Go to customers page
    Then User should see "You are not allowed to access this page."


  Scenario: With Pm roles user should be able to assign adhoc PM
    Given I am a project manager
    Given PM logs in with "Email" and "Password"
    # And click on the button "Manage Projects"
    Then Should see "Listing projects" 
    # And click the project link
    # And Text "Editing project" should be present
    Then User should see label "Adhoc Project Manager"
   

