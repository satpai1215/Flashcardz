require 'spec_helper'

describe Deck do
  let(:user) {FactoryGirl.create(:user)}

  before {@deck = user.decks.build(title: "New Deck")}

  subject {@deck}

  it {should respond_to(:title)}
  it {should respond_to(:user)}
  its(:user) {should eq user}

  describe "belongs_to? method" do
  	it "should return true for correct user" do
  		expect(@deck.belongs_to? user).to be_true
  	end

  	let(:user2) {FactoryGirl.create(:user)}

  	it "should return false for incorrect user" do
  		expect(@deck.belongs_to? user2).to be_false
  	end
  end
end
