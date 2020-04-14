FactoryBot.define do
  factory :shift do
    name { "MyString" }
    start_time { "2020-04-06 17:49:44" }
    end_time { "2020-04-06 17:49:44" }
    regular_hours { 1.5 }
    incharge { "MyString" }
    active { false }
    default { false }
    location { "MyString" }
    capacity { 1 }
    customer_id { 1 }
  end
end
