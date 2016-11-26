Feature: Testing abilities of a User with PM role

  Scenario: On the weeks index manage project link should be present
    Given On the index page
    Then I should see link to "Enter Time for Current Week" and "Manage Projects"


#  # This scenario will use the step definitions form ablity_user_step.rb
#  Scenario: With PM roles user should be able to submit time sheet
#    Given If "Enter Time for Current Week" is clicked
#    Then HE should go to new time entries
#    And click "Save Timesheet"
#    And he should see Reports page

  Scenario: With PM roles user should be able to Approve And Reject timesheet
    Given User is on Weeks index
    And click on the "Manage Projects"
    Then Should see "Listing projects" and link to the project
    And click the project link
    And Text "Editing project" should be present