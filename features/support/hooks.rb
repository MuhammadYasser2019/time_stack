Before do

  def create_user
    u = User.new
    u.email = "test.user@test.com"
    u.password = "123456"
    u.encrypted_password
    u.save!
  end
  def create_task
    t = Task.new
    t.code = "007"
    t.description = "Test Description"
    t.save!
  end
  create_user
  create_task
  visit (new_user_session_path)
  page.fill_in "Email", :with => "test.user@test.com"
  page.fill_in "Password", :with => "123456"
  page.click_button "Log in"
end

