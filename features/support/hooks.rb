module TestDataSetupHelper


  def create_task
    t = Task.new
    t.id = 1
    t.code = "007"
    t.description = "Test Description"
    # t.project_id = 1
    t.save!
  end

  def create_week
    w = Week.new
    w.id = 1
    w.status_id = 2
    w.save
  end

  def create_customer_manager
    u = User.new
    u.id = 1
    u.email = "cm.user@test.com"
    u.password = "123456"
    u.encrypted_password
    u.user = 1
    u.cm = 1
    u.save!

    create_task
    create_week

    s = Status.new
    s.id = 2
    s.status = "SUBMITTED"
    s.save

    p = Project.new
    p.id = 1
    p.name = "Time Entries"
    p.user_id = 1
    p.save

    c = Customer.new
    c.id = 1
    c.name = "Test"
    c.address = "Test"
    c.city = "Herndon"
    c.zipcode = "20170"
    c.save
  end


  def create_project_manager
    u = User.new
    u.id = 1
    u.email = "pm.user@test.com"
    u.password = "123456"
    u.encrypted_password
    u.user = 1
    u.pm = 1
    u.save!


    t = Task.new
    t.id = 1
    t.code = "007"
    t.description = "Test Description"
    # t.project_id = 1
    t.save!

    w = Week.new
    w.id = 1
    w.status_id = 2
    w.save

    s = Status.new
    s.id = 2
    s.status = "SUBMITTED"
    s.save


    p = Project.new
    p.id = 1
    p.name = "Time Entries"
    p.user_id = 1
    p.save

    c = Customer.new
    c.id = 1
    c.name = "Test"
    c.address = "Test"
    c.city = "Herndon"
    c.zipcode = "20170"
    c.save
  end

  def create_user
    u = User.new
    u.id = 1
    u.email = "test.user1@test.com"
    u.password = "1234567"
    u.encrypted_password
    u.user = 1


    u.save!


    t = Task.new
    t.code = "007"
    t.description = "Test Description"
    # t.project_id = 1
    t.save!

    w = Week.new
    w.id = 1
    w.save

    status

    # p = Project.new
    # p.id = 1
    # p.name = "Time Entries"
    # p.user_id = 1
    # p.save

  end

  def status
    s = Status.new
    if s.id == 1
      s.status = "NEW"
    elsif s.id == 2
      s.status = "SUBMITTED"
    end

    s.save
  end
end

World(TestDataSetupHelper)

# Before do
#
#
#   def create_user
#     u = User.new
#     u.id = 1
#     u.email = "test.user@test.com"
#     u.password = "123456"
#     u.encrypted_password
#     u.user = 1
#     # u.admin = 1
#     u.pm = 1
#     # u.cm = 1
#
#     u.save!
#     u
#   end
#   def create_task
#     t = Task.new
#     t.code = "007"
#     t.description = "Test Description"
#     # t.project_id = 1
#     t.save!
#   end
#
#   def create_customer
#     c = Customer.new
#     c.id =  1
#     c.name = "Test"
#     c.address = "21 Jump Stree"
#     c.city = "test"
#     c.state = "CA"
#     c.zipcode = "000"
#     # c.user_id = 1
#     c.save!
#   end
#
#   def create_project
#     p = Project.new
#     p.id = 1
#     p.name = "Time Entries"
#     p.user_id = 1
#     p.save!
#     p
#   end
#   def create_week
#     w = Week.new
#     w.id = 1
#     w.save
#   end
#
#   def create_projects_users
#     ps = ProjectsUser.new
#     ps.project_id = 1
#     ps.user_id = 1
#   end
#
#   def create_status
#     s = Status.new
#     s.id = 1
#     s.status = "NEW"
#     s.save
#   end
#
#   user = create_user
#   create_task
#   create_customer
#   project = create_project
#   user.projects << project
#   # create_status
#   visit (new_user_session_path)
#   page.fill_in "Email", :with => "test.user@test.com"
#   page.fill_in "Password", :with => "123456"
#   page.click_button "Log in"
# end

