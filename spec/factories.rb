# This will guess the User class
FactoryBot.define do
  factory :auth do
    client_id "MyString"
    client_secret "MyString"
    redirect_uri "MyString"
  end
  factory :project do
    project "MyString"
    description "MyString"
    client nil
  end
  factory :subtask do
    task "MyString"
    type ""
    points 1
    story nil
  end
  factory :story do
    task "MyString"
    type ""
    points 1
    epic nil
  end
  factory :epic do
    name "MyString"
    summary "MyText"
    client nil
  end
  factory :client do
    name "MyString"
    description "MyText"
    user nil
  end
    factory :user, class: User do
      name { Faker::Name.first_name }
      email  { Faker::Internet.email }
      password { "123456" }
      password_confirmation { "123456" }
      admin { false }
    end

    factory :admin, class: User do
        name { Faker::Name.first_name }
        email  { Faker::Internet.email }
        password { "123456" }
        password_confirmation { "123456" }
        admin { true }
      end
end