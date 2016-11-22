#Feature: Testing the ability of a User with user role
#
#  Scenario: On index page should not see link to manage projects
#    Given User is on the index page
#    Then He should see link to "Enter Time for Current Week" but not "Manage Projects"
#
#  Scenario: User should be able to submit time sheet
#    Given If "Enter Time for Current Week" is clicked
#    Then HE should go to new time entries
#    And click "Save Timesheet"
#    And he should see Reports page
#
#
