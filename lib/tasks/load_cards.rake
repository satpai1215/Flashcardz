namespace :db do
	desc "Fill database with Sample"
	task populate: :environment do
		user = User.create!(name: "Satyan Pai", email: "test@example.com", password: "foobar", password_confirmation: "foobar")

		50.times do |n|
			name = Faker::Commerce.department
			user.decks.create!(title: name)
		end

		decks = user.decks
		decks.each do |deck|
			50.times do
				side_one = Faker::Lorem.sentence(4)
				side_two = Faker::Lorem.sentence(5)
				deck.flashcards.create!(side_one: side_one, side_two: side_two)
			end
		end
	end
end