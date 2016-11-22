Given(/^On the index page$/) do
  visit (weeks_path)
end

Then(/^I should see link to "([^"]*)" and "([^"]*)"$/) do |arg1, arg2|
  expect(page).to have_link(arg1, href: '/weeks/new')
  expect(page).to have_link(arg2, href: 'projects')
end

Given(/^User is on Weeks index$/) do
  visit (weeks_path)
end

Given(/^click on the "([^"]*)"$/) do |projects_link|
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
