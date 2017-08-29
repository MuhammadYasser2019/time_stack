Given(/^I am a customer manager$/) do
  create_customer_manager
end

Given(/^CM logs in with "([^"]*)" and "([^"]*)"$/) do |arg1, arg2|
  visit (user_session_path)
  page.fill_in "Email", :with => "cm.user@test.com"
  page.fill_in "Password", :with => "123456"
  page.click_button "Log in"
end

Then(/^I should see contentsss and "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Then(/^click on logout$/) do
  page.click_button "Logout"
end

Given(/^click on the button "([^"]*)"$/) do |arg1|
 page.click_link("Manage Projects")
end

Then(/^User clicks on the button "([^"]*)"$/) do |arg1|
 click_on(class: "create_project")
 # page.click_img("/assets/plus.jpg")
end

Then(/^User should see link to "([^"]*)"$/) do |new_project_link|
  expect(page).to have_link(new_project_link, href: "/projects/new")
end

Then(/^User clicks on New Project link$/) do
  page.click_link('New Project')
end

Then(/^User should see heading "([^"]*)"$/) do |new_project_heading|
  expect(page).to have_content(new_project_heading)
end

Given(/^Go to customers page$/) do
  visit (customers_path)
end

Then(/^Should see "([^"]*)" and "([^"]*)" link for customer$/) do |customer_heading, edit_customer_link|
  expect(page).to have_content(customer_heading)
  expect(page).to have_link(edit_customer_link)
end

Then(/^Should be able to see heading "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Then(/^Should see "([^"]*)"$/) do |listing_projects|
  page.should have_content(listing_projects)
end 

Then(/^Click on the edit link to edit the customer$/) do
  page.click_link("Edit" , href: "/customers/1/edit" )
end

Then(/^You should see "([^"]*)"$/) do |customer_editing_heading|
  expect(page).to have_content(customer_editing_heading)
  expect(find_field('Name').value).to eq ("Test")
end

Then(/^click on "([^"]*)" for a customer$/) do |destroy_customer_link|
  page.click_link(destroy_customer_link, href: "/customers/1")
end


Then(/^Click on "([^"]*)"$/) do |new_customer_link|
  page.click_link(new_customer_link, href: "/customers/new")
end

Then(/^Should see link to "([^"]*)"$/) do |project_name|
  expect(page).to have_content(project_name)
  #expect(page).to have_link(project_name, href: "/projects/1/edit")
end

Then(/^User should not see link to "([^"]*)"$/) do |project_name|
  expect(page).to have_no_link(project_name)
end

Given(/^click on "([^"]*)" link$/) do |arg1|
 page.click_link("Holidays")
end


Then(/^click the button "([^"]*)"$/) do |arg1|
  page.click_link(arg1, href: "/holidays/new")
end

Then(/^Click on the "([^"]*)"$/) do |arg1|
  page.click_link(arg1)
end


Then(/^Enter "([^"]*)" and "([^"]*)"$/) do |arg1, arg2|
  #page.click_link(href: "/holidays/new" )
  page.fill_in "Name", :with => "Labor Day"
  #select '09/04/2017', :from => "Date of holiday this year"
  page.fill_in 'holiday_date', :with => '09/04/2017'
  page.click_button "Submit Holiday"
end

Then(/^Enter a "([^"]*)"$/) do |arg1|
   page.fill_in "Name", :with => "Full Time"

end

Then(/^click button "([^"]*)"$/) do |arg1|
   #page.click_link(arg1, href: "employment_types/new?customer_id=1")
   #find("input[type=submit][value='Create Employment Type']").click
   click_button("Create Employment Type")
end


Then(/^page should have a button "([^"]*)"$/) do |arg1|
  expect(page).to have_button(arg1)
end


Then(/^click on the global checkbox$/) do
  #find("#holiday_global").set(true)
  #find('#Global holiday?').click
  expect(page).to have_selector("#holiday_global")
end