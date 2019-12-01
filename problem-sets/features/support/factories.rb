FactoryBot.define do
  factory :admin, class: User do
    id { 1 }
    first_name { "Joe" }
    last_name { "Joe" }
    email { "joe_joe@ait.asia" }
    password { "password" }
    is_admin { true }
  end

  factory :user1, class: User do
    id { 2 }
    first_name { "User" }
    last_name { "One" }
    email { "user_oneoneone@ait.asia" }
    password { "password" }
    is_admin { false }
  end

  factory :secondary_user, class: User do
    id { 3 }
    first_name { "John" }
    last_name { "Doe" }
    email { "jdoe@ait.asia" }
    password { "password" }
    is_admin { false }
  end

  factory :group1, class: Group do
    id { 1 }
    name { "SV90" }
    user_id { 2 }
  end

  factory :user1group1, class: UserGroup do
    user_id { 2 }
    group_id { 1 }
  end

  factory :usergroup1, class: UserGroup do
    id { 1 }
    group_id { 1 }
    user_id { 2 }
  end
end