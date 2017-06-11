FactoryGirl.define do
  factory :process do
    process_id { Faker::Number.number(10) }
    process_name { Faker::Lorem.word }
  end
end