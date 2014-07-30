FactoryGirl.define do
	factory :user do
		sequence(:email)	{|n| "person_#{n}@example.com"} 
		password "tester"
		password_confirmation "tester"
	end

end