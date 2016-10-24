
Given(/^I am on the projects page$/) do
  visit (projects_path)
end

Then(/^I should be seeing "([^"]*)"$/) do |arg|
  page.should have_content(arg)
end