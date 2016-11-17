# Given(/^User is on the index page$/) do
#   visit (weeks_path)
# end
#
# Then(/^He should see link to "([^"]*)" but not "([^"]*)"$/) do |arg1, arg2|
#   expect(page).to have_link(arg1, href: '/weeks/new')
#   expect(page).to have_no_link(arg2, href: 'projects')
# end
#
#
# Given(/^If "([^"]*)" is clicked$/) do |new_week_link|
#   expect(page).to have_link(new_week_link, href: '/weeks/new')
#   visit (weeks_path)
#   # page.click_link new_week_link
#   # find('a', :text => new_week_link).click
#   # click_link('new_week')
#   # find(:css, '#new_week').click
#   page.click_on new_week_link
# end
#
# Then(/^HE should go to new time entries$/) do
#   page.should have_content('New week')
#
# end
#
# Then(/^click "([^"]*)"$/) do |arg1|
#   click_button('Save Timesheet')
# end
#
# Then(/^he should see Reports page$/) do
#   page.should have_content('Report For')
# end
