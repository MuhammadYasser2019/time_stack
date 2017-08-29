
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
  click_button('Save Timesheet')
end

Then(/^he should see Reports page$/) do
  page.should have_content('Report For')
end
