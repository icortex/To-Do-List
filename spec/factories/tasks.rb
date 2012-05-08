# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task, aliases: :pending_task do

    name 'Buy milk'
    deadline Date.tomorrow
    done false

    factory :expired_task do
      deadline Date.yesterday
      done false
    end

    factory :done_task do
      deadline Date.today
      done true
    end

  end
end
