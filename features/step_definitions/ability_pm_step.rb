
Given(/^I am a project manager$/) do
  create_project_manager
end

Given(/^PM logs in with "([^"]*)" and "([^"]*)"$/) do |email, password|
  # save_and_open_page
  visit (user_session_path)
  page.fill_in "Email", :with => "pm.user@test.com"
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

Then(/^when user goes to projects reports page$/) do
  visit ('/show_project_reports?id=1')
end

Then(/^he should see "([^"]*)"$/) do |project_report_heading|
  # save_and_open_page
  expect(page).to have_content(project_report_heading)
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

Then(/^User should see "([^"]*)"$/) do |not_allowed|
  expect(page).to have_content(not_allowed)
end

Then(/^User clicks on "([^"]*)" link$/) do |destroy_link|
  visit (projects_path)
  page.click_link destroy_link
end


Then(/^click the project link$/) do
  page.click_link('Time Entries')
end

Then(/^Text "([^"]*)" should be present$/) do |editing_project|
  # save_and_open_page
  page.should have_content(editing_project)
end



Then(/^Should be abel to visit tasks page$/) do
  visit (tasks_path)
end

Then(/^Click on the "([^"]*)" button for a particular task$/) do |edit_link|
  # save_and_open_page
  expect(page).to have_link(edit_link, href: '/tasks/1/edit')
  page.click_link edit_link
end

Then(/^Should see "([^"]*)" and "([^"]*)"$/) do |task_edit_heading, task_description|
  # save_and_open_page
  page.should have_content(task_edit_heading)
  expect(find_field('Description').value).to eq task_description
end

Then(/^Click on link "([^"]*)"$/) do |arg1|
  # save_and_open_page
  expect(page).to have_link("Add Task")
  find('#tasklist').find('a[href$="#"]').click
  sleep 5
end

Then(/^Fill the code and description of the task$/) do
  # save_and_open_page
  # page.click_link("Add Task")
  # expect(page).to have_css('task-code')
end
