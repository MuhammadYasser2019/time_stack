# Given(/^I am on the tasks page$/) do
#   visit (tasks_path)
# end
#
# Then(/^I should see "([^"]*)" in the selector "([^"]*)"$/) do |text, selector|
#   page.first(selector).text.should == text
# end
#
# Then(/^I should see "([^"]*)" and "([^"]*)" and "([^"]*)" on selector "([^"]*)"$/) do |code, description, project, th|
#   page.first('table thead tr th[1]').text.should == code
#   page.first('table thead tr th[2]').text.should == description
#   page.first('table thead tr th[3]').text.should == project
# end
#
# Then(/^when you click on "([^"]*)" you should be redirected to "([^"]*)"$/) do |edit, arg2|
#   page.click_link(edit)
#   # expect(current_path).to eql("/tasks/8/edit")
# end