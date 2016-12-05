
Given(/^I am a project manager with a project$/) do
  create_project_manager
end

Given(/^PM logs in with "([^"]*)" and "([^"]*)"$/) do |email, password|
  # save_and_open_page
  visit (user_session_path)
  page.fill_in "Email", :with => "test.user@test.com"
  page.fill_in "Password", :with => "123456"
  page.click_button "Log in"
end

Given(/^On the index page$/) do
  visit (weeks_path)
end

Then(/^I should see link to "([^"]*)" and "([^"]*)"$/) do |arg1, arg2|
  # save_and_open_page
  expect(page).to have_link(arg1, href: '/weeks/new')
  expect(page).to have_link(arg2, href: 'projects')
end

Given(/^User is on Weeks index$/) do
  visit (weeks_path)
end

Given(/^click on the "([^"]*)"$/) do |projects_link|
  # save_and_open_page
  page.click_link projects_link
end

Then(/^Should see "([^"]*)" and link to the project$/) do |listing_projects|
  page.should have_content(listing_projects)
  expect(page).to have_link('Time Entries', href: '/projects/1/edit')
end

Then(/^click the project link$/) do
  page.click_link('Time Entries')
end

Then(/^Text "([^"]*)" should be present$/) do |editing_project|
  page.should have_content(editing_project)
end
