require 'spec_helper'

describe User do
	let(:user) {FactoryGirl.create(:user)}

	subject {user}

	it {should respond_to(:email)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:remember_token)}

	it {should be_valid}

	describe "remember token" do
		before {user.save}
		its(:remember_token) {should_not be_blank}
	end

	describe "when email is not present" do
		before {user.email = ""}
		it {should_not be_valid}
	end

	describe "when email is already taken" do
  		it "should not be valid" do
  			FactoryGirl.build(:user, email: user.email).should_not be_valid
  		end
	end

end
