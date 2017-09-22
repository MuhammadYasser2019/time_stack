
Given(/^I am a user$/) do
  create_user
end

Given(/^user logs in with "([^"]*)" and "([^"]*)"$/) do |email, password|
  # save_and_open_page
  visit (user_session_path)
  page.fill_in "Email", :with => "test.user1@test.com"
  page.fill_in "Password", :with => "1234567"
  page.click_button "Log in"
end

Given(/^User is on the index page$/) do
  visit (weeks_path)
end


Then(/^He should see link to "([^"]*)" but not "([^"]*)"$/) do |arg1, arg2|
  expect(page).to have_link(arg1, href: '/weeks/new')
  expect(page).to have_no_link(arg2, href: 'projects')
end


Given(/^If "([^"]*)" is clicked$/) do |new_week_link|
  # save_and_open_page
  expect(page).to have_link(new_week_link, href: '/weeks/new')
  visit (weeks_path)
  page.click_on new_week_link
end

Then(/^HE should go to new time entries$/) do
  page.should have_content('New week')

end

Then(/^click on the "([^"]*)" link$/) do |arg1|
  page.click_link('NEW')
end

Then(/^click on "([^"]*)"$/) do |arg1|
  click_button('Submit Timesheet')
end

Then(/^click "([^"]*)"$/) do |arg1|
  expect(page).to have_content('New week')
  click_button('Save Timesheet')
end

Then(/^he should see Reports page$/) do
  page.should have_content('Report For')
end

Then(/^user see the link "([^"]*)"$/) do |arg1|
  expect(page).to have_link(arg1, href: '/vacation_request')
end

Then(/^user should see the link "([^"]*)"$/) do |arg1|
  create_first_week
  #visit (weeks_path)
  create_second_week
  visit (weeks_path)
  expect(page).to have_link(arg1, href: '/copy_timesheet/3')
end

Then(/^click on the link "([^"]*)"$/) do |arg1|
  create_time_sheet
  page.click_on arg1
  w= Week.find 3
  w.copy_last_week_timesheet(1)
  visit (weeks_path)

end

Then(/^Time Entries from the previous week are copied$/) do
  page.should have_content('New week')
end

Then(/^User clicks on the "([^"]*)" link$/) do |arg1|
   expect(page).to have_link(arg1, href: '/weeks/2/edit') 
end


Then(/^should see "([^"]*)" in "([^"]*)" field$/) do |arg1,arg2|
   visit('/weeks/2/edit')
   find_field("week_time_entries_attributes_0_project_id").find('option[selected]').text == arg1
end

Then(/^Expect page to have link "([^"]*)" but not "([^"]*)"$/) do |arg1, arg2|
  visit (weeks_path)
  expect(page).to have_link(arg1)
  expect(page).to have_no_link(arg2, href: '/copy_timesheet/2')
end

Then(/^Expect page to have link "([^"]*)" but not "([^"]*)" link$/) do |arg1, arg2|
  create_first_week
  create_second_week_and_submit
  visit (weeks_path)
  expect(page).to have_link(arg1)
  expect(page).to have_no_link(arg2, href: '/copy_timesheet/3')
end